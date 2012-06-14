h1. About Typo

Typo has been around since March of 2005 making it one of the oldest blogging platforms in Rails.

It provides every feature a modern blogging engine needs: powerful themes, extensions, smart users management, SEO capabilities and brings a great user experience for both site visitors and Web developpers. Typo is easy to install and even easier to use.

Typo is free software released under the MIT licence and maintained by a bunch of cool people on their spare time.

The current version is Typo 6.1.0 for Ruby on Rails 3.0.10.

!http://blog.typosphere.org/download-typo.png(Download Typo)!:http://typosphere.org/stable.tgz

h1. Useful links

h2. Enhance your Typo blog

* "Sidebar Plugins":https://github.com/fdv/typo/wiki/Sidebar-plugins
* "In page Plugins":https://github.com/fdv/typo/wiki/In-Page-Plugins

h2. More resources:

* "Download Typo source code:":http://typosphere.org/stable.tgz
* "*Report a bug*":https://github.com/fdv/typo/issues
* "*Frequently Asked Questions*":http://wiki.github.com/fdv/typo/frequently-asked-questions
* "Official Typo blog":http://blog.typosphere.org
* "Follow us on Twitter":http://twitter.com/typosphere

h2. Get in touch

If you need help or want to contribute to Typo, you should start with the following:

* IRC: #typo on irc.freenode.net
* "Mailing list":http://rubyforge.org/mailman/listinfo/typo-list

h1. Install Typo

Installing Typo is trivial, provided you follow the following steps.

h2. 1. Prerequisites

To install Typo you need the following:

* Ruby 1.9.2 or 1.9.3. Typo may work with Ruby 1.8.7 with some minor tweakings, but this version is not supported anymore.
* Ruby On Rails 3.0.10
* A database engine, MySQL, PgSQL or SQLite3
* A FTP client or even better SSH access to your hosting provider

h2. 2. Download Typo

Download Typo stable version at http://typosphere.org/stable.tar.gz or http://typosphere.org/stable.zip.

h2. 3. Install Typo

Unpack Typo archive into your Web hosting space. Rename database.yml.yourEngine to database.yml, edit the file and add your database name, login and password. If you have a doubt about this one, just ask your Web hosting provider.

Then run:

$ bundle install
$ ./script/rails server

You can now access Typo to http://yourdomain:3000

That's all!

h2. 4. Daily Typo use

We recommend using Passenger (mod_rails) or Thin / Unicorn with Apache or Nginx.

The admin interface for Typo allows you to post articles and change configuration settings. It can be found at http://yourdomain.com/admin. New content can be posted using the admin interface or a desktop blog editor such as MarsEdit or Ecto. For a list of working clients, please visit http://typosphere.org/wiki/DesktopClients.

h1. Maintainers

This is a list of Typo maintainers. If you have committed, please add your name and contact details to the list.

h2. The Cool Kids

*Frédéric de Villamil* <frederic@de-villamil.com>
blog: http://t37.net
irc: neuro`

*Matijs van Zuijlen*
blog: http://www.matijs.net/blog/
irc: matijs

*Thomas Lecavelier*
blog: http://blog.ookook.fr/
irc: ook

*Yannick François*
blog: http://elsif.fr
irc: yaf

And many more cool people who've one day or another contributed to Typo.

*Original Author: Tobias Luetke*
blog: http://blog.leetsoft.com/
irc: xal

Enjoy,
The Typo team
