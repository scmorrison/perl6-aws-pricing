use Test;
use AWS::Pricing;

plan 2;

AWS::Pricing::config(cache_dir => 't');

# list-offers
my $cached_offers_path = "t/offers.json";
my $cached_offers = slurp $cached_offers_path;
my $offers = AWS::Pricing::list-services;
is $offers, $cached_offers, 'list-offers 1/1';

# service-offers
my $service_code = 'AmazonS3';
my $cached_service_offers_path = "t/service-offers-$service_code.json";
my $cached_service_offers = slurp $cached_service_offers_path;
my $service_offers = AWS::Pricing::service-offers($service_code);
is $service_offers, $cached_service_offers, 'service-offers 1/1';
