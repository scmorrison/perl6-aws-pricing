use Test;
use AWS::Pricing;

plan 2;

my $tmp_cache_dir = $*TMPDIR ~ "/aws-pricing-config-test";
AWS::Pricing::config(cache_dir => $tmp_cache_dir);


# list-offers
my $cached_offers_path = "$tmp_cache_dir/offers.json";
copy 't/offers.json', $cached_offers_path;
my $cached_offers = slurp $cached_offers_path;
my $offers = AWS::Pricing::list-services;
is $offers, $cached_offers, 'list-offers 1/1';

# service-offers
my $service_code = 'AmazonS3';
my $service_offers_file = "service-offers-$service_code.json";
my $cached_service_offers_path = "$tmp_cache_dir/$service_offers_file";
copy "t/$service_offers_file", $cached_service_offers_path;
my $cached_service_offers = slurp $cached_service_offers_path;
my $service_offers = AWS::Pricing::service-offers($service_code);
is $service_offers, $cached_service_offers, 'service-offers 1/1';

# Cleanup
for dir $tmp_cache_dir -> $file {
  # Delete cached files
  unlink $file;
}

# Delete tmp cache directory
rmdir $tmp_cache_dir;
