# Changelog

## Unreleased

* Introduce fragment caching
* Cache atom and rss feeds
* Remove support for feedburner
* Fix URL for resources in Atom/RSS feeds
* Drop old redirects
* Fix forgery protection errors for trackback creation
* Remove RSD end point
* Fix atom entry publication date
* Fix user resource image display when using Fog
* Handle setting published_at to blank
* Handle preview of articles without publication date
* Stop sending trackbacks and pingbacks
* Update dependencies
* Drop support for Ruby 2.1
* Include CSRF meta tag so remote forms work
* Performance improvements
* Improve tags controller
* Unify content models more to improve performance when mixing models
* Replace home-grown state machine with aasm
* Remove automigration. Users should run db:migrate themselves
* Let first-run users pick their own password and fix sending of welcome email
* Fix URL/alternate links in RSS and Atom feeds
* Fix Tag page description
* Clean up archives and authors page code and cache those pages

## 9.0.0.pre6 / 2016-12-23

* Remove now-broken caching of theme assets
* Remove cache invalidation support code from content

## 9.0.0.pre5 / 2016-12-17

* Update dependencies
* Remove activerecord-session_store. The main application should decide on the
  store to use.
* Remove unused translations

## 9.0.0.pre4

* Ensure theme files are part of the gem.

## 9.0.0.pre3

* Update to Rails 5.0
* Remove page caching since the released version of actionpack-page_caching is
  incompatible with Rails 5.

## 9.0.0.pre2

* Ensure PublifyCore::VERSION is available (mvz)

## 9.0.0.pre1

* Initial pre-release of Publify Core as a separate gem.
