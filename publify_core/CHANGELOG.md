# Changelog

## 9.2.10 / 2023-01-08

* Bump Rails version to 5.2.8.1 [#1070](https://github.com/publify/publify/pull/1070)
* Limit length of settings values [#1072](https://github.com/publify/publify/pull/1072)
* Require login to stay unique when updating a User [#1073](https://github.com/publify/publify/pull/1073)
* Validate lengths of string attributes [#1077](https://github.com/publify/publify/pull/1077)
* Strip EXIF data from resource uploads [#1078](https://github.com/publify/publify/pull/1078)
* Require user passwords to be strong [#1086](https://github.com/publify/publify/pull/1086)

## 9.2.9 / 2022-05-22

* Fix admin article access control [#1065](https://github.com/publify/publify/pull/1065)
* Refuse html files as resources even if declared to be plain text [#1066](https://github.com/publify/publify/pull/1066)

## 9.2.8 / 2022-05-14

* Fix password protected article reveal [#1049](https://github.com/publify/publify/pull/1049)
* Disallow comments on draft articles [#1048](https://github.com/publify/publify/pull/1048)
* Clean up Feedback validation [#1051](https://github.com/publify/publify/pull/1051)
* Disallow images in comments [#1054](https://github.com/publify/publify/pull/1054)
* Fix password reset process [#1055](https://github.com/publify/publify/pull/1055)
* Hide bodies of password-protected articles in search results [#1057](https://github.com/publify/publify/pull/1057)
* Provide correct `article_id` input in bulkops form [#1058](https://github.com/publify/publify/pull/1058)
* Do not create article meta description for password-protected articles [#1061](https://github.com/publify/publify/pull/1061)

## 9.2.7 / 2022-02-07

* Fix setting the article password from the Admin [#1044](https://github.com/publify/publify/pull/1044)

## 9.2.6 / 2022-01-07

* Add documentation about use of the media library

## 9.2.5 / 2021-10-11

This release fixes several security issues:

* Block ability to switch themes using a GET request; use a POST instead
* Disallow user self-registration rather than hiding it
* Let the browser not cache admin pages
* Limit the set of allowed mime types for uploaded media
* Limit allowed HTML in articles, pages and notes

Additionally, it includes the following changes:

* Fix resource size display in admin resource list
* Trigger download of media in the Media Library in admin instead of displaying
  them directly

## 9.2.4 / 2021-10-02

* Explicitly require at least version 1.12.5 of nokogiri to avoid a security issue
* Drop support for Ruby 2.4 since it is incompatible with nokogiri 1.12.5

## 9.2.3 / 2021-05-22

* Bump Rails dependency to 5.2.6
* Replace mimemagic with marcel

## 9.2.2 / 2021-03-21

* No changes

## 9.2.1 / 2021-03-20

* No changes

## 9.2.0 / 2021-01-17

* Upgrade to Rails 5.2 (mvz)
* Fix logic for rendering excerpts or whole posts (mvz)
* Drop support for Ruby 2.2 and 2.3 (mvz)
* Provide FactoryBot factories for general use (mvz)
* Fix comment preview (mvz)
* Drop support for humans.txt (mvz)
* Remove unused ability to view macro help text (mvz)
* Simplify the article editor: remove widearea and button fade-out (mvz)
* Remove unused `title_prefix` setting (mvz)
* Remove text filter definitions from the database. Text filters are now
  specified in code only (mvz)
* Remove broken inbound links feature from Admin dashboard (mvz)
* Always include a canonical URL in the header and remove `use_canonical_url`
  option (mvz)
* Update various dependencies (mvz)
* Use new way to render Devise error messages in view override (mvz)
* Fix broken page creation (cfis)
* Improve calculation of canonical URL (mvz)
* Replace use of deprecated URI.escape and URI.encode (mvz)
* Add support for Ruby 2.7 (mvz)
* Deprecate Textile text filter (mvz)
* Remove icons from Admin and replace them with text (mvz)
* Show text filter in content lists in Admin, plus various other Admin
  improvements (mvz)
* Warn about need to run task to convert textile to markdown (mvz)
* Update mimimum dependencies of Rails and Puma to avoid security issues (mvz)

## 9.1.0 / 2018-04-19

* Upgrade to Rails 5.1 (mvz)
* Update Danish translations (xy2z)
* Extend Polish translations (gergu)
* Remove outdated import tools (mvz)
* Fix a bunch of issues (e-tobi)
* Fix google analytics tag rendering (mvz)

## 9.0.1

* Remove `link_to_author` setting: author email is no longer shown. Whoever
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
