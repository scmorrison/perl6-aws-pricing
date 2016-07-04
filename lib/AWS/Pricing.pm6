#!/usr/bin/env perl6

use v6;

use HTTP::Tinyish;

unit module AWS::Pricing:ver<0.2.0>:auth<github:scmorrison>;

our $aws_region = 'us-east-1';
our $api_version = 'v1.0';
our $cache_path = "$*HOME/.aws-pricing";

my $refresh_cache = False;
my $aws_pricing_api_uri;
my @offer_codes = ["AmazonS3",
                   "AmazonGlacier",
                   "AmazonSES",
                   "AmazonRDS",
                   "AmazonSimpleDB",
                   "AmazonDynamoDB",
                   "AmazonEC2",
                   "AmazonRoute53",
                   "AmazonRedshift",
                   "AmazonElastiCache",
                   "AmazonCloudFront",
                   "awskms",
                   "AmazonVPC"];

sub path-exists(Str $path, Str $type) {
  if $type ~~ 'f' { return $path.IO ~~ :f }
  if $type ~~ 'd' { return $path.IO ~~ :d }
}

sub cache_dir(Str $cache_path) {
  $cache_path = IO::Path.new("$cache_path").Str; 
  if !path-exists($cache_path, 'd') { mkdir $cache_path }
}

sub load-from-cache(Str $cache_file) {
  return slurp $cache_file;
}

sub write-to-cache(Str $cache_file, Str $data) {
  if !path-exists($cache_path, 'd') { mkdir $cache_path }
  return spurt $cache_file, $data;
}

sub request(Str $url, Str $method='GET') {

    my $http = HTTP::Tinyish.new(agent => "perl6-aws-pricing/0.1.0");
    my %res;
    if $method ~~ 'GET' {
        %res = $http.get($url); 
    } elsif $method ~~ 'PUT' {
        %res = $http.put($url); 
    }

    if (!%res<success>) {
        say "Error: {%res<reason>}";
    }

    return %res<content>;
}

our sub list-services {

    my $offers_cache = "$cache_path/offers.json";

    # Do we have a cached service list
    if !$refresh_cache and path-exists($offers_cache, 'f') {
      return load-from-cache $offers_cache;
    }

    # Reqest all Services available and their Current Offer URLs
    my $current_offers_url = "https://pricing." ~ $aws_region ~ ".amazonaws.com/offers/" ~ $api_version ~ "/aws/index.json";
    my $offers = request($current_offers_url, 'GET');
    
    if write-to-cache($offers_cache, $offers) {
      return $offers;
    }

}

our sub service-offers(Str $offer_code) {
    # Get Current Offers for specific Service

    my $service_offers_cache = "$cache_path/service-offers-$offer_code.json";
    # Do we have a cached service list
    if !$refresh_cache and path-exists($service_offers_cache, 'f') {
      return load-from-cache $service_offers_cache;
    }

    # Confirm $offer_code is valid
    if (!@offer_codes.first: $offer_code) {
        say "Invalid Offer Code. Please use one of the following: \n" ~ @offer_codes;
    }

    my $offer_url = "https://pricing." ~ $aws_region ~ ".amazonaws.com/offers/" ~ $api_version ~ "/aws/" ~ $offer_code ~ "/current/index.json";
    my $service_offers = request($offer_url, 'GET');

    if write-to-cache($service_offers_cache, $service_offers) {
      return $service_offers;
    }

}

our sub config(Str :$cache_dir,
               Str :$region,
               Str :$api_ver,
               Bool :$refresh) {

  if $cache_dir.defined {
    $cache_path = IO::Path.new($cache_dir.subst('~', $*HOME)).Str; 
    if !path-exists($cache_path, 'd') { mkdir $cache_path }
  }

  if $region.defined {
    $aws_region = $region;
  }

  if $api_ver.defined {
    $api_version = $api_ver;
  }

  if $refresh.defined {
    $refresh_cache = True;
  }
  
}


