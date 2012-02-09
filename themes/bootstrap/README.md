# Bootstrap theme for Typo

Bootstrap is a theme designed for [Typo][1] blogging engine by [Frédéric de Villamil][2] using [Twitter Bootstrap][3] as a framework for other themes development. It was released under the MIT Licence. Any other material such as sample photos used by the default themes are the property of their creator and licenced under the Creative Commons No Commercial Share Alike licence.

# Table of contents

1. Theme structure
1.1 What makes a Typo theme
1.1 Theme helpers
1.2 Get into the views
1.2.1 Understanding the views
1.2.2 The layout
2. Changin default background
3. Changing fonts and color
4. A 3 columns theme

# 1. Theme structure

## 1.1 What makes a Typo theme

Bootstrap is divided into 4 main parts which reflects the structure of the Typo application itself:

* helpers: custom Ruby methods such as displaying a breadcrumb goes there.
* images: obviously your theme images. Backgrounds and icones go there.
* stylesheets: this is where your CSS goes. Bootstrap uses 3 CSS files: bootstrap.css, which is a generated one, style.css with some custom structure addons, and a Typo wide badly named user-styles.css, but you'll learn more about updating your CSS later.
* views: these are small HTML and Ruby files called by Typo. You don't need to provide views for the whole Typo structure. If your blog can't find a view and it exists as a standard, it will just load the default one. The only thing you really need is a layout.
* about.markdown: this is your theme README which appears in Typo administration.
* preview.png: obviously your theme preview image, for administration use too.

Theme root
\__ helpers
\__ images
\__ stylesheets
\__ views
    \__ articles
	\__ categories
	\__ comments
	\__ layouts
	\__ tags
\__ about.markdown
\__ preview.png

## 1.1 Theme helpers

Helpers are Ruby methods usually made to build HTML content. The example of a helper is the one that builds a breadcrumb according to the page your user is visiting. Helpers must be in the theme_helper.rb file.

Whenever you'll add or change a theme helper, you'll have to restart your Typo application, even in development mode. We know it's stupid, but it seems to be due to some Rails internals and we didn't find any workaround to this yet.

## 1.2 Get into the views

> Get into the views, boy you've got to prove your love to me
> Famous 80's pop song.

### 1.2.1 Understanding the views

Typo theme views follow the way you browse a blog:

* Articles
* Categories
* Tags
* Comments. This one is a bit out of the normal process

For each section, you'll have 2 choices:

* Browse a (paginated) list. This uses the "index" template.
* View a single (paginated) item. This uses the "show" template.
* There is an exception for single pages such as the about page: their template are located in articles/view_page.html.erb.
* There is another exception for article reading, which uses read.html.erb template.

By default, you won't need the whole theme structure, you may even want only to customize the layout and let Typo do the job. But let's say you want to change the articles listing. In your theme views directory, create an articles folder, and copy the main article index.html.erb. Do the changes, refresh and you're done.


### 1.2.2 The layout

The layout is where everything happens in your theme. There's a chance you will only need to change this. It is located in `views/layouts`. It is divided in 3 parts: 

* Header
* Main content
* sidebar content

#### Header

The header is the part between the `<head>` and `</head>` sections of the HTML. Typo provides 2 methods you should know about: 

`page_title` is the generated page title you should call in your `title` HTML tag. You can customize the title content into the admin SEO section.
`page_header` includes many things like meta tags, description, some CSS, some Javascript...

#### Main content

To call the main content, just add `<%= yield %>` in your layout `<body>`. Typo will call the appropriate module according to the URL you're calling: articles, categories, tags...


#### Sidebar content

To display the generated sidebar content, just call `<%= render_sidebars %>` withou your layout.

#2. Changin default background

If you don't like Bootstrap default background, you just need to overwrite the `images/bg1.jpg` file with your own 980px x 282px background. Clean your cache from your admin and you're done.

# 3. Changing fonts and color

Changing fonts and colors is easy as pie. Go to the Bootstrap [customization page][4] and do the changes you want. You may want to uncheck all the jqueries plugins, but what you want is the _customize variables_ section. Change what you want, then click on "download".

You will download a zip file caled bootstrap.zip. Unzip it, it contains a css directory with 2 css files: 

* bootstrap.css
* bootstrap.min.css

Take these files, and replace your Typo Bootstrap theme bootstrap.css and bootstrap.min.css files with them. You're done.

# 4. A 3 columns theme

You can easily turn Bootstrap into a 3 columns theme. Let's say you want to split the sidebars into 2 columns, one with generated content and one with advertisement. Edit the `views/layout/default.html.erb` file, and replace:

<pre>
<div id='sidebar' class='span4'>
	<%= render_sidebars %>
</div>
</pre>

With:

<pre>
<div class='span2'>
Call your advertisement or sidebar content here.
</div>
<div id='sidebar' class='span2'>
	<%= render_sidebars %>
</div>
</pre>


[1]: http://typosphere.org
[2]: http://t37.net
[3]: http://twitter.github.com/bootstrap
[4]: http://twitter.github.com/bootstrap/download.html