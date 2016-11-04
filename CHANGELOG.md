# Changelog

## 8.3.3

* Fix Devise error during sign-in (mvz)
* Protect from forgery on all actions (mvz)
* Have Devise be paranoid by default (mvz)
* Fix resource upload and properly check mime types (mvz)
* Store session in the database to prevent session hijacking (mvz)
* Correctly escape blog name in devise view (mvz)

## 8.3.2

* Replace deprecated count-with-conditions (mvz)
* Loosen/update dependencies (mvz)
* Fix google sitemap (mvz)
* Restore theme helper loading (mvz)
* Fix password edit form (jetware)

## 8.3.1

* Fix live search (mvz)
* Introduce SidebarRegistry to avoid need to preload all sidebars (mvz)
* Avoid use of String#html_safe (mvz)
* Fix several cases of double-escaped HTML (mvz)
* Avoid ambiguous field reference in feedback scopes (apsheronets)
* Remove spurious error message when starting a new article (mvz)
* Replace bundled bootstrap with bootstrap-sass gem (mvz)
* Link Resource directly to Blog in order to make upload of images to media
  library work again (mvz)
* Fix comment order and other feedback scopes (mvz)
* Fix autosave (mvz)
* Improve russian translation (apsheronets)
* Fix note publication date entry (mvz)
* Ensure settings update flash has the correct language (mvz)

## 8.3.0

### Breaking/large changes

* Make Publify multiblog-ready (mvz)
* Replace custom Publify authentication system with Devise (mvz)
* Replace custom Publify authorization system with CanCanCan (mvz)
* Remove Profile model (mvz)
* Remove long-deprecated view_root method for sidebars (mvz)
* Provide registration mechanism for themes, allowing them to be stored
  anywhere (mvz)

### Other changes

* Update Akismet API calls (drakontia)
* Remove old Rails patches (mvz)
* Update dependency on Rails to 4.2.5 (mvz)
* Fix issues with missing translations and HTML escaping errors
* Clean up helpers and partials (mvz)
* Add specs to check for double HTML escaping and fix errors (mvz)
* Load JavaScript asynchronously (mvz)
* Remove own copies of jQuery files (mvz)
* Fixed rake db:seed error (sachiotomita)
* Add check for translation keys and fix errors (mvz)
* Introduce RuboCop to automatically check style errors (mvz)
* Fix many RuboCop offenses (mvz)
* Update Travis config to stop testing on MRI 2.0.0, start testing on 2.3 (mvz)
* Remove unused #reset_local_cache method (mvz)
* Load JavaScript asynchronously in supporting layouts (mvz)
* Fix translations for labels in Devise views (mvz)
* Update dependencies (mvz)
* Clean up textfilter code (mvz)
* Test and improve setup process (mvz)
* Update translations for Dutch (mvz)
* Fix syntax error in mailer template (ttibau)
* Ensure development dependencies don't break the build (mvz)
* Fix spelling (mvz)
* Use only the parts from fog needed by Publify (mvz)
* Upgrade to mysql2 0.4.x (ttibau)
* Remove unused code (mvz)
* Load JavaScript asynchronously only in production (priit)
* Run tests as a sub-URL installation by default (mvz)
* Ensure new sidebars have blog_id set (mvz)
* Fix bug in article attachment saving (mvz)
* Fix broken authors sidebar (mvz)

## 8.2.0

