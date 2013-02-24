# coding: utf-8
Localization.define("ro_RO") do |l|

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
  l.store "Cancel", "Anulare"
  l.store "Store", ""
  l.store "Delete", "Ștergere"
  l.store "delete", ""
  l.store "Delete content", ""
  l.store "Are you sure?", ""
  l.store "Please select", ""
  l.store "All categories", "toate categoriile"
  l.store "All authors", "toate autorii"
  l.store "All published dates", "toate timp"
  l.store "There are no %s yet. Why don't you start and create one?", ""
  l.store "or", "sau"
  l.store "Save", "Salvează"
  l.store "Edit", "Editare"
  l.store "Show", ""
  l.store "Published", "Publicat"
  l.store "Unpublished", ""
  l.store "Show help on Typo macros", ""
  l.store "Back to overview", ""
  l.store "Name", "Nume"
  l.store "Description", "Descriere"
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
  l.store "no comments", "fără comentarii"
  l.store "1 comment", ""
  l.store "no trackbacks", "fără retrolegături"
  l.store "1 trackback", ""
  l.store "%d trackbacks", ""

  # app/helpers/content_helper.rb
  l.store "Posted in", ""
  l.store "Tags", ""
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
  l.store "Password", "Parola"
  l.store "Remember me", ""
  l.store "Submit", ""
  l.store "Back to ", ""

  # app/views/accounts/recover_password.html.erb
  l.store "Back to login", ""
  l.store "Username or email", ""

  # app/views/accounts/signup.html.erb
  l.store "Create an account", ""
  l.store "Username", "Utilizator"
  l.store "Email", "Email"
  l.store "Signup", "Înregistrare"

  # app/views/admin/categories/_categories.html.erb
  l.store "Title", "Titlu"
  l.store "Reorder", "Ordonează"
  l.store "Sort alphabetically", "Ordonează alfabetic"

  # app/views/admin/categories/_form.html.erb
  l.store "Keywords", ""

  # app/views/admin/categories/destroy.html.erb
  l.store "Are you sure you want to delete the category ", "Ești sigur că dorești să ștergi această categorie"
  l.store "Delete this category", "Șterge această categorie"
  l.store "Categories", ""

  # app/views/admin/categories/index.html.erb
  l.store "New Category", ""

  # app/views/admin/categories/new.html.erb
  l.store "%s Category", ""

  # app/views/admin/categories/reorder.html.erb
  l.store "(Done)", "(Gata)"

  # app/views/admin/content/_attachment.html.erb
  l.store "Remove", "Șterge"
  l.store "Currently this article has the following resources", "Resursele disponibile acestui articol sînt"
  l.store "You can associate the following resources", "Puteți asocia următoarele resurse"
  l.store "Really delete attachment", "Ești sigur că dorești să ștergi atașamentul"
  l.store "Add another attachment", "Adaugă un nou atașament"

  # app/views/admin/content/_drafts.html.erb
  l.store "Drafts", ""

  # app/views/admin/content/_form.html.erb
  l.store "Publish settings", ""
  l.store "Allow comments", "Se permit comentarii"
  l.store "Allow trackbacks", "Se permit retrolegături"
  l.store "Password:", ""
  l.store "Publish", "Publică"
  l.store "Tags", ""
  l.store "Separate tags with commas. Use double quotes (&quot;) around multi-word tags, e.g. &quot;opera house&quot;.", ""
  l.store "Excerpt", ""
  l.store "Excerpts are post summaries that show only on your blog homepage and won’t appear on the post itself", ""
  l.store "Uploads", ""
  l.store "Post settings", ""
  l.store "Publish at", "Publică la"
  l.store "Permalink", "Legătură permanentă"
  l.store "Article filter", "Filtru pentru articole"
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
  l.store "Are you sure you want to delete this article", "Ești sigur că dorești ștergerea acestui articol"
  l.store "Delete this article", "Șterge acest articol"
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
  l.store "Limit to spam", "Doar spam"

  # app/views/admin/feedback/_form.html.erb
  l.store "Add a comment", ""
  l.store "Url", "Adresa"

  # app/views/admin/feedback/_spam.html.erb
  l.store "This comment by <strong>%s</strong> was flagged as spam, %s?", ""

  # app/views/admin/feedback/article.html.erb
  l.store "Comments for %s", ""
  l.store "Status", "Status"
  l.store "Comment Author", ""
  l.store "Comment", ""

  # app/views/admin/feedback/edit.html.erb
  l.store "Comments for", "Comentariile la"

  # app/views/admin/feedback/index.html.erb
  l.store "Search Comments and Trackbacks that contain", ""
  l.store "Article", ""

  # app/views/admin/pages/_form.html.erb
  l.store "Online", "Online"
  l.store "Page settings", ""
  l.store "Permanent link", ""

  # app/views/admin/pages/destroy.html.erb
  l.store "Pages","Pagini"
  l.store "Are you sure you want to delete the page", "Ești sigur că dorești să ștergi această pagină"
  l.store "Delete this page", "Șterge această pagină"

  # app/views/admin/pages/index.html.erb
  l.store "New Page", ""
  l.store "Manage pages", ""

  # app/views/admin/profiles/index.html.erb
  l.store "Your profile", ""

  # app/views/admin/resources/_mime_edit.html.erb
  l.store "Content Type", "Tip de conținut (content type)"

  # app/views/admin/resources/_pages.html.erb
  l.store "Previous page", "Pagina anterioară"
  l.store "Next page", "Pagina următoare"

  # app/views/admin/resources/_upload.html.erb
  l.store "Upload a File to your Site", "Încarcă un fișier în site"
  l.store "File", ""
  l.store "Upload", "Încarcă"

  # app/views/admin/resources/destroy.html.erb
  l.store "Are you sure you want to delete this file", "Ești sigur că dorești să ștergi acest fișier"
  l.store "Delete this file from the webserver?", "Ștergi acest fișier de pe server?"
  l.store "File Uploads", "Încărcări de fișiere"

  # app/views/admin/resources/images.html.erb
  l.store "Thumbnail", ""
  l.store "File Size", "Dimensiunea fișierului"
  l.store "Images", ""
  l.store "right-click for link", ""

  # app/views/admin/resources/index.html.erb
  l.store "Filename", "Nume de fișier"
  l.store "Browse", ""
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
  l.store "Enable comments by default", "Implicit comentariile să fie active"
  l.store "Enable Trackbacks by default", "Implicit retrolegăturile să fie active"
  l.store "Enable feedback moderation", "Activează moderarea comentariilor"
  l.store "You can enable site wide feedback moderation. If you do so, no comment or trackback will appear on your blog unless you validate it.", ""
  l.store "Comments filter", "Filtru pentru comentarii"
  l.store "Enable gravatars", "Activează gravataruri"
  l.store "Show your email address", "Arată adresa ta de email"
  l.store "Notifications", ""
  l.store "Typo can notify you when new articles or comments are posted", "Typo te poate alerta la publicarea de noi articole sau comentarii"
  l.store "Source Email", "Expeditor email"
  l.store "Email address used by Typo to send notifications", "Adresa email folosită de Typo pentru a trimite alerte prin email"
  l.store "Enabling spam protection will make Typo compare the IP address of posters as well as the contents of their posts against local and remote blacklists. Good defense against spam bots", "La activarea protecției anti-spam, Typo va compara adresa IP a utilizatorului care publică un articol, cît și conținutul articolului publicat, cu niște liste negre locale sau din altă parte. Reprezintă o bună apărare împotriva unui spam bot "
  l.store "Enable spam protection", "Activează protecția anti-spam"
  l.store "Akismet Key", "Cheia Akismet"
  l.store "Typo can (optionally) use the %s spam-filtering service.  You need to register with Akismet and receive an API key before you can use their service.  If you have an Akismet key, enter it here", "Opțional, Typo poate folosi serviciul %s de filtrare spam. Trebuie să te înregistrezi la Akismet și să primești o cheie API pentru a putea folosi acest serviciu. Dacă ai deja o cheie Akismet, introdu-o aici"
  l.store "Disable trackbacks site-wide", ""
  l.store "This setting allows you to disable trackbacks for every article in your blog.  It won't remove existing trackbacks, but it will prevent any further attempt to add a trackback anywhere on your blog.", "Această opțiune va dezactiva trimiterea de retrolegături de acum înainte. Retrolegăturile existente vor rămîne în site-uri, dar alte retrolegături nu vor mai fi posibile nicăieri in blog."
  l.store "Disable comments after", "Dezactivează comentariile după "
  l.store "days", "zile"
  l.store "Set to 0 to never disable comments", "Comentariile nu vor fi dezactivate niciodată dacă alegi valoarea 0"
  l.store "Max Links", "Număr maxim de legături"
  l.store "Typo will automatically reject comments and trackbacks which contain over a certain amount of links in them", "Typo va respinge automat comentarii și retrolegături care conțin mai mult decît un anumit număr de legături"
  l.store "Set to 0 to never reject comments", "Comentariile nu vor fi respinse niciodată dacă alegi valoarea 0"
  l.store "Feedback settings", ""

  # app/views/admin/settings/index.html.erb
  l.store "Your blog", "Site"
  l.store "Blog name", "Numele blogului"
  l.store "Blog subtitle", "Subtitlul blogului"
  l.store "Blog URL", "Adresa blogului"
  l.store "Language", "Language" #Need translate
  l.store "Allow users to register", ""
  l.store "You can allow users to register to your blog. By default, they will register as contributors, an unpriviledged account level which grant them no rights but own a profile on the site. If you don't want users to register, you can thus add them by yourself in the users part of this admin.", ""
  l.store "Items to display in admin lists", ""
  l.store "Publishing options", ""
  l.store "Display", "Afișează"
  l.store "articles on my homepage by default", "articole implicit în pagina principală"
  l.store "articles in my news feed by default", "articole implicit în RSS"
  l.store "Show full article on feed", "Include articole complete în RSS"
  l.store "Feedburner ID", ""
  l.store "General settings", "Setări generale"
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
  l.store "Information", "Informații"
  l.store "Current database version", "Versiunea curentă a bazei de date"
  l.store "New database version", "Versiunea nouă a bazei de date"
  l.store "Your database supports migrations", "Baza de date poate fi actualizată"
  l.store "Needed migrations", "Actualizări necesare"
  l.store "You are up to date!", "Baza de date este la zi!"
  l.store "Update database now", "Actualizează baza de date acum"
  l.store "may take a moment", "ar putea să dureze puțin"
  l.store "Database migration", "Actualizări ale bazei de date"
  l.store "yes", "da"
  l.store "no", "nu"

  # app/views/admin/settings/write.html.erb
  l.store "Send trackbacks", "Trimite retrolegături"
  l.store "When publishing articles, Typo can send trackbacks to websites that you link to. This should be disabled for private blogs as it will leak non-public information to sites that you're discussing. For public blogs, there's no real point in disabling this.", "Cînd publici un articol, Typo poate trimite automat retrolegături site-urilor pe care le specifici. În cazul unui blog personal, această opțiune ar trebui dezactivată, ca să nu deconspire informații private. Dacă blogul e public, opțiunea aceasta poate rămîne activă."
  l.store "URLs to ping automatically", "Site-uri de anunțat automat"
  l.store "Latitude, Longitude", "Latitudine, longitudine"
  l.store "your latitude and longitude", "latitudinea și longitudinea ta"
  l.store "example", "de pildă"
  l.store "Write", "Publicare"

  # app/views/admin/sidebar/_availables.html.erb
  l.store "You have no plugins installed", "Niciun plugin instalat"

  # app/views/admin/sidebar/_publish.html.erb
  l.store "Changes published", "Schimbările au fost publicate"

  # app/views/admin/sidebar/_target.html.erb
  l.store "Drag some plugins here to fill your sidebar", "Trage plugin-uri aici pentru a popula bara laterală"

  # app/views/admin/sidebar/index.html.erb
  l.store "Drag and drop to change the sidebar items displayed on this blog. To remove items from the sidebar just click 'remove'. Changes are saved immediately, but not activated until you click the 'Publish changes' button", "Trage și lasă obiecte pe bara laterală pentru a o modifica în blog. Pentru a șterge obiecte din bara laterală, apasă pe 'șterge'. Modificările se salvează imediat, dar nu vor fi activate pînă cînd apeși butonul 'publică'"
  l.store "Available Items", "Obiecte disponibile"
  l.store "Active Sidebar items", "Obiecte utilizate"
  l.store "Get more plugins", ""
  l.store "Sidebar", ""
  l.store "Publish changes", "Publică modificările"

  # app/views/admin/tags/_form.html.erb
  l.store "Display name", "Numele real"

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
  l.store "Active theme", "Tema activă"
  l.store "Choose a theme", "Alege o temă"
  l.store "Use this theme", ""

  # app/views/admin/users/_form.html.erb
  l.store "Account settings", ""
  l.store "Password confirmation", "Confirmă parola"
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
  l.store "Send notification messages via email", "Alerte prin email"
  l.store "Send notification messages when new articles are posted", "Alerte la publicarea de articole noi"
  l.store "Send notification messages when comments are posted", "Alerte la publicarea de comentarii noi"
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
  l.store "Really delete user", "Ești sigur că dorești să ștergi acest utilizator"
  l.store "Yes", ""
  l.store "Users", ""

  # app/views/admin/users/edit.html.erb
  l.store "Edit User", "Editează un utilizator"

  # app/views/admin/users/index.html.erb
  l.store "New User", "Utilizator nou"
  l.store "Comments", ""
  l.store "State", ""
  l.store "%s user", ""
  l.store "Manage users", ""

  # app/views/admin/users/new.html.erb
  l.store "Add User", ""

  # app/views/articles/_article.html.erb
  l.store "Posted by", "Publicat de"
  l.store "Continue reading", ""

  # app/views/articles/_comment.html.erb
  l.store "said", "a scris"
  l.store "This comment has been flagged for moderator approval.  It won't appear on this blog until the author approves it", "Acest comentariu a fost marcat pentru moderare. El nu va apărea în blog înainte de a fi aprobat."

  # app/views/articles/_comment_box.html.erb
  l.store "Your name", "Nume"
  l.store "Your email", "Email"
  l.store "Your message", "Comentariu"
  l.store "Comment Markup Help", "Ajutor la marcare"
  l.store "Preview comment", "Previzualizare"
  l.store "leave url/email", ""

  # app/views/articles/_comment_failed.html.erb
  l.store "Oops, something wrong happened, the comment could not be saved", ""

  # app/views/articles/_trackback.html.erb
  l.store "From", "De la"

  # app/views/articles/archives.html.erb
  l.store "No articles found", "Niciun articol nu a fost găsit"
  l.store "posted in", ""

  # app/views/articles/comment_preview.html.erb
  l.store "is about to say", "vrea să scrie"

  # app/views/articles/groupings.html.erb
  l.store "There are", "Sînt"

  # app/views/articles/read.html.erb
  l.store "Leave a response", "Comentează"
  l.store "Trackbacks", ""
  l.store "Use the following link to trackback from your own site", "Folosește link-ul următor pentru a realiza o retrolegătură de la site-ul tău"
  l.store "RSS feed for this post", "Flux RSS pentru acest articol"
  l.store "trackback uri", "URL pentru retrolegătură"
  l.store "Comments are disabled", "Comentariile sînt dezactivate"
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
  l.store "Logged in as %s", ""
  l.store "%s &raquo;", ""
  l.store "Help", "Ajutor"
  l.store "Documentation", "Documentație"
  l.store "Report a bug", "Raport de eroare"
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
  l.store "Trackbacks for", "Retrolegături pentru"

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
  l.store "%d Articles", ["Articol", "%d Articole"]
  l.store "%d Categories", ["Categorie", "%d Categorii"]
  l.store "%d Comments", ["Comentariu", "%d Comentarii"]
  l.store "%d Tags", ["Cuvînt cheie", "%d Cuvinte cheie"]
  l.store "%d Trackbacks", ["Retrolegătură", "%d Retrolegături"]
  l.store "%d Users", ["Utilizator", "%d Utilizatori"]
  l.store "Action", "Acțiuni"
  l.store "Activate", "Activează"
  l.store "Add MetaData", "Adaugă metainformații"
  l.store "Add category", "Adaugă o categorie"
  l.store "Add new user", "Adaugă un utilizator nou"
  l.store "Add pattern", "Adăugare model"
  l.store "Allow non-ajax comments", "Permite comentarii non-AJAX"
  l.store "Are you sure you want to delete this filter", "Ești sigur că dorești să ștergi acest filtru"
  l.store "Are you sure you want to delete this item?", "Ești sigur că dorești să ștergi acest element?"
  l.store "Article Attachments", "Atașamentele articolului"
  l.store "Article Body", "Corpul articolului"
  l.store "Article Content", "Conținutul articolului"
  l.store "Article Options", "Opțiunile articolului"
  l.store "Articles in", "Articole în"
  l.store "Attachments", "Atașamente"
  l.store "Back to the blog", "Înapoi la blog"
  l.store "Blacklist", "Lista neagră"
  l.store "Blacklist Patterns", "Lista neagră"
  l.store "Blog settings", "Setările blogului"
  l.store "Body", "Conținut"
  l.store "Cache", "Cache"
  l.store "Category title", "Numele categoriei"
  l.store "Choose password", "Parola"
  l.store "Comments and Trackbacks for", "Comentarii și retrolegături pentru"
  l.store "Confirm password", "Confirmați parola"
  l.store "Copyright Information", "Drepturi"
  l.store "Create new Blacklist", "Crearea unei noi liste negre"
  l.store "Create new category", "Creează o categorie nouă"
  l.store "Create new page", "Creează o pagină nouă"
  l.store "Create new text filter", "Creează un nou filtru de text"
  l.store "Creating comment", "Creează un comentariu"
  l.store "Creating text filter", "Crearea unui nou filtru de text"
  l.store "Creating trackback", "Crearea unei retrolegături"
  l.store "Creating user", "Crearea unui nou utilizator"
  l.store "Currently this article is listed in following categories", "Acest articol aparține următoarelor categorii"
  l.store "Customize Sidebar", "Personalizează bara laterală"
  l.store "Delete this filter", "Șterge acest filtru"
  l.store "Design", "Design"
  l.store "Desired login", "Nume de utilizator"
  l.store "Discuss", "Discuții"
  l.store "Do you want to go to your blog?", "Doriți să vizitați pagina principală a blogului?"
  l.store "Duration", "Durată"
  l.store "Edit Article", "Editarea unui articol"
  l.store "Edit MetaData", "Editează metainformații"
  l.store "Edit this article", "Editează acest articol"
  l.store "Edit this category", "Editează această categorie"
  l.store "Edit this filter", "Editeaza acest filtru"
  l.store "Edit this page", "Editează această pagină"
  l.store "Edit this trackback", "Editează această retrolegătură"
  l.store "Editing User", "Editarea unui utilizator"
  l.store "Editing category", "Editarea categoriei"
  l.store "Editing comment", "Editarea unui comentariu"
  l.store "Editing page", "Editarea paginii"
  l.store "Editing pattern", "Editarea modelului"
  l.store "Editing textfilter", "Editarea unui filtru"
  l.store "Editing trackback", "Editarea retrolegăturii"
  l.store "Empty Fragment Cache", "Golește cache"
  l.store "Explicit", "Conținut explicit"
  l.store "Extended Content", "Conținutul extins"
  l.store "Feedback Search", "Caută prin comentarii"
  l.store "Filters", "Filtre"
  l.store "General Settings", "Setări generale"
  l.store "IP", "Adresa IP"
  l.store "Jabber", "Jabber"
  l.store "Jabber account", "Cont Jabber"
  l.store "Jabber account to use when sending Jabber notifications", "Contul de Jabber folosit pentru a trimite alerte prin Jabber"
  l.store "Jabber password", "Parola Jabber"
  l.store "Key Words", "Cuvinte cheie"
  l.store "Last updated", "Ultima modificare"
  l.store "Limit to unconfirmed", "Doar neconfirmate"
  l.store "Limit to unconfirmed spam", "Doar spam neconfirmat"
  l.store "Location", "Adresa"
  l.store "Logoff", "Ieșire"
  l.store "Macro Filter Help", "Ajutor la filtrele macro"
  l.store "Macros", "Macro-uri"
  l.store "Manage", "Articole"
  l.store "Manage Articles", "Listează articolele"
  l.store "Manage Categories", "Listează categoriile"
  l.store "Manage Pages", "Listează paginile"
  l.store "Manage Resources", "Listează resursele"
  l.store "Manage Text Filters", "Configurează filtrele de text"
  l.store "Markup", "Marcaj"
  l.store "Markup type", "Tip de marcaj"
  l.store "MetaData", "Metainformații"
  l.store "Not published by Apple", "Nepublicat de Apple"
  l.store "Notification", "Notificări"
  l.store "Notified", "Alertă trimisă"
  l.store "Notify on new articles", "Primește alerte la publicarea de articole noi"
  l.store "Notify on new comments", "Primește alerte la publicarea de comentarii noi"
  l.store "Notify via email", "Primește alerte prin email"
  l.store "Number of Articles", "Număr de articole"
  l.store "Number of Comments", "Număr de comentarii"
  l.store "Offline", "Offline"
  l.store "Older posts", "Articole mai vechi"
  l.store "Optional Name", "Nume opțional"
  l.store "Page Body", "Conținutul paginii"
  l.store "Page Options", "Opțiuni ale paginii"
  l.store "Parameters", "Parametri"
  l.store "Password Confirmation", "Confirmă parola"
  l.store "Pattern", "Model"
  l.store "Pictures from", "Imagini de la"
  l.store "Post title", "Titlul articolului"
  l.store "Post-processing filters", "Filtre de post-procesare"
  l.store "Posted at", "Data publicării"
  l.store "Posted date", "Publicat la"
  l.store "Preview Article", "Previzualizarea unui articol"
  l.store "Read", "Afișare"
  l.store "Read more", "Citește mai departe"
  l.store "Rebuild cached HTML", "Reconstruiește paginile din cache"
  l.store "Recent comments", "Comentarii recente"
  l.store "Recent trackbacks", "Retrolegături recente"
  l.store "Regex", "Expresie regulată"
  l.store "Remove iTunes Metadata", "Șterge metainformațiile iTunes"
  l.store "Resource MetaData", "Metainformații ale resursei"
  l.store "Resource Settings", "Setări ale resurselor"
  l.store "Save Settings", "Salvează setările"
  l.store "See help text for this filter", "Ajutor la acest filtru"
  l.store "Set iTunes metadata for this enclosure", "Setează metainformații iTunes"
  l.store "Setting for channel", "Setări de canal"
  l.store "Settings", "Configurare"
  l.store "Show Help", "Ajutor"
  l.store "Show this article", "Arată acest articol"
  l.store "Show this category", "Afișează această categorie"
  l.store "Show this comment", "Arată acest comentariu"
  l.store "Show this page", "Arată această pagină"
  l.store "Show this pattern", "Afișează acest model"
  l.store "Show this user", "Arată acest utilizator"
  l.store "Spam Protection", "Protecție anti-spam"
  l.store "Spam protection", "Protecție anti-spam"
  l.store "String", "Șir de caractere"
  l.store "Subtitle", "Subtitlu"
  l.store "Summary", "Rezumat"
  l.store "Text Filter Details", "Detaliile filtrului de text"
  l.store "Text Filters", "Filtre de text"
  l.store "Textfilter", "Filtru de text"
  l.store "The below settings act as defaults when you choose to publish an enclosure with iTunes metadata", "Setările de mai jos vor reprezenta valorile implicite atunci cînd vei publica un enclosure cu metainformații pentru iTunes"
  l.store "Things you can do", "Acțiuni"
  l.store "This option let you choose between the simple admin interface or the complete one, displaying much more options and therefore more complicated to use. For advanced users only!","This option let you choose between the simple admin interface or the complete one, displaying much more options and therefore more complicated to use. For advanced users only!" #Need translate
  l.store "Type", "Tip"
  l.store "Typo admin", "Administrare Typo"
  l.store "Upload a new File", "Încarcă un fișier nou"
  l.store "Upload a new Resource", "Încarcă o nouă resursă"
  l.store "Uploaded", "Încărcat la"
  l.store "User's articles", "Articole publicate de acest utilizator"
  l.store "View article on your blog", "Arată acest articol in blog"
  l.store "View comment on your blog", "Arată acest comentariu în blog"
  l.store "View page on your blog", "Arată această pagină în blog"
  l.store "Which settings group would you like to edit", "Ce grup de setări dorești să modifici"
  l.store "Write a Page", "Compune o pagină"
  l.store "Write an Article", "Scrie un articol"
  l.store "You are now logged out of the system", "Ați ieșit din aplicație"
  l.store "You can add it to the following categories", "Îl puteți adăuga următoarelor categorii"
  l.store "You can enable site wide feedback moderation. If you do so, no comment or trackback will appear on your blog unless you validate it", ""
  l.store "You can optionally disable non-Ajax comments. Typo will always use Ajax for comment submission if Javascript is enabled, so non-Ajax comments are either from spammers or users without Javascript.", "Opțional, puteți dezactiva comentariile non-AJAX. Typo va folosi întotdeauna AJAX pentru trimiterea comentariilor dacă funcționează Javascript la utilizator, astfel că orice comentariu care nu vine prin AJAX trebuie să vină fie de la spammeri, fie de la vizitatori fără Javascript."
  l.store "by", "de"
  l.store "on", "la"
  l.store "seperate with spaces", "separate de spațiu"
  l.store "via email", "prin email"
  l.store "with %s Famfamfam iconset %s", "cu %s pictograme Famfamfam %s"
  l.store "your blog", "blog-ul tău"
end
