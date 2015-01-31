# Publify

**The Ruby on Rails publishing software formerly known as Typo**

### Download

You can download Publify [stable release](http://publify.co/stable.tgz) or [clone Publify
repository](https://github.com/publify/publify.git).

[![Build Status](https://travis-ci.org/publify/publify.png)](https://travis-ci.org/publify/publify)
[![Code Climate](https://codeclimate.com/github/publify/publify.png)](https://codeclimate.com/github/publify/publify)
[![Dependency Status](https://gemnasium.com/publify/publify.png)](https://gemnasium.com/publify/publify)

## What's Publify?

Publify is a simple but full featured web publishing software. It's built around a blogging engine and a small message system connected to Twitter.

Publify follows the principles of the IndieWeb, which are self hosting your Web site, and Publish On your Own Site, Syndicate Everywhere.

Publify has been around since 2004 and is the oldest Ruby on Rails open source project alive.

## Features

- A classic multi user blogging engine
- Short messages with a Twitter connection
- Text filters (Markdown, Textile, SmartyPants, @mention to link, #hashtag to link)
- A widgets system and a plugin API
- Custom themes
- Advanced SEO capabilities
- Multilingual : Publify is (more or less) translated in English, French, German, Danish, Norwegian, Japanese, Hebrew, Simplified Chinese, Mexican Spanish, Italian, Lithuanian, Dutch, Polish, Romanian…

## Demo site

You can [give Publify a try](http://demo.publify.co)

The login / password [to the admin](http://demo.publify.co/admin)
are:

- Administrator: admin / admin
- Publisher: publish / publish

The demo is reset every 2 hours.

## Install Publify  locally

To install Publify you need the following:

-   Ruby 2.0, 2.1 or 2.2
-   Ruby On Rails 4.2.0
-   A database engine, MySQL, PgSQL or SQLite3

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

You can now launch you browser and access to 127.0.0.1:3000.



## Install Publify on Heroku

In order to install Publify on Heroku, you’ll need to do some minor tweaks.

### Storage

You need to setup Amazon S3 storage to be able to upload files on your
blog. Set Heroku config vars.

```yaml
heroku config:set provider=AWS
aws_access_key_id=YOUR_AWS_ACCESS_KEY_ID
aws_secret_access_key=YOUR_AWS_SECRET_ACCESS_KEY
aws_bucket=YOUR_AWS_BUCKET_NAME
```

To generate the Gemfile.lock, run:
```bash
HEROKU=true bundle install
```

Remove Gemfile.lock from .gitignore and commit it.

Add the HEROKU config variable to your Heroku instance:

```bash
heroku config:set HEROKU=true
```

Push the repository to Heroku.

When deploying for the first time, Heroku will automatically add a Database plugin to your instance and links it to the application.
After the first deployment, don't forget to run the database migration and seed.

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
- [Publify blog](http://blog.publify.co)
- [Publify on Twitter](https://twitter.com/getpublify)
- IRC: \#publify on irc.freenode.net

### Maintainers

This is a list of Publify maintainers. If you have committed, please add
your name and contact details to the list.

**Frédéric de Villamil** <frederic@publify.co>
blog: http://t37.net
irc: neuro`

**Matijs van Zuijlen**
blog: http://www.matijs.net/blog/
irc: matijs

**Thomas Lecavelier**
blog: http://blog.ookook.fr/
irc: ook

**Yannick François**
blog: http://elsif.fr
irc: yaf

And [many more cool people who’ve one day or another contributed to
Publify](https://github.com/publify/publify/graphs/contributors).

**Original Author: Tobias Luetke**
blog: http://blog.leetsoft.com/
irc: xal

Enjoy,
The Publify team
