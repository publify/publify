# Changelog

## Unreleased

* Replace page caching with fragment caching
* Replace home-grown state machine with aasm
* Remove automigration. Users should run db:migrate themselves
* Let first-run users pick their own password instead of generating one

* Dependencies
  - Update dependencies
  - Drop support for Ruby 2.1

* Removing of old/outdated functionality
  - Remove support for feedburner
  - Drop old redirects
  - Remove RSD end point

* Feedback
  - Stop sending trackbacks and pingbacks
  - Fix forgery protection errors for trackback creation
  - Order feedback feed by created_at
  - Only display trackback URL when feedback is allowed, and never display it as a link

* Improve Atom/RSS feeds
  - Fix URLs used for resources
  - Fix URL/alternate links to not just point to the site root
  - Unify comment and trackback feeds into feedback feeds
  - Add caching for feeds
  - Fix atom entry publication date

* Bug fixes
  - Fix user resource image display when using Fog
  - Fix sending of welcome email
  - Fix Tag page description
  - Handle setting published_at to blank
  - Handle preview of articles without publication date
  - Include CSRF meta tag so remote forms work

* Code improvements
  - Performance improvements
  - Improve tags controller
  - Clean up archives and authors page code
  - Unify content models more to improve performance when mixing models

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
