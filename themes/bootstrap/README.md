# Bootstrap theme for Publify

Bootstrap is a theme designed for the [Publify][1] blogging engine by [Frédéric de Villamil][2] using [Bootstrap][3] as a framework for other theme development. It was released under the MIT Licence. Any other material such as sample photos used by the default themes are the property of their creator and licenced under the Creative Commons No Commercial Share Alike licence.

# Table of contents

1. Theme structure
 1. What makes a Publify theme
 2. Theme helpers
 3. Get into the views
     1. Understanding the views
     2. The layout
2. Changing default background
3. Changing fonts and colors
4. A three column theme

# 1. Theme structure

## 1.1 What makes a Publify theme

Bootstrap is divided into four main parts which reflect the structure of the Publify application itself:

1. helpers: custom Ruby methods, such as displaying a breadcrumb, go here.
2. images: your theme images. Backgrounds and icones go here.
3. stylesheets: this is where your CSS goes. Bootstrap uses three CSS files: 
 - bootstrap.css - which is a generated one
 - style.css - some custom structure addons 
 - user-styles.css - Publify wide
  
     You'll learn more about updating your CSS later.

4. views: these are small HTML and Ruby files called by Publify. You don't need to provide views for the whole Publify structure. If your blog can't find a view and it exists as a standard, it will just load the default. The only thing you really need is a layout.

Each theme should also include the following:

* about.markdown: this is your theme README which appears in Publify administration.
* preview.png: your theme preview image, also for administration use.

Theme root

    \__ helpers
    \__ images
    \__ stylesheets
    \__ views
        \__ articles
        \__ comments
        \__ layouts
        \__ tags
    \__ about.markdown
    \__ preview.png

## 1.2 Theme helpers

Helpers are Ruby methods usually made to build HTML content. The example of a helper is the one that builds a breadcrumb according to the page your user is currently viewing. Helpers must be in the theme_helper.rb file.

Whenever you add or change a theme helper, you'll have to restart your Publify application, even in development mode. We know it's stupid, but it seems to be due to some Rails internals and we didn't find any workaround to this yet.

## 1.3 Get into the views

> Get into the views, boy you've got to prove your love to me  
> -- Famous 80's pop song.

### 1.3.1 Understanding the views

Publify theme views follow the way you browse a blog:

* Articles
* Tags
* Comments. This one is a bit out of the normal process

For each section, you'll have two choices:

* Browse a (paginated) list. This uses the "index" template.
* View a single (paginated) item. This uses the "show" template.

Exceptions

* Single pages such as the about page have their templates located in articles/view_page.html.erb. 
* View used for article reading uses the read.html.erb template.

By default, you won't need the whole theme structure, you may even want only to customize the layout and let Publify do the job. But let's say you want to change the articles listing. In your theme views directory, create an articles folder, and copy the main article index.html.erb. Do the changes, refresh and you're done.


### 1.3.2 The layout

The layout is where everything happens in your theme. There's a chance you will only need to change this. It is located in `views/layouts`. It is divided in three parts: 

* Header
* Main content
* sidebar content

#### Header

The header is the part between the `<head>` and `</head>` sections of the HTML. Publify provides two methods you should know about: 

* `page_title` is the generated page title you should call in your `title` HTML tag. You can customize the title content into the admin SEO section.
* `page_header` includes many things like meta tags, description, some CSS, some JavaScript, etc...

#### Main content

To call the main content, just add `<%= yield %>` in your layout `<body>`. Publify will call the appropriate module according to the URL you're calling: articles, tags, etc...


#### Sidebar content

To display the generated sidebar content, just call `<%= render_sidebars %>` without your layout.

#2. Changing default background

If you don't like the Bootstrap default background, you just need to overwrite the `images/bg1.jpg` file with your own 980px x 282px background. Clean your cache from your admin and you're done.

# 3. Changing fonts and colors

Changing fonts and colors is as easy as pie. Go to the Bootstrap [customization page][4] and select the changes you want. You may want to uncheck all the jQuery plugins, but what you want is the _customize variables_ section. When you have selected your changes, click on "Customize and Download".

You will download a zip file caled bootstrap.zip. Unzip it, it contains a css directory with two CSS files: 

* bootstrap.css
* bootstrap.min.css

Take these files, and replace your Publify Bootstrap theme bootstrap.css and bootstrap.min.css files with them. You're done.

# 4. A three column theme

You can easily turn Bootstrap into a three column theme. Let's say you want to split the sidebars into two columns, one with generated content and one with advertisements. Edit the `views/layout/default.html.erb` file, and replace:

    <div id='sidebar' class='span4'>
        <%= render_sidebars %>
    </div>

With:

    <div class='span2'>
    Call your advertisement or sidebar content here.
    </div>
    <div id='sidebar' class='span2'>
        <%= render_sidebars %>
    </div>


[1]: http://publify.co
[2]: http://t37.net
[3]: http://getbootstrap.com/
[4]: http://getbootstrap.com/2.3.2/customize.html