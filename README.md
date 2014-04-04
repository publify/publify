Publify
====

**The Rails blogging engine formerly known as Typo**

[![Build Status](https://travis-ci.org/publify/publify.png)](https://travis-ci.org/publify/publify)
[![Code Climate](https://codeclimate.com/github/publify/publify.png)](https://codeclimate.com/github/publify/publify)
[![Dependency Status](https://gemnasium.com/publify/publify.png)](https://gemnasium.com/publify/publify)

### Table of contents

-   [The missing publishing platforn](#themissingweblogengine)
-   [Publify demo](#publifydemo)
-   [Download Publify](#downloadpublify)
-   [Install Publify locally](#installpublifylocally)
    -   [Prerequisites](#prerequisites)
    -   [Install Publify](#installpublify)

-   [Install Publify on Heroku](#installpublifyonheroku)
    -   [Storage](#storage)
    -   [Gemfile](#gemfile)

-   [Useful links](#usefullinks)
    -   [Enhance your blog](#enhanceyourblog)
    -   [More resources](#moreresources)
    -   [Support](#support)

-   [Maintainers](#maintainers)

<a name="themissingweblogengine"></a>

The missing publishing platform
-------------------------------

Publify is a modern, comprehensive, extensible, full featured publishing platform composed of a blogging engine and a mini message system connected to Twitter. Publify has been around since 2004 ans is the oldest Ruby on Rails open source project alive.

Publify provides you with everything you need to easily publish content on
the Web.

**A nice, user friendly blogging platform providing an incredible writing experience**

**Multi user:** role based management for multiple author websites.

**Powerful plugin engine:** available both in page, as text filters and
as widgets.

**Comprehensive theme support:** every aspect of the blog can be
redesigned according to your needs without changing a single line of the
core engine.

**Cool API:** Publify supports various blogging engine APIs so you can
publish from desktop clients.

**On demand syntax:** Publify supports various syntax (plain HTML,
Markdown, Textile)

**Multilingual**: Publify is (more or less) translated in English, French,
German, Danish, Norvegian, Japanese, Hebrew, Simplified Chinese, Mexicain
Spanish, Italian, Lituanese, Dutch, Polish, Romanian…

<a name="publifydemo"></a>

Publify demo
------------

If you want to give Publify a try, check out [our full featured
demo](http://demo.publify.co)

The login / password [to the admin](http://demo.publify.co/admin)
are:

- Administrator: admin / admin
- Publisher: publish / publish

The demo is reset every 2 hours.

<a name="downloadpublify"></a>

Download Publify
-------------

If you want to play it safe, you can download the latest [stable release](http://publify.co/stable.tgz).

If you feel adventurous or want to hack on Publify, [clone Publify
repository](https://github.com/publify/publify.git).

<a name="installpublifylocally"></a>

Install Publify locally
--------------------

<a name="prerequisites"></a>

### Prerequisites

To install Publify you need the following:

-   Ruby 1.9.3 or 2.0
-   Ruby On Rails 3.2.16
-   A database engine, MySQL, PgSQL or SQLite3

<a href="installpublify"></a>

### Install Publify

1.  Unzip Publify archive
2.  Rename database.yml.yourEngine as database.yml
3.  Edit database.yml to add your database name, login and password.

<!-- -->

    $ bundle install
    $ rake db:create
    $ rake db:migrate
    $ rake db:seed
    $ ./script/rails server

You can now launch you browser and access to 127.0.0.1:3000.

<a name="installpublifyonheroku"></a>

Install Publify on Heroku
----------------------

In order to install Publify on Heroku, you’ll need to do some minor tweaks.

<a name="storage"></a>

### Storage

You need to setup Amazon s3 storage to be able to upload files on your
blog. Set heroku config vars.

    $ heroku config:set provider=AWS \
      aws_access_key_id=YOUR_AWS_ACCESS_KEY_ID \
      aws_secret_access_key=YOUR_AWS_SECRET_ACCESS_KEY \
      aws_bucket=YOUR_AWS_BUCKET_NAME

<a name="gemfile"></a>

### Gemfile and database

To generate the Gemfile.lock, run:
    HEROKU=true bundle install

Remove Gemfile.lock from .gitignore and commit it.

Add the user env Heroku plugin:
    heroku labs:enable user-env-compile -a your_app_name

Add the HEROKU config variable to your Heroku instance:
    heroku set:config HEROKU=true

Push the repository to Heroku.

When deploying for the first time, Heroku will automaticaly add a Database plugin to your instance and links it to the application.
After the first deployment, don't forget to run the database migration and seed.

    heroku run rake db:migrate db:seed

<a name="usefullinks"></a>

Useful links
------------

<a name="enhanceyourblog"></a>

### Enhance your blog

-   [Sidebar Plugins](https://github.com/publify/publify/wiki/Sidebar-plugins)
-   [In page Plugins](https://github.com/publify/publify/wiki/In-Page-Plugins)

<a name="moreresources"></a>

### More resources:

-   [Download Publify source code](http://publify.co/stable.tgz)
-   [**Report a bug**](https://github.com/publify/publify/issues)
-   [**Frequently Asked
    Questions**](https://github.com/publify/publify/wiki/frequently-asked-questions)
-   [Official Publify blog](http://blog.publify.co)
-   [Follow us on Twitter](https://twitter.com/getpublify)

<a name="support"></a>

### Support

If you need help or want to contribute to Publify, you should start with
the following:

-   IRC: \#publify on irc.freenode.net

<a name="maintainers"></a>

Maintainers
-----------

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
