# MAS Marketing Blog

[![Build Status](https://travis-ci.org/moneyadviceservice/publify.png)](https://travis-ci.org/moneyadviceservice/publify)
[![Code Climate](https://codeclimate.com/github/moneyadviceservice/publify.png)](https://codeclimate.com/github/moneyadviceservice/publify)
[![Dependency Status](https://gemnasium.com/moneyadviceservice/publify.png)](https://gemnasium.com/moneyadviceservice/publify)

## What is this?

The marketing blog application for the Money Advice Service.

## What's Publify?

We forked the blogging engine - Publify for purposes of the MAS Marketing Blog.

The feeling was that we would diverge far enough that tracking/merging upstream would be an issue.

Publify has been around since 2004 and is the oldest Ruby on Rails open source project alive.

## Installation

### Prerequisites

Ruby 2.1.3

```bash
$ bundle install
$ cp config/database.yml.mysql config/database.yml
$ rake db:create
$ rake db:migrate
$ rake db:seed
$ rails s
```

## Testing

```bash
$bundle exec rspec
```

Run with `COVERAGE=true` in your test environment to report on coverage.
