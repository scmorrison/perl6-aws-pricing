use Test;
use AWS::Pricing;

plan 2;

# use
use-ok('AWS::Pricing');

# shortname
is AWSPricing, AWS::Pricing, 'shortname, 1/1';
