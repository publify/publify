Typo
====
[![Build Status](https://travis-ci.org/fdv/typo.png)](https://travis-ci.org/fdv/typo)
[![](https://codeclimate.com/badge.png)](https://codeclimate.com/github/fdv/typo)
[![Dependency Status](https://gemnasium.com/fdv/typo.png)](https://gemnasium.com/fdv/typo)

### Table of contents

-   [The missing weblog engine](#themissingweblogengine)
-   [Typo demo](#typodemo)
-   [Download Typo](#downloadtypo)
-   [Install Typo locally](#installtypolocally)
    -   [Prerequisites](#prerequisites)
    -   [Install Typo](#installtypo)

-   [Install Typo on Heroku](#installtypoonheroku)
    -   [Database](#database)
    -   [Storage](#storage)
    -   [Gemfile](#gemfile)
    -   [Gemfile.lock](#gemfilelock)

-   [Create a simple theme](#createasimpletheme)
    -   [Header](#createasimplethemeheader)
    -   [Body](#createasimplethemebody)

-   [Advanced theme creation](#advancedthemecreation)
    -   [Pave the path](#advancedthemecreationpavethepath)
    -   [Create the templates](#advancedthemecreationcreatetemplate)

-   [Advanced plugins](#advancedplugins)
    -   [Create the plugin](#advancedplugins-createtheplugin)
    -   [Make your code
        accessible](#advancedplugins-makeyourcodeaccessible)
    -   [The routing](#advancedplugins-therouting)
    -   [The models](#advancedplugins-themodels)
    -   [The front](#advancedplugins-thefront)
        -   [Controllers](#advancedplugins-thefront-controllers)
        -   [Views](#advancedplugins-thefront-views)

    -   [The admin](#advancedplugins-theadmin)
        -   [Add your module](#advancedplugins-theadmin-add-your-module)
        -   [Controllers](#advancedplugins-theadmin-controllers)
        -   [Views](#advancedplugins-theadmin-views)

-   [Useful links](#usefullinks)
    -   [Enhance your blog](#enhanceyourblog)
    -   [More resources](#moreresources)
    -   [Support](#support)

-   [Maintainers](#maintainers)

<a name="themissingweblogengine"></a>

The missing weblog engine
-------------------------

Typo is a modern, lightweight, comprehensive, full featured Weblog
engine using Ruby on Rails. It’s been around since 2004 and probably the
oldest open source project based on Ruby on Rails.

Typo provides you with everything you need to easily publish content on
the Web.

**Multi user:** role based management for multiple authors Web sites.

**Powerful plugin engine:** available both in page, as text filters and
as widgets.

**Comprehensive theme support:** every aspect of the blog can be
redesigned according to your needs without changing a single line of the
core engine.

**Cool API:** Typo supports the various blogging engine APIs so you can
publish from desktop clients.

**On demand editor:** Typo supports various editors (visual, plain HTML,
Markdown, Textile)

**Multilingual**: Typo is (more or less) translated in English, French,
German, Danish, Norvegian, Japanese, Hebrew, Simple Chinese, Mexicain
Spanish, Italian, Lituanese, Dutch, Polish, Romanian…

<a name="typodemo"></a>

Typo demo
---------

If you want to give Typo a try, check out [our full featured
demo](http://demo.typosphere.org)

The login / password [to the admin](http://demo.typosphere.org/admin)
are:

-   Administrator: admin / admin
-   Publisher: publish / publish

The demo is reset every hour.

<a name="downloadtypo"></a>

Download Typo
-------------

For a production blog, you should download [download Typo
6.1.4](http://typosphere.org/stable.tgz)

If you feel adventurous or want to hack on Typo, [clone Typo
repository](git://github.com/fdv/typo.git)

<a name="installtypolocally"></a>

Install Typo locally
--------------------

<a name="prerequisites"></a>

### Prerequisites

To install Typo you need the following:

-   Ruby 1.9.2 or 1.9.3.
-   Ruby On Rails 3.2.12
-   A database engine, MySQL, PgSQL or SQLite3

<a href="installtypo"></a>

### Install Typo

1.  Unzip Typo archive
2.  Rename database.yml.yourEngine as database.yml
3.  Edit database.yml to add your database name, login and password.

<!-- -->

    $ bundle install
    $ rake db:create
    $ ./script/rails server

You don’t need to run `rake db:migrate` and `rake db:seed` as Typo will
take care of everything the first time you access 127.0.0.1:3000.

<a name="installtypoonheroku"></a>

Install Typo on Heroku
----------------------

In order to install Typo on Heroku, you’ll need to do some minor tweaks…

<a name="database"></a>

### Database

Just add the Heroku Postgres plugin to your app. When deploying, Heroku
will write the database configuration so you don’t have to do anything.

<a name="storage"></a>

### Storage

You need to setup Amazon s3 storage to be able to upload files on your
blog. Edit `config/storage.yml`

    provider: AWS
    engine: AWS
    aws_access_key_id: YOUR_AWS_ACCESS_KEY_ID
    aws_secret_access_key: YOUR_AWS_SECRET_ACCESS_KEY
    aws_bucket: YOUR_AWS_BUCKET_NAME

<a name="gemfile"></a>

### Gemfile

Replace the default `Gemfile` by `Gemfile.heroku` :
`cp Gemfile Gemfile.heroku`.
Heroku may also need the Ruby version to be declared. You may add
`ruby "1.9.3"` after the source to use the latest Ruby version.

Heroku will also boot your app on Webrick, the default Ruby web server,
which is rather slow. Just add thin to get some free speed.

Now, run

    bundle install

<a name="gemfilelock"></a>

### Gemfile.lock

Heroku needs Gemfile.lock to be in the Git repository. Remove
Gemfile.lock from .gitignore and add it `git add .gitignore
Gemfile.lock`

<a name="createasimpletheme"></a>

Create a simple theme
---------------------

Typo offers a very slick and evolved theme engine. It allows theme
developers to override every view of the application, or just add their
own layout, stylesheet, and let Typo do the job.

A Typo template is made with a *minimum* of three main files:

-   The layout.
-   A CSS stylesheet.
-   An about file using Markdown.
-   You can eventually add a screenshot, and some fancy pictures in your
    theme, but they are not mandatory.

Browsing a default Typo theme looks like:

    themes
          \_ my theme
                     \_ about.markdown
                     \_ images
                     \_ layouts
                               \_ default.html.erb
                     \_ preview.png
                     \_ stylesheets
                                   \_ style.css

Your main file is in `layouts/default.html.erb`, which is your theme
main template. This is a simple RHTML file in which you’ll call Typo
main methods.

<a name="createasimplethemeheader"></a>

### Header

This is a standard HTML file header, along with some Ruby calls. Nothing
complicated at all here.

    <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
    <html xmlns="http://www.w3.org/1999/xhtml" lang="fr">
    <head profile="http://gmpg.org/xfn/11">
      <title><%= h(page_title) %></title>
      <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
      <meta http-equiv="Content-Language" content="fr" />

      <%= stylesheet_link_tag "/stylesheets/theme/style", :media => ‘all’ %>
      <%= page_header %>
    </head>

There are some things you must pay attention to:

-   `h(page_title)` is the title of the current document. This is
    generated by Typo, and translation in supported languages is done
    when available.
-   `stylesheet_link_tag` is where you call your CSS stylesheet. It will
    always be in `/stylesheets/theme/`. Some call it `style.css`, some
    `application.css`, but do whatever you want.
-   `page_header` with display a page header generated by Typo. It will
    provide:
    -   ICBM tag, for geo localization.
    -   Your meta description.
    -   Your meta keywords.
    -   Your RSD.
    -   URLs for both your RSS and Atom feeds, for automatic discovery.
    -   Stylesheets used by Typo embedded plugins, so that you don’t
        have to care.
    -   Google Analytics tags, if provided.

<a name="createasimplethemebody"></a>

### Body

Every `div` included here is not mandatory. You just need to care about
the Ruby calls.

    <body>
    <div id="header">
      <h1><a href="<%= this_blog.base_url %>"><%= this_blog.blog_name %></a></h1>
      <h2><%= this_blog.blog_subtitle %></h2>
    </div>

    <div id="page">
      <div id="content">
        <%= yield %>
      </div>

      <div id="sidebar">
        <%= render_sidebars %>
      </div>
    </div>
    </body>
    </html>

The important things are:

-   `this_blog.base_url` is your blog URL defined in your settings.
-   `this_blog.name` is your blog title, defined in your settings.
-   `this_blog.blog_subtitle` is your blog tagline, defined in your
    settings.
-   `yield` is the most important part of your layout. It renders the
    page main content according to what you’re browsing (articles, tags,
    categories…)
-   `render_sidebars` displays your sidebar made of Typo plugins.

Here you are. You can now build a standard Typo theme and profit from
the great things Typo can provide.

<a name="advancedthemecreation"></a>

Advanced theme creation
-----------------------

Typo offers custom post type. Let’s say you blog about tech and wine,
and want to display wine posts differently. You upload an attached
picture to every wine related post and want it to be displayed in every
article. You also have a custom CSS for wine blocks, and don’t want
people to comment on your wine reviews (this is to make the sample template
more readable). You also want to apply this to the category page.

<a name="advancedthemecreationpavethepath"></a>

### Pave the path

First, login to your blog admin and go to Article &#8594; Post Types.
Create a new post type called Wine.

Now, create a new category in Articles &#8594; Categories. We’ll call it
Wine too.

<a name="advancedthemecreationcreatetemplate"></a>

### Create the templates

Create two custom templates: one to display wine related articles, and one
to display the Wine category.

First, create a template called `wine.html.erb` in your
`theme/views/articles/` directory. If the `views/articles` directory
doesn’t exist, create it. The template will probably look like something
like this:

    <div class="wine" %>>
      <h2><%= link_to_permalink @article, @article.title %></h2>
      <p class="auth"><%= _("Posted by")%> <%= author_link(@article) %>
      <%= display_date_and_time @article.published_at %></p>
      <%= @article.html(:body) %>
      <!-- This display the attached images -->
      <% @article.resources.each do |upload| %>
        <img src='<%= "#{this_blog.base_url}/files/#{upload.filename}" %>' class="centered" />
      <% end %>
      <div class="extended">
        <%= @article.html(:extended) %>
      </div>

    </div>
    <p class="meta">
      <%= article_links @article %>
    </p>

Do the same with the wine category. In your theme `/views/categories`,
create a `wine.html.erb` template. This is adapted from the
`category/show.html.erb` of one of the stock themes.

    <h1><%= link_to "Wine", "#{this_blog.base_url}/category/#{params[:id]}" %></h1>

    <div class='category-excerpt <%= "border" if @article_counter >= 0 %>' id="article-<%= article.id %>">

    <% @articles.each do |article| %>
      <h2><%= link_to_permalink(article, article.title) %></h2>
      <p class="auth"><%= _("Posted by")%> <%= author_link(earticle) %>
      <%= display_date_and_time article.published_at %></p>
      <%= article.html(:body) %>
      <!-- This display the attached images -->
      <% article.resources.each do |upload| %>
        <img src='<%= "#{this_blog.base_url}/files/#{upload.filename}" %>' class="centered" />
      <% end %>
      <div class="extended">
        <%= article.html(:extended) %>
      </div>
    <% end %>
    </div>

    <div id='paginate'>
      <%= paginate @articles, { :previous_label => _('Previous'), :next_label => _('Next')  } %>
    </div>

Here you are, you can now write about wine. Just don’t forget to choose
the wine post type within the editor.

<a name="advancedplugins"></a>

Advanced plugins
----------------

<a name="advancedplugins-createtheplugin"></a>

### Create the plugin

As Typo plugins are just plain Rails plugins, creation is kind of trivial.

    ./script/rails generate plugin typo_sample_plugin

Create some folders to reflect a Rails application tree:

    cd vendor/plugins/typo_sample_plugin
    mkdir -p app/controllers/admin app/models app/helpers/admin config app/views/admin

<a name="advancedplugins-makeyourcodeaccessible"></a>

### Make your code accessible

Make Typo access your code. Edit your `init.rb` file and add the
following:

    PLUGIN_NAME = 'typo_sample_plugin'
    PLUGIN_PATH = "#{::Rails.root.to_s}/vendor/plugins/#{PLUGIN_NAME}"
    PLUGIN_CONTROLLER_PATH = "#{PLUGIN_PATH}/app/controllers"
    PLUGIN_VIEWS_PATH = "#{PLUGIN_PATH}/app/views"
    PLUGIN_HELPER_PATH = "#{PLUGIN_PATH}/app/helpers"
    PLUGIN_MODELS_PATH = "#{PLUGIN_PATH}/app/models"

    config.autoload_paths += %W(#{TypoSamplePlugin::PLUGIN_CONTROLLER_PATH}
                                #{TypoSamplePlugin::PLUGIN_HELPER_PATH}
                                #{TypoSamplePlugin::PLUGIN_VIEWS_PATH}
                                #{TypoSamplePlugin::PLUGIN_MODELS_PATH}

    ActionView::Base.send(:include, TypoSamplePlugin::Helper)

<a name="advancedplugins-therouting"></a>

### The routing

Unless Rails generators, your plugin won’t be allowed to change
routes.rb. We want our end users to remove them if they don’t want them
anymore. So we’re going to create our own `config/routes.rb`. It’s going
to look like this:

    ActionController::Routing::Routes.draw do |map|
      map.connect 'sample_plugin/:action', :controller => 'typo_sample', :action => 'index'

      %w{ sample_plugin }.each do |i|
        map.connect "/admin/#{i}", :controller => "admin/#{i}", :action => 'index'
        map.connect "/admin/#{i}/:action/:id", :controller => "admin/#{i}", :action => nil, :id => nil
      end
    end

I know, we’re still using Rails 2 routing DSL. It’s bad but Rails 3
can’t handle everything we do.

The first block is for your frontend controllers, the second one for the
admin. Easy as pie isn’t it?

<a name="advancedplugins-themodels"></a>

### The models

Add your models files in app/models exactly like on any Rails
application. You can use any Active Record relations you want and access
or extend existing Typo models.

To create your database schema, edit your `init.rb` file, and add the
following code:

    unless ::TypoSamplePlugin.table_exists?
      ActiveRecord::Schema.create_table(TypoSamplePlugin.table_name) do |t|
        t.column :name,  :string
        t.column :description,  :text
      end
    end

<a name="advancedplugins-thefront"></a>

### The front

<a name="advancedplugins-thefront-controllers"></a>

#### Controllers

To be able to display your content within your Typo blog layout, every
front end controller will need the following code:

    class TypoSamplePluginController < ActionController::Base
      unloadable
      layout :theme_layout
      before_filter :template_root

      def template_root
        self.class.view_paths = ::ActionController::Base.view_paths.dup.unshift(TypoSamplePlugin::PLUGIN_VIEWS_PATH)
      end

      def theme_layout
        File.join("#{::Rails.root.to_s}/themes/#{Blog.default.theme}/views", Blog.default.current_theme.layout(self.action_name))
      end

    end

There’s certainly a cleaner way to do it by not repeating the code, but
I’ll dig into it later.

<a name="advancedplugins-thefront-views"></a>

#### Views

Nothing special here. Really.

<a name="advancedplugins-theadmin"></a>

### The admin

OK, now you want to give your plugin a fancy back office? Let’s go.

<a name="advancedplugins-theadmin-add-your-module"></a>

#### Add your modules to the admin

Edit your `init.rb`. In your model creation block, add the following:

    admin = Profile.find_by_label('admin')
    admin.modules << :typosampleplugin
    admin.save

    publisher = Profile.find_by_label('publisher')
    publisher.modules << :typosampleplugin
    publisher.save

This will update both admin and publisher profiles giving them the
rights to access your plugin admin.

Add them to the access control list (and the menu as well). This is
still in init.rb

    AccessControl.map :require => [ :admin, :publisher, :contributor ]  do |map|
      map.project_module :typosampleplugin, nil do |project|
        project.menu    "My plugin meny",  { :controller => "admin/typo_sample_plugin" }
        project.submenu "My submenu", {:controller => "admin/typo_sample_plugin_other" }
      end
    end

Edit your lib/typo\_sample\_plugin.rb and add the following:

    module Helper
      def class_typosampleplugin
      return class_selected_tab if controller.controller_name  =~ /typo_sample_plugin/
      class_tab
      end
    end

This allows you to manage the tabs highlight in the admin.

<a name="advancedplugins-theadmin-controllers"></a>

#### Controllers

Your controllers will go to `app/controllers/admin` and will all look
like this, pretty like normal admin controllers:

    module Admin; end

    class Admin::TypoSamplePluginController < Admin::BaseController
      layout 'administration'
      unloadable

        ...
    end

<a name="advancedplugins-theadmin-views"></a>

#### Views

Typo plugins admin views look like normal admin views. Minimum code is:

    <% @page_heading = _('Sample plugin') %>
    <% subtabs_for(:typosampleplugin) %>

You can access any admin helper like save\_or\_cancel or link\_to\_new.

<a name="usefullinks"></a>

Useful links
------------

<a name="enhanceyourblog"></a>

### Enhance your blog

-   [Sidebar Plugins](https://github.com/fdv/typo/wiki/Sidebar-plugins)
-   [In page Plugins](https://github.com/fdv/typo/wiki/In-Page-Plugins)

<a name="moreresources"></a>

### More resources:

-   [Download Typo source code](http://typosphere.org/stable.tgz)
-   [**Report a bug**](https://github.com/fdv/typo/issues)
-   [**Frequently Asked
    Questions**](http://wiki.github.com/fdv/typo/frequently-asked-questions)
-   [Official Typo blog](http://blog.typosphere.org)
-   [Follow us on Twitter](https://twitter.com/gettypo)

<a name="support"></a>

### Support

If you need help or want to contribute to Typo, you should start with
the following:

-   IRC: \#typo on irc.freenode.net
-   [Mailing list](http://rubyforge.org/mailman/listinfo/typo-list)

<a name="maintainers"></a>

Maintainers
-----------

This is a list of Typo maintainers. If you have committed, please add
your name and contact details to the list.

**Frédéric de Villamil** <frederic@typosphere.org>
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
Typo](https://github.com/fdv/typo/graphs/contributors).

**Original Author: Tobias Luetke**
blog: http://blog.leetsoft.com/
irc: xal

Enjoy,
The Typo team
