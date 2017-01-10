# Changelog

## Unreleased

* Introduce fragment caching
* Cache atom and rss feeds
* Remove support for feedburner
* Fix URL for resources in Atom/RSS feeds
* Update to CarrierWave 1.0.0
* Move sending of pingbacks and trackbacks to ActiveJob
* Drop old redirects
* Fix forgery protection errors for trackback creation
* Remove RSD end point
* Fix atom entry publication date
* Fix user resource image display when using Fog

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
