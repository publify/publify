# MAS Marketing Blog

[ ![Codeship Status for moneyadviceservice/publify](https://codeship.com/projects/8a2f2790-5b98-0132-5602-3ea96c7cff98/status)](https://codeship.com/projects/50564)
[![Build Status](https://travis-ci.org/moneyadviceservice/publify.png)](https://travis-ci.org/moneyadviceservice/publify)
[![Code Climate](https://codeclimate.com/github/moneyadviceservice/publify.png)](https://codeclimate.com/github/moneyadviceservice/publify)
[![Dependency Status](https://gemnasium.com/moneyadviceservice/publify.png)](https://gemnasium.com/moneyadviceservice/publify)

## What is this?

The marketing blog application for the Money Advice Service.

## What's Publify?

We forked the blogging engine - Publify for purposes of the MAS Marketing Blog.

The feeling was that we would diverge far enough that tracking/merging upstream would be an issue.

Publify has been around since 2004 and is the oldest Ruby on Rails open source project alive.

## How do I run it?

### Installation

#### Prerequisites

- Ruby 2.1.3
- Node.js
- Bower
- MYSQL

This repository comes equipped with a self-setup script:

```bash
$ ./bin/setup
$ rails s
```

You'll need to set the environment keys this repo requires in `.env` (which is auto generated when you run the setup script). If you're a MAS dev, you can grab these over at the [company wiki](https://moneyadviceserviceuk.atlassian.net/wiki/display/DEV/Marketing+Blog+Repo+Credentials).

#### Testing

```bash
$bundle exec rspec
```

Run with `COVERAGE=true` in your test environment to report on coverage.

```bash
$ ./node_modules/karma/bin/karma start ./spec/js/karma.conf.js --single-run
$ ./node_modules/jscs/bin/jscs app/assets/javascripts/components/
$ ./node_modules/jshint/bin/jshint app/assets/javascripts/components/ --config .jshintrc
```


#### Deploying

**Assets**

This repo uses the [asset sync](https://github.com/rumblelabs/asset_sync) gem to synchronise and store assets to Rackspace Cloud Files when deploying.

**Staging**

  * Make sure you have a copy of `.env` in the project root 
    * This file should contain the necessary environment variables for deployment
  * Make sure you are working from an up to date version of master
  * Run `./bin/deploy`