### Breaking/large changes
* Update rails, jquery-rails and web-console to avoid security vulnerabilities (mvz)
* Update dependencies (mvz, fdv)
* Update to Rails 4.2 (mvz)
* Roll up migrations up to 113 according to our
  [upgrade policy](https://github.com/publify/publify/wiki/Upgrading).
  You must now first upgrade to at least version 7 before upgrading to the
  latest version. (mvz)
* Replace default theme bootstrap with bootstrap-2 (fdv)
* Add a Plain theme demonstrating the use of Publify's default templates (mvz)
* Use HTML instead of XHTML in views (fdv)

### Other changes
* Restore hiding of automatic redirects from admin interface (mvz)
* Fix broken stylesheet link in bootstrap2 theme (hmallett)
* Create a fonts folder for themes, to replicate the Rails default (hmallet)
* Update rubocop todo and use rubocop in travis (whithajess)
* Autocorrect rubocop offenses (mvz)
* Support Ruby 2.2 (mvz)
* Indicate dependency on external JS runtime (mvz)
* Several improvements to the Admin UI
* Update pt-BR translations (ramirovjr)
* Update nl translations (mvz)
* Update fr translations (Stephanyan, giniouxe)
* Update en translations (hmallett, stevenwilkin)
* Update es-MX translations (hernamvel)
* Changed navbar to dropdown onhover (jacemonje)
* Improve Publify's default templates
* Fix sidebar administration (mvz)
* Various cleanups and improvements of code and specs
* Fix several vulnerabilities reported by brakeman (mvz)
* Use more resourceful routes (hmallett)
* Fix editing users in Admin (pacergh)
* Add foreign keys and indexes to the schema (hmallett)
* Add a CONTRIBUTING.md file to help contributors (randomecho)
* Remove test dependency on feedvalidator (mvz)
* Remove old API links from RSD view (mvz)
* Remove outdated schemas rake task (stevenwilkin)
* Improve installation instructions (giniouxe)
* Paginate article archives pages (giniouxe)
* Handle tags that contain colons (ook)
* Ensure cache path exists (pvcarrera)
* Use protocol-relative URIs for Flickr images (flameeyes)
* Update text filter help texts to use 'publify' (mvz)
* Restore hiding/showing of optional comment fields (mvz)
* Use rails-timeago to provide time ago display (mvz)
* Adding new Publify favicon (fdv)
* Fix typo (garethrees)
* Various small bug fixes
* Several theme fixes

## 8.1.1

Frédéric de Villamil (4):
* Fixes broken autosave.
* Fixes editor size for pages and articles.
* Fixes publishing. Need to investigate why the specs did not break on that one.
* Updating Publify version for 8.1.1

## 8.1.0

Frédéric de Villamil (2):
* Adds missing users-style.css in assets precompile.
* Updates Rails version

Matijs van Zuijlen (47):
* Fix spec for sending pings on Article save
* Enforce correct join table name
* Fix finders
* Fix Feedback scopes
* Remove invalid attribute in Trackback spec setup
* Fix finder in spec
* Fix Migrator to match changed ActiveRecord::Migrator
* Declare params used for assignment permitted in admin
* Fix use of finders in admin and its specs
* Move #text_filter= override to where it will be picked up
* Fix implementation of assert_xml
* Avoid exception when avatar plugin is undefined
* Rewrite use of removed assertions
* Fix tests for layoutless rendering
* Fix rendered template spec
* Avoid attempting to create articles with the same id in spec setup
* Avoid attempting to update articles with the wrong id
* Fix use of finders outside admin
* Make Rails ignore the accept header again
* Declare params permitted
* Fix finders in migrations
* Match files as generated by Rails 4.1
* Remove unused Sidebar methods
* Introduce `valid` scope to find Sidebars safely
* Remove unused methods
* Wrap long comment
* Add a TODO
* Wrap long lines
* Avoid time zone shift
* Add a FIXME
* Use current time zone for Tweets
* Fix check for SQLite connection
* Replace webrat with capybara
* Replace should contain with should match
* Fix usage of have_selector matcher
* Make sidebar generator Rails 3 compliant.
* Declare assets for precompilation
* Allow GET to /setup
* Include admin assets in precompile list
* Fix creation of first article in SetupController
* Fix hash rockets and white space in SetupController and its specs
* Include admin css in precompile list
* Move fonts to their normal position
* Precompile font assets without cache buster
* Make user NonStupidDigestAssets is always defined
* Fix spec setup
* Make rendering notes in article list work

Thomas Lecavelier (16):
* Upgrade rails stack to 4.1.1
* eader_loading mandatory in conf
* Page caching removed from Rails4.0, return it as a Gem
* Observers removed from Rails4.0, return it as a Gem
* WIP deprecated stuff conversion
* Can't merge proc, you know…
* default_scope explicitly require a block, now
* attr_accessible no longer exist. User params.require/permits in controller instead.
* default_scope for Note
* I hate you all… T_T match must specify HTTP method(s)
* Can't use same alias for 2 differents routes…
* Misuse of named route + match / via
* Replace every #match by its HTTP verb or define their opened verbs with :via key
* Must check searches
* Fix deprecation warning for Travis
* Fix Blog.default

regonn (3):
* fix heroku config:set
* delete unnecessary command
* add heroku server restart command

## 8.0.2

Alexander Markov (1):
* .published_on changed; see below

Benoit C. Sirois (2):
* Added some translations
* Fixes link caching issue (All cached links are the same basically)

Frédéric de Villamil (21):
* Replaces the old Prototype based Lightbox with a more modern based on Bootstrap and Jquery.
* Fixes bootstrap use in the image gallery.
* Porting the lightbox plugin to the new version.
* Removing useless Javascript.
* Fixes the specs
* Fixes that very annoying bug in the editor save bar.
* Fixing a bug where the article content is displayed twice when using the more tag.
* Encloses the sidebar admin help text in a blue block (like every help text). Also fixes the style on the per widget submit button + removes button class on the cancel link (this should be the default)
* Removes the btn class on cancel
* Enables the close icon on the help messages
* Fixes layout differences betwen the page form and the post form
* Fixes the last comments dashboard avatar alignment
* Fixes articles search.
* Fixes an encoding issue in the inbound link plugin.
* Fixes the tag manager display issue.
* Apparently, rendering an empty js.erb file on destroy makes the effective destroy work. Not sure why.
* Fixes file upload.
* Fixes dynamic comment state change.
* Removes forgoten debug trace
* Replaces the date picker with datetime picker.
* Updating README and Publify version for 8.0.2 release

Hans de Graaff (1):
* Use a relative image path

Matijs van Zuijlen (13):
* Limit set of allowed comment parameters
* Run db setup inside bundle on Travis CI
* Upgrade to Rails 3.2.18
* Remove useless gems
* Fix indenting
* Remove useless #map
* Make Travis CI validate the rendered feeds
* Avoid symbolizing by stringifying instead
* Ensure RSpec 2.99 gets installed
* Avoid clearing cache that may not be there in test
* Balance tags of Bootstrap theme layout
* CarrierWave automatically sets the mime type now
* Fix Twitter gem deprecations

Soon Van (1):
* Typos and capitals in README [ci skip]

Thomas Lecavelier (2):
* Fix #423: stutter article content
* Excerpt is not editable anymore. Drop it even for full_article_content partial. Close #423
* Upgrade to Rails 3.2.17

Tor Helland (2):
* Synchronised Norwegian translation with the English en.yml.
* Revised all of Norwegian translation.

Yannick Francois (11):
* Just a little cleanup of a spec
* Add humans txt settingso
* Really write to humans txt file
* Add a text controller to manage humans.txt (and other later)
* Robots.txt generated by a controller.
* Refactor duplication in notes controller
* Just clean syntax on specs
* Prepare rspec 3 by removing deprecations
* Put back condition on cache for archives page
* Clean code around notes show and url helper
* Fix note helper. Back in application helper.

slainer68 (1):
* Travis build on 2.0 and 2.1

## 8.0.1

* #398: the user-style.css stylesheet is not loaded in the Bootstrap theme
* #399: the note style is not applied.
* #402, #410, #411: deployment crashes on Heroku (thank you @slainer68 for
  fixing that).
