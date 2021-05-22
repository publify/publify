# Publify

**The Ruby on Rails publishing software formerly known as Typo**

[![Build status](https://github.com/publify/publify/actions/workflows/ruby.yml/badge.svg)](https://github.com/publify/publify/actions/workflows/ruby.yml)
[![Code Climate](https://codeclimate.com/github/publify/publify.svg)](https://codeclimate.com/github/publify/publify)
[![Reviewed by Hound](https://img.shields.io/badge/Reviewed_by-Hound-8E64B0.svg)](https://houndci.com)

## What's Publify?

Publify is a simple but full featured web publishing software. It's built
around a blogging engine and a small message system connected to Twitter.

Publify follows the principles of the IndieWeb, which are self hosting your Web
site, and Publish On your Own Site, Syndicate Everywhere.

Publify has been around since 2004 and is the oldest Ruby on Rails open source
project alive.

## Features

- A classic multi user blogging engine
- Short messages with a Twitter connection
- Text filters (Markdown, SmartyPants, @mention to link, #hashtag to link)
- A widgets system and a plugin API
- Custom themes
- Advanced SEO capabilities
- Multilingual : Publify is (more or less) translated in English, French,
  German, Danish, Norwegian, Japanese, Hebrew, Simplified Chinese, Mexican
  Spanish, Italian, Lithuanian, Dutch, Polish, Romanian…

## Demo site

You can [give Publify a try](https://demo-publify.herokuapp.com/)

The login / password [to the admin](https://demo-publify.herokuapp.com/admin)
are:

- Administrator: admin / admin123
- Publisher: demo / demo1234

The demo is reset every hour.

## Install

### Download

You can download the latest
Publify [stable release](https://github.com/publify/publify/releases/latest).

If you want to run the master branch, you can [clone the Publify
repository](https://github.com/publify/publify.git). However, random things may
be broken there at any time, so tread carefully!

**Running the master branch in production is not recommended!**

### Install Publify locally

To install Publify you need the following:

- CRuby (MRI) 2.4, 2.5, 2.6 or 2.7
- Ruby on Rails 5.2.x
- A database engine, MySQL, PgSQL or SQLite3
- A compatible JavaScript installation for asset compilation. See
  [the execjs readme](https://github.com/sstephenson/execjs#readme) for details.
- ImageMagick (used by `mini_magick`).

1.  Unzip Publify archive
2.  Rename database.yml.yourEngine as database.yml
3.  Edit database.yml to add your database name, login and password.

```bash
$ bundle install
$ rake db:setup
$ rake db:migrate
$ rake db:seed
$ rake assets:precompile
$ rails server
```

You can now launch you browser and access 127.0.0.1:3000.

### Install Publify on a server

You can use your preferred installation method (e.g., Capistrano) to install
Publify on a server. You will also need to set up the environment so it
contains at least `SECRET_KEY_BASE`. Your web server may allow you to set this,
or you can consider using a tool like `dotenv`.

### Install Publify on Heroku

In order to install Publify on Heroku, you’ll need to do some minor tweaks.

First of all, you need to set up Amazon S3 storage to be able to upload files on
your blog. Set Heroku config vars.

```bash
heroku config:set PROVIDER=AWS
heroku config:set AWS_ACCESS_KEY_ID=<your_aws_access_key_id>
heroku config:set AWS_SECRET_ACCESS_KEY=<your_aws_secret_access_key>
heroku config:set AWS_BUCKET=<your_aws_bucket_name>
```

Next, you need to update `Gemfile`. You should remove the `mysql2` and
`sqlite3` gems, set the Ruby version, and add `rails_12factor`. The top of your
`Gemfile` should look something like this:

```ruby
source 'https://rubygems.org'

ruby '2.4.3' # Or whichever version you're running
gem 'pg'
gem 'rails_12factor'

gem 'rails', '~> 5.2.6'
```

Next, to regenerate the Gemfile.lock, run:
```bash
bundle install
```

Commit your updated `Gemfile` and `Gemfile.lock`:

```bash
git commit -am 'Update bundle for Heroku'
```

Create a file `Procfile` containing the following:
```
web: bundle exec puma -C config/puma.rb
```

Commit your new `Procfile`:
```bash
git add Procfile
git ci -m 'Tell Heroku how to run Rails'
```

You also need to set Rails' secret key base. Generate one using `rake secret`,
then set the Heroku config var:

```bash
heroku config:set SECRET_KEY_BASE=<your_generated_secret>
```

Push the repository to Heroku.

When deploying for the first time, Heroku will automatically add a Database
plugin to your instance and links it to the application. After the first
deployment, don't forget to run the database migration and seed.

```bash
heroku run rake db:migrate db:seed
```

If application error has occurred after migration, you need to restart Heroku server.

```bash
heroku restart
```

## Resources

- [Sidebar Plugins](https://github.com/publify/publify/wiki/Sidebar-plugins)
- [In page Plugins](https://github.com/publify/publify/wiki/In-Page-Plugins)
- [**Report a bug**](https://github.com/publify/publify/issues)
- [**Frequently Asked Questions**](https://github.com/publify/publify/wiki/frequently-asked-questions)
- [Publify on Twitter](https://twitter.com/getpublify)
- IRC: \#publify on irc.freenode.net

## Maintainers

### Current Maintainers

**Frédéric de Villamil**
blog: http://t37.net

**Matijs van Zuijlen**
blog: http://www.matijs.net/blog/

**Thomas Lecavelier**
blog: http://blog.ookook.fr/

**Yannick François**
blog: http://elsif.fr

### Previous Maintainers & Notable Contributors

**Cyril Mougel**
blog: http://blog.shingara.fr

**Davide D'Agostino**
blog: http://www.lipsiasoft.com

**Piers Cawley**
blog: http://www.bofh.org.uk/

**Scott Laird**

**Kevin Ballard**
blog: kevin.sb.org

**Patrick Lenz**

**Seth Hall**

And [many more cool people who’ve one way or another contributed to
Publify](https://github.com/publify/publify/graphs/contributors).

**Original Author: Tobias Luetke**
blog: http://blog.leetsoft.com/

Enjoy,
The Publify team
