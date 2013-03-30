# coding: utf-8
# Translation by Edgar J. Suarez

Localization.define("es_MX") do |l|

  # app/controllers/accounts_controller.rb
  l.store "Login successful", ""
  l.store "Login unsuccessful", ""
  l.store "An email has been successfully sent to your address with your new password", ""
  l.store "Oops, something wrong just happened", ""
  l.store "Successfully logged out", ""
  l.store "login", ""
  l.store "signup", ""
  l.store "Recover your password", ""

  # app/controllers/admin/categories_controller.rb
  l.store "Category was successfully saved.", ""
  l.store "Category could not be saved.", ""

  # app/controllers/admin/content_controller.rb
  l.store "Error, you are not allowed to perform this action", ""
  l.store "Preview", ""
  l.store "Article was successfully created", ""
  l.store "Article was successfully updated.", ""

  # app/controllers/admin/feedback_controller.rb
  l.store "Deleted", ""
  l.store "Not found", ""
  l.store "Deleted %d item(s)", ""
  l.store "Marked %d item(s) as Ham", ""
  l.store "Marked %d item(s) as Spam", ""
  l.store "Confirmed classification of %s item(s)", ""
  l.store "Not implemented", ""
  l.store "All spam have been deleted", ""
  l.store "Comment was successfully created.", ""
  l.store "Comment was successfully updated.", ""

  # app/controllers/admin/pages_controller.rb
  l.store "Page was successfully created.", ""
  l.store "Page was successfully updated.", ""

  # app/controllers/admin/profiles_controller.rb
  l.store "User was successfully updated.", ""

  # app/controllers/admin/resources_controller.rb
  l.store "Error occurred while updating Content Type.", ""
  l.store "complete", ""
  l.store "File uploaded: ", ""
  l.store "Unable to upload", ""
  l.store "Metadata was successfully updated.", ""
  l.store "Not all metadata was defined correctly.", ""
  l.store "Content Type was successfully updated.", ""

  # app/controllers/admin/settings_controller.rb
  l.store "Please review and save the settings before continuing", ""
  l.store "config updated.", ""

  # app/controllers/admin/sidebar_controller.rb
  l.store "It seems something went wrong. Maybe some of your sidebars are actually missing and you should either reinstall them or remove them manually", ""

  # app/controllers/admin/tags_controller.rb
  l.store "Tag was successfully updated.", ""

  # app/controllers/admin/themes_controller.rb
  l.store "Theme changed successfully", ""
  l.store "You are not authorized to open this file", ""
  l.store "File saved successfully", ""
  l.store "Unable to write file", ""

  # app/controllers/admin/users_controller.rb
  l.store "User was successfully created.", ""

  # app/controllers/application_controller.rb
  l.store "Localization.rtl", ""

  # app/controllers/articles_controller.rb
  l.store "No posts found...", ""
  l.store "Archives for", ""
  l.store "Archives for ", ""
  l.store ", Articles for ", ""

  # app/controllers/grouping_controller.rb
  l.store "page", ""
  l.store "everything about", ""

  # app/helpers/admin/base_helper.rb
  l.store "Cancel", "Cancelar"
  l.store "Store", ""
  l.store "Delete", "Eliminar"
  l.store "delete", ""
  l.store "Delete content", ""
  l.store "Are you sure?", ""
  l.store "Please select", ""
  l.store "All categories", "Todos las categorias"
  l.store "All authors", "Todos los autores"
  l.store "All published dates", "Todos los fechas"
  l.store "There are no %s yet. Why don't you start and create one?", ""
  l.store "or", "o"
  l.store "Save", "Guardar"
  l.store "Edit", "Editar"
  l.store "Show", ""
  l.store "Published", "Publicado"
  l.store "Unpublished", ""
  l.store "Show help on Typo macros", ""
  l.store "Back to overview", ""
  l.store "Name", "Nombre"
  l.store "Description", "Descripci&oacute;n"
  l.store "Tag", ""

  # app/helpers/admin/categories_helper.rb
  l.store "no articles", ""
  l.store "1 article", ""
  l.store "%d articles", ""

  # app/helpers/admin/content_helper.rb
  l.store "Destroy this draft", ""

  # app/helpers/admin/feedback_helper.rb
  l.store "Show conversation", ""
  l.store "Flag as %s", ""

  # app/helpers/application_helper.rb
  l.store "%%a, %%d %%b %%Y %%H:%%M:%%S GMT", ""
  l.store "%%d. %%b", ""
  l.store "%d comments", ""
  l.store "no comments", "no hay comentarios"
  l.store "1 comment", ""
  l.store "no trackbacks", "no hay trackbacks"
  l.store "1 trackback", ""
  l.store "%d trackbacks", ""

  # app/helpers/content_helper.rb
  l.store "Posted in", ""
  l.store "Tags", "Tags"
  l.store "no posts", ""
  l.store "1 post", ""
  l.store "%d posts", ""

  # app/models/article.rb
  l.store "Original article writen by", ""
  l.store "and published on", ""
  l.store "direct link to this article", ""
  l.store "If you are reading this article elsewhere than", ""
  l.store "it has been illegally reproduced and without proper authorization", ""

  # app/models/blog.rb
  l.store "You need a permalink format with an identifier : %%month%%, %%year%%, %%day%%, %%title%%", ""
  l.store "Can't end in .rss or .atom. These are reserved to be used for feed URLs", ""

  # app/models/feedback/states.rb
  l.store "Unclassified", ""
  l.store "Just Presumed Ham", ""
  l.store "Ham?", ""
  l.store "Just Marked As Ham", ""
  l.store "Ham", ""
  l.store "Spam?", ""
  l.store "Just Marked As Spam", ""
  l.store "Spam", ""

  # app/views/accounts/login.html.erb
  l.store "Sign in", ""
  l.store "I've lost my password", ""
  l.store "Login", "Login"
  l.store "Password", "Contrase&ntilde;a"
  l.store "Remember me", ""
  l.store "Submit", ""
  l.store "Back to ", ""

  # app/views/accounts/recover_password.html.erb
  l.store "Back to login", ""
  l.store "Username or email", ""

  # app/views/accounts/signup.html.erb
  l.store "Create an account", ""
  l.store "Username", "Usuario"
  l.store "Email", "Email"
  l.store "Signup", "Registro"

  # app/views/admin/categories/_categories.html.erb
  l.store "Title", "T&iacute;tulo"
  l.store "Reorder", "Reorganizar"
  l.store "Sort alphabetically", "Ordenar alfab&eacute;ticamente"

  # app/views/admin/categories/_form.html.erb
  l.store "Keywords", ""

  # app/views/admin/categories/destroy.html.erb
  l.store "Are you sure you want to delete the category ", "&iquest;Est&aacute;s seguro que quieres eliminar esta categor&iacute;a?"
  l.store "Delete this category", "Eliminar esta categor&iacute;a"
  l.store "Categories", ""

  # app/views/admin/categories/index.html.erb
  l.store "New Category", ""

  # app/views/admin/categories/new.html.erb
  l.store "%s Category", ""

  # app/views/admin/categories/reorder.html.erb
  l.store "(Done)", "(Hecho)"

  # app/views/admin/content/_attachment.html.erb
  l.store "Remove", "Remover"
  l.store "Currently this article has the following resources", "Este art&iacute;culo tiene los siguientes recursos"
  l.store "You can associate the following resources", "Puedes asociarlo con los siguientes recursos"
  l.store "Really delete attachment", "&iquest;Realmente deseas borrar este archivo?"
  l.store "Add another attachment", "Agregar Otro Archivo"

  # app/views/admin/content/_drafts.html.erb
  l.store "Drafts", ""

  # app/views/admin/content/_form.html.erb
  l.store "Publish settings", ""
  l.store "Allow comments", "Se permiten comentarios"
  l.store "Allow trackbacks", "Se permiten trackbacks"
  l.store "Password:", ""
  l.store "Publish", "Publicar"
  l.store "Tags", ""
  l.store "Separate tags with commas. Use double quotes (&quot;) around multi-word tags, e.g. &quot;opera house&quot;.", ""
  l.store "Excerpt", ""
  l.store "Excerpts are post summaries that show only on your blog homepage and won’t appear on the post itself", ""
  l.store "Uploads", ""
  l.store "Post settings", ""
  l.store "Publish at", "Publicado el"
  l.store "Permalink", "Link permanente"
  l.store "Article filter", "Filtro de art&iacute;culo"
  l.store "Save as draft", ""
  l.store "New article", ""
  l.store "disabled", ""
  l.store "Markdown with SmartyPants", ""
  l.store "Markdown", ""
  l.store "Texttile", ""
  l.store "None", ""
  l.store "SmartyPants", ""
  l.store "Visual", ""
  l.store "Edit article", ""
  

  # app/views/admin/content/destroy.html.erb
  l.store "Are you sure you want to delete this article", "&iquest;Est&aacute;s seguro que deseas borrar este art&iacute;culo?"
  l.store "Delete this article", "Eliminar este art&iacute;culo"
  l.store "Articles", ""

  # app/views/admin/content/index.html.erb
  l.store "New Article", ""
  l.store "Search articles that contain ...", ""
  l.store "Search", ""
  l.store "Author", "Autor"
  l.store "Date", ""
  l.store "Feedback", ""
  l.store "Filter", ""
  l.store "Manage articles", ""
  l.store "Select a category", ""
  l.store "Select an author", ""
  l.store "Publication date", ""

  # app/views/admin/dashboard/_comments.html.erb
  l.store "Error: can't generate secret token. Security is at risk. Please, change %s content", ""
  l.store "For security reasons, you should restart your Typo application. Enjoy your blogging experience.", ""
  l.store "Latest Comments", ""
  l.store "No comments yet", ""
  l.store "By %s on %s", ""

  # app/views/admin/dashboard/_inbound.html.erb
  l.store "Inbound links", ""
  l.store "No one made a link to you yet", ""
  l.store " made a link to you saying ", ""
  l.store "You have no internet connection", ""

  # app/views/admin/dashboard/_overview.html.erb
  l.store "This place gives you a quick overview of what happens on your Typo blog and what you can do. Maybe will you want to %s, %s or %s.", ""
  l.store "update your profile or change your password", ""
  l.store "You can also do a bit of design, %s or %s.", ""
  l.store "change your blog presentation", ""
  l.store "enable plugins", ""
  l.store "write a post", ""
  l.store "write a page", ""

  # app/views/admin/dashboard/_popular.html.erb
  l.store "Most popular", ""
  l.store "Nothing to show yet", ""

  # app/views/admin/dashboard/_posts.html.erb
  l.store "Latest Posts", ""
  l.store "No posts yet, why don't you start and write one", ""

  # app/views/admin/dashboard/_typo_dev.html.erb
  l.store "Latest news from the Typo development blog", ""
  l.store "Oh no, nothing new", ""

  # app/views/admin/dashboard/_welcome.html.erb
  l.store "Welcome back, %s!", ""
  l.store "%d articles and %d comments were posted since your last connexion", ""
  l.store "You're running Typo %s", ""
  l.store "Total posts : %d", ""
  l.store "Your posts : %d", ""
  l.store "Total comments : %d", ""
  l.store "Spam comments : %d", ""

  # app/views/admin/feedback/_button.html.erb
  l.store "Select action", ""
  l.store "Delete Checked Items", ""
  l.store "Delete all spam", ""
  l.store "Mark Checked Items as Spam", ""
  l.store "Mark Checked Items as Ham", ""
  l.store "All comments", ""
  l.store "Limit to ham", ""
  l.store "Unapproved comments", ""
  l.store "Limit to spam", "Limitar a spam"

  # app/views/admin/feedback/_form.html.erb
  l.store "Add a comment", ""
  l.store "Url", "Url"

  # app/views/admin/feedback/_spam.html.erb
  l.store "This comment by <strong>%s</strong> was flagged as spam, %s?", ""

  # app/views/admin/feedback/article.html.erb
  l.store "Comments for %s", ""
  l.store "Status", "Estado"
  l.store "Comment Author", ""
  l.store "Comment", ""

  # app/views/admin/feedback/edit.html.erb
  l.store "Comments for", "Comentarios para"

  # app/views/admin/feedback/index.html.erb
  l.store "Search Comments and Trackbacks that contain", ""
  l.store "Article", ""

  # app/views/admin/pages/_form.html.erb
  l.store "Online", "Online"
  l.store "Page settings", ""
  l.store "Permanent link", ""

  # app/views/admin/pages/destroy.html.erb
  l.store "Pages","P&aacute;ginas"
  l.store "Are you sure you want to delete the page", "&iquest;Est&aacute;s seguro que deseas eliminar esta p&aacute;gina?"
  l.store "Delete this page", "Eliminar esta p&aacute;gina"

  # app/views/admin/pages/index.html.erb
  l.store "New Page", ""
  l.store "Manage pages", ""

  # app/views/admin/profiles/index.html.erb
  l.store "Your profile", ""

  # app/views/admin/resources/_mime_edit.html.erb
  l.store "Content Type", "Content Type"

  # app/views/admin/resources/_pages.html.erb
  l.store "Previous page", "P&aacute;gina anterior"
  l.store "Next page", "P&aacute;gina siguiente"

  # app/views/admin/resources/_upload.html.erb
  l.store "Upload a File to your Site", "Sube un Archivo a tu sitio"
  l.store "File", ""
  l.store "Upload", "Subir"

  # app/views/admin/resources/destroy.html.erb
  l.store "Are you sure you want to delete this file", "&iquest;Est&aacute;s seguro que deseas eliminar este archivo?"
  l.store "Delete this file from the webserver?", "&iquest;Eliminar este archivo del servidor?"
  l.store "File Uploads", "Archivos subidos"

  # app/views/admin/resources/images.html.erb
  l.store "Thumbnail", ""
  l.store "File Size", "Tama&ntilde;o del Archivo"
  l.store "Images", ""
  l.store "right-click for link", ""

  # app/views/admin/resources/index.html.erb
  l.store "Filename", "Nombre del archivo"
  l.store "Browse", ""

  # app/views/admin/seo/index.html.erb
  l.store "SEO", ""
  l.store "Global SEO settings", ""
  l.store "Titles", ""
  l.store "General settings", ""
  l.store "Use meta keywords", ""
  l.store "Meta description", ""
  l.store "Meta keywords", ""
  l.store "Use RSS description", ""
  l.store "RSS description message", ""
  l.store "Indexing", ""
  l.store "Do not index categories", ""
  l.store "Checking this box will add <code>noindex, follow</code> meta tags in every category page, removing them from search engines and preventing duplicate content issues", ""
  l.store "Do not index tags", ""
  l.store "Checking this box will add <code>noindex, follow</code> meta tags in every tags page, removing them from search engines and preventing duplicate content issues", ""
  l.store "Robots.txt", ""
  l.store "You robots.txt file is not writeable. Typo won't be able to write it", ""
  l.store "Use dofollow in comments", ""
  l.store "You may want to moderate feedback when turning this on", ""
  l.store "Use canonical URL", ""
  l.store "Read more about %s", ""
  l.store "Google", ""
  l.store "Google Analytics", ""
  l.store "Google Webmaster Tools validation link", ""
  l.store "Custom tracking code", ""
  l.store "Global settings", ""
  l.store "This will display", ""
  l.store "at the bottom of each post in the RSS feed", ""
  l.store "Here you can add anything you want to appear in your application header, such as analytics service tracking code.", "" 

  # app/views/admin/seo/permalinks.html.erb
  l.store "Typo offers you the ability to create a custom URL structure for your permalinks and archives. This can improve the aesthetics, usability, and forward-compatibility of your links.", ""
  l.store "Here are some examples to get you started.", ""
  l.store "Permalink format", ""
  l.store "Date and title", ""
  l.store "Month and title", ""
  l.store "Title only", ""
  l.store "You can custom your URL structure using the following tags:", ""
  l.store "your article slug. <strong>Using this slug is mandatory</strong>.", ""
  l.store "your article year of publication.", ""
  l.store "your article month of publication.", ""
  l.store "your article day of publication.", ""
  l.store "Permalinks", ""
  l.store "Custom", ""

  # app/views/admin/seo/titles.html.erb
  l.store "Title settings", ""
  l.store "Home", ""
  l.store "Title template", ""
  l.store "Description template", ""
  l.store "Articles", ""
  l.store "Pages", ""
  l.store "Paginated archives", ""
  l.store "Dated archives", ""
  l.store "Author page", ""
  l.store "Search results", ""
  l.store "Help on title settings", ""
  l.store "Replaced with the title of the article/page", ""
  l.store "The blog's name", ""
  l.store "The blog's tagline / description", ""
  l.store "Replaced with the post/page excerpt", ""
  l.store "Replaced with the article tags (comma separated)", ""
  l.store "Replaced with the article categories (comma separated)", ""
  l.store "Replaced with the article/page title", ""
  l.store "Replaced with the category/tag name", ""
  l.store "Replaced with the current search phrase", ""
  l.store "Replaced with the current time", ""
  l.store "Replaced with the current date", ""
  l.store "Replaced with the current month", ""
  l.store "Replaced with the current year", ""
  l.store "Replaced with the current page number", ""
  l.store "Replaced by the archive date", ""
  l.store "These tags can be included in your templates and will be replaced when displaying the page.", ""

  # app/views/admin/settings/_submit.html.erb
  l.store "Update settings", ""

  # app/views/admin/settings/feedback.html.erb
  l.store "Spam protection", ""
  l.store "Enable comments by default", "Habilitar comentarios por default"
  l.store "Enable Trackbacks by default", "Habilitar Trackbacks por default"
  l.store "Enable feedback moderation", "Habilitar moderaci&oacute;n de comentarios y trackbacks"
  l.store "You can enable site wide feedback moderation. If you do so, no comment or trackback will appear on your blog unless you validate it.", ""
  l.store "Comments filter", "Filtro de comentarios"
  l.store "Enable gravatars", "Habilitar gravatars"
  l.store "Show your email address", "Mostrar tu direcci&oacute;n de email"
  l.store "Notifications", ""
  l.store "Typo can notify you when new articles or comments are posted", "Typo puede notificarte cuando nuevos art&iacute;culos o comentarios sean a&ntilde;adidos"
  l.store "Source Email", "Email remitente"
  l.store "Email address used by Typo to send notifications", "Direcci&oacute;n de email usada por Typo para enviar notificaciones"
  l.store "Enabling spam protection will make Typo compare the IP address of posters as well as the contents of their posts against local and remote blacklists. Good defense against spam bots", "Habilitando la protecci&oacute;n anti-spam har&aacute; que typo compare la direcci&oacute;n IP del usuario as&iacute; como el contenido de sus comentarios contra una lista negra remota o local. Es una buena defensa contra los robots de spam"
  l.store "Enable spam protection", "Habilitar protecci&oacute;n anti-spam"
  l.store "Akismet Key", "Clave de Akismet (API key)"
  l.store "Typo can (optionally) use the %s spam-filtering service.  You need to register with Akismet and receive an API key before you can use their service.  If you have an Akismet key, enter it here", "Typo puede (opcionalmente) usar el servicio anti-spam de %s. Necesitas registrarte en Akismet y obtener una API key antes de poder usar su servicio. Si tienes una clave de Akismet, introd&uacute;cela aqu&iacute;"
  l.store "Disable trackbacks site-wide", ""
  l.store "This setting allows you to disable trackbacks for every article in your blog.  It won't remove existing trackbacks, but it will prevent any further attempt to add a trackback anywhere on your blog.", "Esta opci&oacute;n te permite deshabilitar trackbacks para cada art&iacute;culo en tu blog. Esto no remover&aacute; trackbacks existentes, pero impedir&aacute; cualquier intento futuro para a&ntilde;adir una trackback en cualquier parte de tu blog."
  l.store "Disable comments after", "Deshabilitar comentarios despu&eacute;s de"
  l.store "days", "d&iacute;as"
  l.store "Set to 0 to never disable comments", "Introducir 0 para nunca deshabilitar comentarios"
  l.store "Max Links", "M&aacute;ximo n&uacute;mero de links"
  l.store "Typo will automatically reject comments and trackbacks which contain over a certain amount of links in them", "Typo rechazar&aacute; autom&aacute;ticamente los comentarios y trackbacks que contengan m&aacute;s de un cierto n&uacute;mero de links en ellos"
  l.store "Set to 0 to never reject comments", "Introducir 0 para nunca rechazar comentarios"
  l.store "Feedback settings", ""

  # app/views/admin/settings/index.html.erb
  l.store "Your blog", "Tu sitio"
  l.store "Blog name", "Nombre del blog"
  l.store "Blog subtitle", "Subt&iacute;tulo del blog"
  l.store "Blog URL", "URL del blog"
  l.store "Language", "Idioma" #Need translate
  l.store "Allow users to register", ""
  l.store "You can allow users to register to your blog. By default, they will register as contributors, an unpriviledged account level which grant them no rights but own a profile on the site. If you don't want users to register, you can thus add them by yourself in the users part of this admin.", ""
  l.store "Items to display in admin lists", ""
  l.store "Publishing options", ""
  l.store "Display", "Mostrar"
  l.store "articles on my homepage by default", "art&iacute;culos en mi p&aacute;gina de inicio por default"
  l.store "articles in my news feed by default", "art&iacute;culos en mi feed RSS"
  l.store "Show full article on feed", "Mostrar art&iacute;culo completo en el feed"
  l.store "Feedburner ID", ""
  l.store "General settings", "Preferencias generales"
  l.store "You can use your Google Feedburner account instead of Typo feed URL. To enable this, fill this form with your Feedburner ID.", ""

  # app/views/admin/settings/seo.html.erb
  l.store "Search Engine Optimisation", ""
  l.store "Format of permalink", ""
  l.store "Google Analytics", ""
  l.store "Google verification link", ""
  l.store "Meta description", ""
  l.store "Meta keywords", ""
  l.store "Use RSS description", ""
  l.store "Index categories", ""
  l.store "Unchecking this box will add <code>noindex, follow</code> meta tags in every category page, removing them from search engines and preventing duplicate content issues", ""
  l.store "Index tags", ""
  l.store "Unchecking this box will add <code>noindex, follow</code> meta tags in every tags page, removing them from search engines and preventing duplicate content issues", ""
  l.store "Robots.txt", ""
  l.store "You robots.txt file is not writeable. Typo won't be able to write it", ""
  l.store "Search Engine Optimization", ""
  l.store "This will display", ""
  l.store "at the bottom of each post in the RSS feed", ""
  l.store "Here you can add anything you want to appear in your application header, such as analytics service tracking code.", ""

  # app/views/admin/settings/update_database.html.erb
  l.store "Information", "Informaci&oacute;n"
  l.store "Current database version", "Versi&oacute;n actual de la base de datos"
  l.store "New database version", "Nueva versi&oacute;n de la base de datos"
  l.store "Your database supports migrations", "Tu base de datos soporta migraciones"
  l.store "Needed migrations", "Migraciones necesarias"
  l.store "You are up to date!", "Est&aacute;s al d&iacute;a!"
  l.store "Update database now", "Actualizar la base de datos ahora"
  l.store "may take a moment", "puede tomar un momento"
  l.store "Database migration", "Migraci&oacute;n de la base de datos"
  l.store "yes", "s&iacute;"
  l.store "no", "no"

  # app/views/admin/settings/write.html.erb
  l.store "Send trackbacks", "Enviar trackbacks"
  l.store "When publishing articles, Typo can send trackbacks to websites that you link to. This should be disabled for private blogs as it will leak non-public information to sites that you're discussing. For public blogs, there's no real point in disabling this.", "Cuando se publican art&iacute;culos, Typo puede enviar trackbacks a sitios enlazados. Esto deber&iacute;a deshabilitarse para blogs privados para que no se escape informaci&oacute;n privada a sitios que est&aacute;s comentando. Para blogs p&uacute;blicos, realmente no hay raz&oacute;n para deshabilitar esto."
  l.store "URLs to ping automatically", "Enviar pings a URLs autom&aacute;ticamente"
  l.store "Latitude, Longitude", "Latitud, Longitud"
  l.store "your latitude and longitude", "tu latitud y longitud"
  l.store "example", "ejemplo"
  l.store "Write", "Escribir"

  # app/views/admin/sidebar/_availables.html.erb
  l.store "You have no plugins installed", "No tienes plugins instalados"

  # app/views/admin/sidebar/_publish.html.erb
  l.store "Changes published", "Cambios publicados"

  # app/views/admin/sidebar/_target.html.erb
  l.store "Drag some plugins here to fill your sidebar", "Arrastra algunos plugins aqu&iacute; para llenar tu barra lateral"

  # app/views/admin/sidebar/index.html.erb
  l.store "Drag and drop to change the sidebar items displayed on this blog. To remove items from the sidebar just click 'remove'. Changes are saved immediately, but not activated until you click the 'Publish changes' button", ""
  l.store "Available Items", "Items disponibles"
  l.store "Active Sidebar items", "Items activos de la barra lateral"
  l.store "Get more plugins", ""
  l.store "Sidebar", ""
  l.store "Publish changes", "Publicar cambios"
  l.store "Adds sidebar links to any Amazon.com books linked in the body of the page", ""
  l.store "Displays links to monthly archives", ""
  l.store "Displays a list of authors ordered by name with links to their articles and profile", ""
  l.store "Livesearch", ""
  l.store "Adds livesearch to your Typo blog", ""
  l.store "This widget just displays links to Typo main site, this blog's admin and RSS.", ""
  l.store "Page", ""
  l.store "Show pages for this blog", ""
  l.store "Adds basic search sidebar in your Typo blog", ""
  l.store "Static", ""
  l.store "Static content, like links to other sites, advertisements, or blog meta-information", ""
  l.store "Show most popular tags for this blog", ""
  l.store "RSS and Atom feeds", ""
  l.store "XML Syndication", ""
  l.store "remove", "supprimer"

  # app/views/admin/tags/_form.html.erb
  l.store "Display name", "Nombre para mostrar"

  # app/views/admin/tags/destroy.html.erb
  l.store "Are you sure you want to delete the tag", ""
  l.store "Delete this tag", ""

  # app/views/admin/tags/edit.html.erb
  l.store "Editing ", ""
  l.store "Back to tags list", ""

  # app/views/admin/tags/index.html.erb
  l.store "Display Name", ""
  l.store "Manage tags", ""

  # app/views/admin/themes/catalogue.html.erb
  l.store "Sorry the theme catalogue is not available", ""
  l.store "Theme catalogue", ""

  # app/views/admin/themes/editor.html.erb
  l.store "Theme editor", ""

  # app/views/admin/themes/index.html.erb
  l.store "Active theme", "Tema activo"
  l.store "Choose a theme", "Escoge un tema"
  l.store "Use this theme", ""

  # app/views/admin/users/_form.html.erb
  l.store "Account settings", ""
  l.store "Password confirmation", "Confirmar Contrase&ntilde;a"
  l.store "Profile", ""
  l.store "User's status", ""
  l.store "Active", ""
  l.store "Inactive", ""
  l.store "Profile settings", ""
  l.store "Firstname", ""
  l.store "Lastname", ""
  l.store "Nickname", ""
  l.store "Editor", ""
  l.store "Use simple editor", ""
  l.store "Use visual rich editor", ""
  l.store "Send notification messages via email", "Enviar notificaciones por email"
  l.store "Send notification messages when new articles are posted", "Enviar notificaciones cuando un nuevo art&iacute;culo sea publicado"
  l.store "Send notification messages when comments are posted", "Enviar notificaciones cuando un nuevo comentario sea publicado"
  l.store "Contact options", ""
  l.store "Your site", ""
  l.store "display URL on public profile", ""
  l.store "Your MSN", ""
  l.store "display MSN ID on public profile", ""
  l.store "Your Yahoo ID", ""
  l.store "display Yahoo! ID on public profile", ""
  l.store "Your Jabber ID", ""
  l.store "display Jabber ID on public profile", ""
  l.store "Your AIM id", ""
  l.store "display AIM ID on public profile", ""
  l.store "Your Twitter username", ""
  l.store "display Twitter on public profile", ""
  l.store "Tell us more about you", ""

  # app/views/admin/users/destroy.html.erb
  l.store "Really delete user", "&iquest;Realmente desea eliminar este usuario?"
  l.store "Yes", ""
  l.store "Users", ""

  # app/views/admin/users/edit.html.erb
  l.store "Edit User", "Editar usuario"

  # app/views/admin/users/index.html.erb
  l.store "New User", "Nuevo Usuario"
  l.store "Comments", ""
  l.store "State", ""
  l.store "%s user", ""
  l.store "Manage users", ""

  # app/views/admin/users/new.html.erb
  l.store "Add User", ""

  # app/views/articles/_article.html.erb
  l.store "Posted by", "Publicado por"
  l.store "Continue reading", ""

  # app/views/articles/_comment.html.erb
  l.store "said", "dijo"
  l.store "This comment has been flagged for moderator approval.  It won't appear on this blog until the author approves it", ""

  # app/views/articles/_comment_box.html.erb
  l.store "Your name", "Tu nombre"
  l.store "Your email", "Tu email"
  l.store "Your message", "Tu comentario"
  l.store "Comment Markup Help", "Ayuda del marcado"
  l.store "Preview comment", "Previsualizar comentario"
  l.store "leave url/email", ""

  # app/views/articles/_comment_failed.html.erb
  l.store "Oops, something wrong happened, the comment could not be saved", ""

  # app/views/articles/_trackback.html.erb
  l.store "From", "De"

  # app/views/articles/archives.html.erb
  l.store "No articles found", "No se encontraron art&iacute;culos"
  l.store "posted in", ""

  # app/views/articles/comment_preview.html.erb
  l.store "is about to say", "est&aacute; a punto de decir"

  # app/views/articles/groupings.html.erb
  l.store "There are", "Hay"

  # app/views/articles/read.html.erb
  l.store "Leave a response", "Deja un comentario"
  l.store "Trackbacks", ""
  l.store "Use the following link to trackback from your own site", "Usa el siguiente link para crear un trackback desde tu propio sitio"
  l.store "RSS feed for this post", "Feed RSS para este art&iacute;culo"
  l.store "trackback uri", "trackback uri"
  l.store "Comments are disabled", "Los comentarios est&aacute;n deshabilitados"
  l.store "Trackbacks are disabled", ""

  # app/views/authors/show.html.erb
  l.store "Web site:", ""
  l.store "MSN:", ""
  l.store "Yahoo:", ""
  l.store "Jabber:", ""
  l.store "AIM:", ""
  l.store "Twitter:", ""
  l.store "About %s", ""
  l.store "This author has not published any article yet", ""

  # app/views/comments/show.html.erb
  l.store "This comment has been flagged for moderator approval.", ""

  # app/views/layouts/administration.html.erb
  l.store "Logged in as %s", "Bienvenido, %s"
  l.store "%s &raquo;", ""
  l.store "Help", "Ayuda"
  l.store "Documentation", "Documentación"
  l.store "Report a bug", "Informar de un error"
  l.store "In page plugins", ""
  l.store "Sidebar plugins", ""
  l.store "is proudly powered by", ""
  l.store "Dashboard", ""

  # app/views/setup/index.html.erb
  l.store "Welcome", ""
  l.store "Welcome to your %s blog setup. Just fill in your blog title and your email, and Typo will take care of everything else", ""

  # app/views/shared/_confirm.html.erb
  l.store "Congratulations!", ""
  l.store "You have successfully signed up", ""
  l.store "<strong>Login:</strong> %s", ""
  l.store "<strong>Password:</strong> %s", ""
  l.store "Don't lose the mail sent at %s or you won't be able to login anymore", ""
  l.store "Proceed to %s", ""
  l.store "admin", ""

  # app/views/shared/_search.html.erb
  l.store "Live Search", ""

  # test/mocks/themes/typographic/layouts/default.html.erb
  l.store "Powered by %s", ""
  l.store "Designed by %s ", ""

  # test/mocks/themes/typographic/views/articles/_article.html.erb
  l.store "Continue reading...", ""
  l.store "This entry was posted on %s", ""
  l.store "and %s", ""
  l.store "You can follow any response to this entry through the %s", ""
  l.store "Atom feed", ""
  l.store "You can leave a %s", ""
  l.store "or a %s from your own site", ""
  l.store "Read full article", ""
  l.store "comment", ""
  l.store "trackback", ""

  # test/mocks/themes/typographic/views/articles/_comment.html.erb
  l.store "later", ""

  # test/mocks/themes/typographic/views/articles/_comment_form.html.erb
  l.store "Leave a comment", ""
  l.store "Name %s", ""
  l.store "enabled", ""
  l.store "never displayed", ""
  l.store "Website", ""
  l.store "Textile enabled", ""
  l.store "Markdown enabled", ""
  l.store "required", ""

  # test/mocks/themes/typographic/views/articles/_comment_list.html.erb
  l.store "No comments", ""

  # test/mocks/themes/typographic/views/shared/_search.html.erb
  l.store "Searching", ""

  # themes/dirtylicious/layouts/default.html.erb
  l.store "Home", ""
  l.store "About", ""
  l.store "Designed by %s ported to typo by %s ", ""

  # themes/scribbish/layouts/default.html.erb
  l.store "styled with %s", ""

  # themes/scribbish/views/articles/_article.html.erb
  l.store "Meta", ""
  l.store "permalink", ""

  # themes/true-blue-3/helpers/theme_helper.rb
  l.store "You are here: ", ""
  l.store "%d comment", ""

  # themes/true-blue-3/views/articles/_article.html.erb
  l.store "%%a, %%d %%b %%Y %%H:%%M", ""

  # themes/true-blue-3/views/articles/_comment.html.erb
  l.store "By", ""
  l.store "later:", ""

  # themes/true-blue-3/views/articles/_comment_form.html.erb
  l.store "Email address", ""
  l.store "Your website", ""

  # themes/true-blue-3/views/articles/read.html.erb
  l.store "If you liked this article you can %s", ""
  l.store "add me to Twitter", ""
  l.store "Trackbacks for", "Trackbacks para"

  # themes/true-blue-3/views/articles/search.html.erb
  l.store "Search results for:", ""

  # themes/true-blue-3/views/categories/index.html.erb
  l.store "Read all articles in %s", ""

  # themes/true-blue-3/views/categories/show.html.erb
  l.store "Previous", ""
  l.store "Next", ""

  # vendor/plugins/archives_sidebar/views/content.rhtml
  l.store "Archives", ""

  # vendor/plugins/authors_sidebar/views/content.rhtml
  l.store "Authors", ""

  # vendor/plugins/xml_sidebar/views/content.rhtml
  l.store "Syndicate", ""
  l.store "Category %s", ""
  l.store "Tag %s", ""

  # Obsolete translations
  l.store "%d Articles", ["Art&iacute;culo", "%d Art&iacute;culos"]
  l.store "%d Categories", ["Categor&iacute;", "%d Categor&iacute;as"]
  l.store "%d Comments", ["Comentario", "%d Comentarios"]
  l.store "%d Trackbacks", ["Trackback", "%d Trackbacks"]
  l.store "%d Users", ["Usuario", "%d Usuarios"]
  l.store "Action", "Acci&oacute;n"
  l.store "Activate", "Activar"
  l.store "Add MetaData", "Agregar metadata"
  l.store "Add category", "Agregar categor&iacute;a"
  l.store "Add new user", "Agregar un nuevo usuario"
  l.store "Add pattern", "Agregar patr&oacute;n"
  l.store "Allow non-ajax comments", "Permitir comentarios sin Ajax"
  l.store "Are you sure you want to delete this filter", "&iquest;Est&aacute;s seguro que deseas eliminar este filtro?"
  l.store "Are you sure you want to delete this item?", "&iquest;Est&aacute;s seguro que quieres borrar este item?"
  l.store "Article Attachments", "Archivos adjuntos"
  l.store "Article Body", "Cuerpo del Art&iacute;culo"
  l.store "Article Content", "Contenido del Art&iacute;culo"
  l.store "Article Options", "Opciones del Art&iacute;culo"
  l.store "Articles in", "Art&iacute;culos en"
  l.store "Attachments", "Archivos adjuntos"
  l.store "Back to the blog", "Regresar al blog"
  l.store "Blacklist", "Lista negra"
  l.store "Blacklist Patterns", "Lista negra"
  l.store "Blog settings", "Preferencias del Blog"
  l.store "Body", "Comentario"
  l.store "Cache", "Cach&eacute;"
  l.store "Category title", "T&iacute;tulo de la categor&iacute;a"
  l.store "Choose password", "Escoge una contrase&ntilde;a"
  l.store "Comments and Trackbacks for", "Comentarios y Trackbacks para"
  l.store "Confirm password", "Confirma tu contrase&ntilde;a"
  l.store "Copyright Information", "Copyright"
  l.store "Create new Blacklist", "Crearea unei noi liste negre"
  l.store "Create new category", "Crear nueva categor&iacute;a"
  l.store "Create new page", "Crear una nueva p&aacute;gina"
  l.store "Create new text filter", "Crea un nuevo filtro de texto"
  l.store "Creating comment", "A&ntilde;adiendo comentario"
  l.store "Creating text filter", "Creando filtro de texto"
  l.store "Creating trackback", "Creando trackback"
  l.store "Creating user", "Creando usuario"
  l.store "Currently this article is listed in following categories", "Este art&iacute;lo se encuentra en las siguientes categor&iacute;s"
  l.store "Customize Sidebar", "Personaliza la barra lateral"
  l.store "Delete this filter", "Eliminar este filtro"
  l.store "Design", "Dise&ntilde;o"
  l.store "Desired login", "Usuario deseado"
  l.store "Discuss", "Discusi&oacute;n"
  l.store "Do you want to go to your blog?", "&iquest;Quieres ir a tu blog?"
  l.store "Duration", "Duraci&oacute;n"
  l.store "Edit Article", "Editar Art&iacute;culo"
  l.store "Edit MetaData", "Editar metadata"
  l.store "Edit this article", "Editar este art&iacute;culo"
  l.store "Edit this category", "Editar esta categor&iacute;a"
  l.store "Edit this filter", "Editar este filtro"
  l.store "Edit this page", "Editar esta p&aacute;gina"
  l.store "Edit this trackback", "Editar este trackback"
  l.store "Editing User", "Editando usuario"
  l.store "Editing category", "Editando categor&iacute;a"
  l.store "Editing comment", "Editando comentario"
  l.store "Editing page", "Editando p&aacute;gina"
  l.store "Editing pattern", "Editando patr&oacute;n"
  l.store "Editing textfilter", "Editando filtro de texto"
  l.store "Editing trackback", "Editando trackback"
  l.store "Empty Fragment Cache", "Limpiar el cach&eacute; por fragmentos"
  l.store "Explicit", "Expl&iacute;cito"
  l.store "Extended Content", "Contenido Extendido"
  l.store "Feedback Search", "B&uacute;squeda de comentarios"
  l.store "Filters", "Filtros"
  l.store "General Settings", "Preferencias generales"
  l.store "IP", "Direcci&oacute;n IP"
  l.store "Jabber", "Jabber"
  l.store "Jabber account", "Cuenta de Jabber"
  l.store "Jabber account to use when sending Jabber notifications", "Cuenta de Jabber usada cuando se env&iacute;an notificaciones por Jabber"
  l.store "Jabber password", "Contrase&ntilde;a de Jabber"
  l.store "Key Words", "Palabras clave"
  l.store "Last updated", "&Uacute;ltima actualizaci&oacute;n"
  l.store "Limit to unconfirmed", "Limitar a no confirmados"
  l.store "Limit to unconfirmed spam", "Limitar a spam no confirmado"
  l.store "Location", "Ubicaci&oacute;n"
  l.store "Logoff", "Salir"
  l.store "Macro Filter Help", "Ayuda de Macro Filtros"
  l.store "Macros", "Macros"
  l.store "Manage", "Administrar"
  l.store "Manage Articles", "Administrar Art&iacute;culos"
  l.store "Manage Categories", "Administrar categor&iacute;as"
  l.store "Manage Pages", "Administrar P&aacute;ginas"
  l.store "Manage Resources", "Administrar Recursos"
  l.store "Manage Text Filters", "Configurar Filtros de Texto"
  l.store "Markup", "Marcado"
  l.store "Markup type", "Tipo de marcado"
  l.store "MetaData", "Metadata"
  l.store "Not published by Apple", "No publicado por Apple"
  l.store "Notification", "Notificaci&oacute;n"
  l.store "Notified", "Notificado"
  l.store "Notify on new articles", "Notificar para nuevos art&iacute;culos"
  l.store "Notify on new comments", "Notificar para nuevos comentarios"
  l.store "Notify via email", "Notificar por email"
  l.store "Number of Articles", "N&uacute;mero de Art&iacute;culos"
  l.store "Number of Comments", "N&uacute;mero de Comentarios"
  l.store "Offline", "Offline"
  l.store "Older posts", "Art&iacute;culos anteriores"
  l.store "Optional Name", "Nombre opcional"
  l.store "Page Body", "Cuerpo de la P&aacute;gina"
  l.store "Page Options", "Opciones de la p&aacute;gina"
  l.store "Parameters", "Par&aacute;metros"
  l.store "Password Confirmation", "Confirmar Contrase&ntilde;a"
  l.store "Pattern", "Patr&oacute;n"
  l.store "Pictures from", "Im&aacute;genes de"
  l.store "Post title", "T&iacute;tulo del art&iacute;culo"
  l.store "Post-processing filters", "Filtro post-procesado"
  l.store "Posted at", "Publicado el"
  l.store "Posted date", "Fecha de publicaci&oacute;n"
  l.store "Preview Article", "Previsualizar Art&iacute;culo"
  l.store "Read", "Leer"
  l.store "Read more", "Leer m&aacute;s"
  l.store "Rebuild cached HTML", "Reconstruir HTML cacheado"
  l.store "Recent comments", "Comentarios recientes"
  l.store "Recent trackbacks", "Trackbacks recientes"
  l.store "Regex", "Expresi&oacute;n regular"
  l.store "Remove iTunes Metadata", "Remover metadata de iTunes"
  l.store "Resource MetaData", "Metadata"
  l.store "Resource Settings", "Preferencias de recursos"
  l.store "Save Settings", "Guardar preferencias"
  l.store "See help text for this filter", "Ver ayuda para este filtro"
  l.store "Set iTunes metadata for this enclosure", "Introduce la metada de iTunes para este contenido"
  l.store "Setting for channel", "Utilizado para el canal"
  l.store "Settings", "Configuraci&oacute;n"
  l.store "Show Help", "Mostrar Ayuda"
  l.store "Show this article", "Mostrar este art&iacute;culo"
  l.store "Show this category", "Mostrar esta categor&iacute;a"
  l.store "Show this comment", "Mostrar este comentario"
  l.store "Show this page", "Mostrar esta p&aacute;gina"
  l.store "Show this pattern", "Mostrar este patr&oacute;n"
  l.store "Show this user", "Mostrar este usuario"
  l.store "Spam Protection", "Protecci&oacute;n anti-spam"
  l.store "Spam protection", "Protecci&oacute;n anti-spam"
  l.store "String", "Cadena"
  l.store "Subtitle", "Subt&iacute;tulo"
  l.store "Summary", "Resumen"
  l.store "Text Filter Details", "Detalles del filtro de texto"
  l.store "Text Filters", "Filtros de Texto"
  l.store "Textfilter", "Filtro de texto"
  l.store "The below settings act as defaults when you choose to publish an enclosure with iTunes metadata", "Las preferencias debajo son tomadas como predeterminadas cuando publicas contenido protegido con metadata de iTunes"
  l.store "Things you can do", "Cosas que puedes hacer"
  l.store "This option let you choose between the simple admin interface or the complete one, displaying much more options and therefore more complicated to use. For advanced users only!", ""
  l.store "Type", "Tipo"
  l.store "Typo admin", "Administrar Typo"
  l.store "Upload a new File", "Subir un nuevo archivo"
  l.store "Upload a new Resource", "Subir un nuevo Recurso"
  l.store "Uploaded", "Subido"
  l.store "User's articles", "Art&iacute;culos del usuario"
  l.store "View article on your blog", "Ver art&iacute;culo en tu blog"
  l.store "View comment on your blog", "Ver comentario en tu blog"
  l.store "View page on your blog", "Ver p&aacute;gina en tu blog"
  l.store "Which settings group would you like to edit", "&iquest;Qu&eacute; grupo de preferencias te gustar&iacute;a editar?"
  l.store "Write a Page", "Escribir una p&aacute;gina"
  l.store "Write an Article", "Escribir un ar&iacute;culo"
  l.store "You are now logged out of the system", "Has salido del sistema"
  l.store "You can add it to the following categories", "Puedes a&ntilde;adirlo a las siguientes categor&iacute;as"
  l.store "You can enable site wide feedback moderation. If you do so, no comment or trackback will appear on your blog unless you validate it", "Puedes habilitar la moderaci&oacute;n de comentarios y trackbacks. Si lo haces, ning&uacute;n comentario o trackback aparecer&aacute; en tu blog hasta que lo hayas validado"
  l.store "You can optionally disable non-Ajax comments. Typo will always use Ajax for comment submission if Javascript is enabled, so non-Ajax comments are either from spammers or users without Javascript.", "Puedes deshabilitar los comentarios sin Ajax. Typo usar&aacute; siempre Ajax para a&ntilde;adir un comentario si Javascript est&aacute; habilitado, as&iacute; que los comentarios sin Ajax son de spammers o de usuarios sin Javascript."
  l.store "by", "por"
  l.store "on", "en"
  l.store "seperate with spaces", "separar con espacios"
  l.store "via email", "por email"
  l.store "with %s Famfamfam iconset %s", "con el iconset %s de Famfamfam %s"
  l.store "your blog", "tu blog"
end