* #412: the editor locally saves the content of the edited note, which means it
  reloads it when you edit another note, overwriting the legit content.

## Publify 8.0

It's been 5 months since Publify 7.1, and considering the figures, Publify 8.0
is the biggest release we ever pushed in 9 years: 474 commits, 71 issues
closed, 8 contributors, 567 files changed, 60,767 additions and 45,166
deletions.

But you probably don't care about numbers that much, except if you're wondering
whether or not the project is till alive. TL; DR: it is.

The project itself has known one big change, [moving from Fred's personal
Github account to a dedicated organization][1]. We have been thinking about it
for a while, and we believe it's the best we could do for Publify.

### Simpler, better, faster

Last summer, [we started to rethink what we wanted Publify to be][2]. At a time
where online publishing is more or less split between Wordpress, hosted
platforms and static engines, being "only" a blogging platform had no meaning
anymore. We started to extend publishing capabilities, choosing Twitter pushed
short notes as a first step before we add more content type. This led to
Publify 7.0, and once again we knew it was the way to go.

Before adding these feature, we wanted Publify 8.0 to rebuild the whole user
experience. It had to be simpler, clearer and better, far from the MS Word 97
style that prevails in Web publishing since more than 10 years.

This meant a simpler interface with a single, smaller menu, getting out of the
old create / read / update / delete scheme when possible, merging some sections
and finally removing lots of things. This also means using the most of large
screens capabilities, using _responsive_ layouts as much as we could, even
though it made the job more difficult at some point.

The editor, it has been completely revamped, following the way opened by both
Medium and Ghost. We've pushed aside everything that may distract you from
writing. The post settings are 1 click away from the editor so you won't feel
lost anyway. We know how much work is left to get a really classy tool, but
we're working on it.

The notes have got improvement. When replying to a tweet, Publify now displays
the original tweet so readers can keep the context this was done.

Users profiles have been improved to. Each user now has its own detailed page
with avatar, contact links, short bio and indeed the published content.

### Missing in action

The old categories VS tags separation is no more. We merged the first into the
seconds as a strict categorization has no real meaning on most blogs. Don't
worry about your URLs, we took care of everything, eventually creating the
redirects you needed.

The _excerpt_ has been removed. Excerpt was meant to display a different
content on the listing page and on the post itself. It was an interesting
feature, but only a handful of people, if none was using it, and it made the
editor more complicated than necessary.

The old [Typographic theme][3] is not part of the core anymore. It has moved to
its own project and will still be maintained.

The old XMLRPC backend has been discontinued. This means Publify does not
support desktop clients anymore. This choice has been motivated by the fact
that the APIs it was relying had not been updated for 10 years, and that most
desktop editors are not maintained anymore either. Web browsers capabilities
have evolved, and you can now have a fairly decent editor with local saving
without the need of a desktop application.

### Under the hood

Publify has been around for 9 years now. Rails was not 1.0 yet, and some of our
code was older than you can ever imagine.

Publify 8.0 got rid of most of that legacy code. The old Prototype based
helpers that made Rails famous back then left the building. Prototype itself
has finally been replaced by Jquery, and Rails i18n allowed the _Globalize_
based translation system to enjoy a deserved retirement. Most helpers have been
removed too, as most of them were only used in one place.

This should not affect you unless you're running custom themes and plugins. If
so, have a look at the Bootstrap theme to see how we're now working.

That's all folks, you can now download Publify, or give it a try on [our demo
platform][4].

[1]: http://t37.net/here-comes-the-time-to-hand-over-your-open-source-project.html
[2]: http://t37.net/is-coding-a-blogging-engine-still-worth-the-effort-in-2013-and-other-thoughts-about-content-publishing-tools.html
[3]: https://github.com/publify/typographic
[4]: http://demo.publify.co/

