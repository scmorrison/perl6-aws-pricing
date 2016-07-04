AWS::Pricing [![Build Status](https://travis-ci.org/scmorrison/perl6-aws-pricing.svg?branch=master)](https://travis-ci.org/scmorrison/perl6-aws-pricing)
============

Description
===========

Return current offers from the AWS Price List API.

Usage
=====

```bash
Usage:
  ./bin/aws-pricing [--cache_dir=<Str>] [--region=<Str>] list services [<refresh>] 
  ./bin/aws-pricing [--cache_dir=<Str>] [--region=<Str>] service offers <service> [<refresh>]
```

Modules and utilities
=====================

AWS::Pricing
--------------

```perl6
use AWS::Pricing;

# List all Service Offer indexes
say AWS::Pricing::list-offers();
	
# List current offers for specific service
say AWS::Pricing::service-offers("AmazonS3");

```

### Valid service codes:

* AmazonS3
* AmazonGlacier
* AmazonSES
* AmazonRDS
* AmazonSimpleDB
* AmazonDynamoDB
* AmazonEC2
* AmazonRoute53
* AmazonRedshift
* AmazonElastiCache
* AmazonCloudFront
* awskms
* AmazonVPC


Installation
============

Install directly with "panda":

    # From the source directory
   
		panda install .

		# Or with helper script

    ./scripts/install.sh


Testing
=======

To run tests:

```
$ prove -e "perl6 -Ilib"
```

Todo
====

* ~~Cache offer files, these are large~~
* Search offers (must cache first)
* Tests

See also
========

* http://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/price-changes.html

Authors
=======

  * Sam Morrison

Copyright and license
=====================

Copyright 2015 Sam Morrison

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.
