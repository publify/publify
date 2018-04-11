# Changelog

## 9.1.0 / Unreleased

* Update to Rails 5.1

## 9.0.1

* Remove link_to_author setting: author email is no longer shown. Whoever
  really wants to have it shown should create a new theme (mvz)
* Update dependencies (mvz)
* Make Devise use the correct layout (mvz)
* Ensure email parameter is processed correctly on sign up (mvz)
* Correctly serve js files from themes (cantin)

## 9.0.0

* Replace page caching with fragment caching (mvz)
* Replace home-grown state machine with aasm (mvz)
* Remove automigration. Users should run db:migrate themselves (mvz)
* Let first-run users pick their own password instead of generating one (mvz)

* Dependencies
  - Update dependencies (mvz)
  - Drop support for Ruby 2.1 (mvz)

* Removing of old/outdated functionality
  - Remove support for feedburner (mvz)
  - Drop old redirects (mvz)
  - Remove RSD end point (mvz)

* Feedback
  - Stop sending trackbacks and pingbacks (mvz)
  - Stop accepting trackbacks (mvz)

* Improve Atom/RSS feeds
  - Fix URLs used for resources (mvz)
  - Fix URL/alternate links to not just point to the site root (mvz)
  - Unify comment and trackback feeds into feedback feed (mvz)
  - Add caching for feeds (mvz)
  - Fix atom entry publication date (mvz)
  - Fix ordering of feedback feed by using created_at (mvz)

* Bug fixes
  - Fix user resource image display when using Fog (mvz)
  - Fix sending of welcome email (mvz)
  - Fix Tag page description (mvz)
  - Handle setting published_at to blank (mvz)
  - Handle preview of articles without publication date (mvz)
  - Include CSRF meta tag so remote forms work (mvz)
  - Fix sidebar field rendering in admin (mvz)
  - Fix formatting of settings forms in admin (mvz)

* Code improvements
  - Performance improvements (mvz)
  - Improve tags controller (mvz)
  - Clean up archives and authors page code (mvz)
  - Unify content models more to improve performance when mixing models (mvz)

## 9.0.0.pre6 / 2016-12-23

* Remove now-broken caching of theme assets (mvz)
* Remove cache invalidation support code from content (mvz)

## 9.0.0.pre5 / 2016-12-17

* Update dependencies (mvz)
* Remove activerecord-session_store. The main application should decide on the
  store to use (mvz)
* Remove unused translations (mvz)

## 9.0.0.pre4

* Ensure theme files are part of the gem (mvz)

## 9.0.0.pre3

* Update to Rails 5.0 (mvz)
* Remove page caching since the released version of actionpack-page_caching is
  incompatible with Rails 5 (mvz)

## 9.0.0.pre2

* Ensure PublifyCore::VERSION is available (mvz)

## 9.0.0.pre1

* Initial pre-release of Publify Core as a separate gem.
