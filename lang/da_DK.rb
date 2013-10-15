# coding: utf-8
Localization.define("da_DK") do |l|

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
  l.store "Deleted", ""
  l.store "Not found", ""
  l.store "Deleted %d item(s)", ""
  l.store "Confirmed classification of %s item(s)", ""
  l.store "Not implemented", ""
  l.store "Delete", "Slet"
  l.store "delete", ""
  l.store "Delete content", ""
  l.store "Are you sure?", ""
  l.store "Please select", "Vælg venligst"
  l.store "All categories", "Alle kategorier"
  l.store "All authors", "Alle forfattere"
  l.store "All published dates", "Alle datoer"
  l.store "There are no %s yet. Why don't you start and create one?", ""
  l.store "Edit", "Rediger"
  l.store "Unpublished", "Ikke offentliggjort"
  l.store "Back to overview", "Tilbage til oversigten"
  l.store "Tag", "Tag"
  l.store "%%a, %%d %%b %%Y %%H:%%M:%%S GMT", ""
  l.store "%%d. %%b", ""
  l.store "no trackbacks", "ingen trackbacks"
  l.store "1 trackback", "1 trackback"
  l.store "%d trackbacks", "%d trackbacks"
  l.store "Posted in", "Offentliggjort i"
  l.store "If you are reading this article elsewhere than", ""
  l.store "it has been illegally reproduced and without proper authorization", ""

  # app/models/blog.rb
  l.store "Can't end in .rss or .atom. These are reserved to be used for feed URLs", ""
  l.store "Reorder", "Arranger"
  l.store "Sort alphabetically", "Sortér alfabetisk"

  l.store "Are you sure you want to delete the category ", "Er du sikker på du vil slette kategorien: "
  l.store "Delete this category", "Slet denne kategori"

  l.store "(Done)", "(Færdig)"

  # app/views/admin/content/_attachment.html.erb
  l.store "Remove", "Slet"
  l.store "Currently this article has the following resources", "Artiklen har følgende ressourcer"
  l.store "You can associate the following resources", "Du kan associere den med følgende ressourcer"
  l.store "Really delete attachment", "Vil du virkelig slette vedhæftet fil"
  l.store "Add another attachment", "Vedhæft en fil mere"

  l.store "Uploads", "Filer"
  l.store "Publish at", "Offentliggjort den"

  # app/views/admin/content/destroy.html.erb
  l.store "Are you sure you want to delete this article", "Er du sikker på du vil slette denne artikel"
  l.store "Delete this article", "Slet denne artikel"
  l.store "Articles", "Artikler"

  # app/views/admin/content/index.html.erb
  l.store "Search articles that contain ...", "Søg efter artikler der indeholder..."

  # app/views/admin/dashboard/_comments.html.erb
  l.store "Latest Comments", "Seneste kommentarer"
  l.store "By %s on %s", "Fra %s på %s"

  # app/views/admin/dashboard/_popular.html.erb
  l.store "For security reasons, you should restart your Publify application. Enjoy your blogging experience.", ""
  l.store "Most popular", "Mest populære"
  l.store "Nothing to show yet", "Intet at vise endnu"

  # app/views/admin/dashboard/_posts.html.erb
  l.store "Latest Posts", ""
  l.store "No posts yet, why don't you start and write one", "Der er ingen artikler endnu, du kan evt. starte med at skrive en"

  # app/views/admin/dashboard/_publify_dev.html.erb
  l.store "Oh no, nothing new", ""

  # app/views/admin/dashboard/_welcome.html.erb
  l.store "Welcome back, %s!", "Velkommen tilbage, %s!"
  l.store "Total posts : %d", "Total artikler : %d"
  l.store "Your posts : %d", "Dine artikler : %d"
  l.store "Total comments : %d", "Total kommentarer : %d"
  l.store "Spam comments : %d", "Spam kommentarer : %d"
  l.store "Pages", "Sider"
  l.store "Are you sure you want to delete the page", "Er du sikker på du vil slette denne side"
  l.store "Delete this page", "Slet denne side"

  # app/views/admin/pages/index.html.erb
  l.store "Manage pages", "Administrer sider"

  # app/views/admin/profiles/index.html.erb
  l.store "Your profile", "Din profil"

  # app/views/admin/resources/_mime_edit.html.erb
  l.store "Content Type", "Indholdstype (Content Type)"

  # app/views/admin/resources/_pages.html.erb
  l.store "Previous page", "Forrige side"
  l.store "Next page", "Næste side"

  # app/views/admin/resources/_upload.html.erb
  l.store "Upload a File to your Site", "Upload en fil til din side"
  l.store "File", ""
  l.store "Upload", "Upload"

  # app/views/admin/resources/destroy.html.erb
  l.store "Are you sure you want to delete this file", "Er du sikker på du vil slette denne fil"
  l.store "Delete this file from the webserver?", "Slet denne fil fra webserveren?"
  l.store "File Uploads", "Fil Uploads"

  l.store "Thumbnail", ""
  l.store "File Size", "Filstørrelse"
  l.store "right-click for link", "højreklik for link"

  # app/views/admin/resources/index.html.erb
  l.store "Filename", "Filnavn"
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
  l.store "Robots.txt", ""
  l.store "You robots.txt file is not writeable. Publify won't be able to write it", ""
  l.store "Use dofollow in comments", ""
  l.store "Read more about %s", ""
  l.store "Google", ""
  l.store "Google Analytics", ""
  l.store "Google Webmaster Tools validation link", ""
  l.store "Custom tracking code", ""
  l.store "Global settings", ""
  l.store "This will display", ""
  l.store "at the bottom of each post in the RSS feed", ""
  l.store "Here you can add anything you want to appear in your application header, such as analytics service tracking code.", ""
  l.store "Enable comments by default", "Aktiver kommentarer som standard"
  l.store "Enable Trackbacks by default", "Aktiver Trackbacks som standard"
  l.store "Enable feedback moderation", "Aktiver feedback moderation"
  l.store "Comments filter", "Kommentarfilter"
  l.store "Enable gravatars", "Vis gravatars"
  l.store "Show your email address", "Vis din e-mail addresse"
  l.store "Notifications", ""
  l.store "Publify can notify you when new articles or comments are posted", "Publify kan give dig besked, når nye artikler eller kommentarer er indsendt"
  l.store "Source Email", "Afsender e-mail"
  l.store "Email address used by Publify to send notifications", "E-mail adresse der bruges af Publify til at sende meddelelser"
  l.store "Enabling spam protection will make Publify compare the IP address of posters as well as the contents of their posts against local and remote blacklists. Good defense against spam bots", "Enabling spam protection will make publify compare the IP address of posters as well as the contents of their posts against local and remote blacklists. Good defense against spam bots" #Need translate
  l.store "Enable spam protection", "Aktiver spam beskyttelse"
  l.store "Akismet Key", "Akismet nøgle"
  l.store "Publify can (optionally) use the %s spam-filtering service.  You need to register with Akismet and receive an API key before you can use their service.  If you have an Akismet key, enter it here", "Publify can (optionally) use the %s spam-filtering service.  You need to register with Akismet and receive an API key before you can use their service.  If you have an Akismet key, enter it here" #Need translate
  l.store "Disable trackbacks site-wide", ""
  l.store "This setting allows you to disable trackbacks for every article in your blog.  It won't remove existing trackbacks, but it will prevent any further attempt to add a trackback anywhere on your blog.", "Denne indstilling giver dig mulighed for at deaktivere Trackbacks for hver artikel i din blog. Det vil ikke fjerne eksisterende Trackbacks, men det vil forhindre yderligere forsøg på at tilføje Trackbacks overalt på din blog."
  l.store "Disable comments after", "Deaktiver kommentarer efter"
  l.store "days", "dage"
  l.store "Set to 0 to never disable comments", "Sæt til 0 for at aldrig deaktivere kommentarer"
  l.store "Max Links", "Max Links"
  l.store "Publify will automatically reject comments and trackbacks which contain over a certain amount of links in them", "Publify will automatically reject comments and trackbacks which contain over a certain amount of links in them" #Need translate
  l.store "Set to 0 to never reject comments", "Sæt til 0 for at aldrig forkaste kommentarer"

  # app/views/admin/settings/index.html.erb
  l.store "Your blog", "Din Blog"
  l.store "Blog name", "Blog titel"
  l.store "Blog subtitle", "Blog undertitel"
  l.store "Blog URL", "Blogadresse"
  l.store "Language", "Sprog"
  l.store "You can allow users to register to your blog. By default, they will register as contributors, an unpriviledged account level which grant them no rights but own a profile on the site. If you don't want users to register, you can thus add them by yourself in the users part of this admin.", ""
  l.store "Items to display in admin lists", ""
  l.store "Publishing options", ""
  l.store "Display", "Vis"
  l.store "articles on my homepage by default", "artikler på min hjemmeside som standard"
  l.store "articles in my news feed by default", "artikler i min nyhedsfeed som standard"
  l.store "Show full article on feed", "Vis hele artiklen i min feed"
  l.store "Feedburner ID", ""
  l.store "General settings", "Generelle indstillinger"
  l.store "You can use your Google Feedburner account instead of Publify feed URL. To enable this, fill this form with your Feedburner ID.", ""

  # app/views/admin/settings/seo.html.erb
  l.store "Google Analytics", ""
  l.store "Google verification link", ""
  l.store "Meta description", ""
  l.store "Meta keywords", ""
  l.store "Use RSS description", ""
  l.store "Robots.txt", ""
  l.store "You robots.txt file is not writeable. Publify won't be able to write it", ""
  l.store "This will display", ""
  l.store "at the bottom of each post in the RSS feed", ""
  l.store "Here you can add anything you want to appear in your application header, such as analytics service tracking code.", ""

  # app/views/admin/settings/update_database.html.erb
  l.store "Information", "Information"
  l.store "Current database version", "Nuværende database version"
  l.store "New database version", "Ny database version"
  l.store "Your database supports migrations", "Din database understøtter migrations"
  l.store "Needed migrations", "Manglende migrations"
  l.store "You are up to date!", "Du er up to date!"
  l.store "Update database now", "Updatér database nu"
  l.store "may take a moment", "Det varer et øjeblik"
  l.store "Database migration", "Database migration"
  l.store "yes", "ja"
  l.store "no", "nej"

  # app/views/admin/settings/write.html.erb
  l.store "Send trackbacks", "Send trackbacks"
  l.store "When publishing articles, Publify can send trackbacks to websites that you link to. This should be disabled for private blogs as it will leak non-public information to sites that you're discussing. For public blogs, there's no real point in disabling this.", "Når du udgiver artikler kan Publify sende trackbacks til de hjemmesider du linker til. Dette bør slåes fra for private blogs da det ellers kan lække privat information til hjemmesider du diskuterer. For offentlige blogs, er der ingen reel mening i at deaktivere dette."
  l.store "URLs to ping automatically", "Webadresser der automatisk pinges"
  l.store "Latitude, Longitude", "Breddegrad, længdegrad"
  l.store "your latitude and longitude", "din breddegrad og længdegrad"
  l.store "example", "for eksempel"
  l.store "Write", "Skriv"

  # app/views/admin/sidebar/_availables.html.erb
  l.store "You have no plugins installed", "Du har ikke installeret nogen plugins"

  # app/views/admin/sidebar/_publish.html.erb
  l.store "Changes published", "Ændringer er udgivet"

  # app/views/admin/sidebar/_target.html.erb
  l.store "Drag some plugins here to fill your sidebar", "Træk plugins herover for at fylde din sidebar"

  # app/views/admin/sidebar/index.html.erb
  l.store "Drag and drop to change the sidebar items displayed on this blog. To remove items from the sidebar just click 'remove'. Changes are saved immediately, but not activated until you click the 'Publish changes' button", "Træk og slip for at ændre indholdsoversigten der vises på denne blog. Du kan fjerne elementer fra indholdsoversigten bare ved at klikke fjern. Ændringer gemmes med det samme, men ikke aktiveret, før du klikker på 'Offentliggør' knappen."
  l.store "Available Items", "Tilgængelige objekter"
  l.store "Active Sidebar items", "Aktive sidebar objekter"
  l.store "Get more plugins", ""
  l.store "Sidebar", ""
  l.store "Publish changes", "Udgiv ændringer"
  l.store "Displays links to monthly archives", ""
  l.store "Displays a list of authors ordered by name with links to their articles and profile", ""
  l.store "Livesearch", ""
  l.store "Adds livesearch to your Publify blog", ""
  l.store "This widget just displays links to Publify main site, this blog's admin and RSS.", ""
  l.store "Show pages for this blog", ""
  l.store "Adds basic search sidebar in your Publify blog", ""
  l.store "Static", ""
  l.store "Static content, like links to other sites, advertisements, or blog meta-information", ""
  l.store "RSS and Atom feeds", ""
  l.store "XML Syndication", ""
  l.store "remove", "supprimer"

  l.store "Display name", "Vis navn"

  l.store "Are you sure you want to delete the tag", ""
  l.store "Delete this tag", ""

  l.store "Editing ", ""

  l.store "Display Name", ""

  # app/views/admin/themes/catalogue.html.erb
  l.store "Sorry the theme catalogue is not available", ""
  l.store "Theme catalogue", ""

  # app/views/admin/themes/index.html.erb
  l.store "Active theme", "Aktiv tema"
  l.store "Choose a theme", "Vælg et tema"
  l.store "Use this theme", ""

  # app/views/admin/users/_form.html.erb
  l.store "Account settings", ""
  l.store "Password confirmation", "Gentag kodeord"
  l.store "Profile", "Profil"
  l.store "Active", ""
  l.store "Inactive", ""
  l.store "Profile settings", ""
  l.store "Firstname", "Fornavn"
  l.store "Lastname", "Efternavn"
  l.store "Nickname", "Kælenavn"
  l.store "Editor", ""
  l.store "Send notification messages via email", "Send meddelelser via e-mail"
  l.store "Send notification messages when new articles are posted", "Send meddelelser når ny artikler bliver udgivet"
  l.store "Send notification messages when comments are posted", "Send meddelelser når der er nye kommentarer"
  l.store "Contact options", "Kontakt information"
  l.store "Your site", "Din hjemmeside"
  l.store "display URL on public profile", "Vis hjemmeside på din profil"
  l.store "Your MSN", "Dit MSN ID"
  l.store "display MSN ID on public profile", "Vis dit MSN ID på din profil"
  l.store "Your Yahoo ID", "Dit Yahoo ID"
  l.store "display Yahoo! ID on public profile", "Vis dit Yahoo ID på din profil"
  l.store "Your Jabber ID", "Dit Jabber ID"
  l.store "display Jabber ID on public profile", "Vis dit Jabber ID på din profil"
  l.store "Your AIM id", "Dit AIM ID"
  l.store "display AIM ID on public profile", "Vis dit AIM ID på din profil"
  l.store "Your Twitter username", "Dit Twitter brugernavn"
  l.store "display Twitter on public profile", "Vis twitter på din profil"
  l.store "Tell us more about you", "Fortæl lidt mere om dig"

  # app/views/admin/users/destroy.html.erb
  l.store "Really delete user", "Vil du virkelig slette brugeren"
  l.store "Yes", ""
  l.store "Users", ""

  # app/views/admin/users/edit.html.erb
  l.store "Edit User", "Rediger bruger"

  # app/views/admin/users/index.html.erb
  l.store "New User", "Ny bruger"
  l.store "Comments", "Kommentarer"
  l.store "State", ""
  l.store "%s user", ""

  # app/views/admin/users/new.html.erb
  l.store "Add User", ""

  # app/views/articles/_article.html.erb
  l.store "Posted by", "Skrevet af"
  l.store "Continue reading", ""

  # app/views/articles/_comment.html.erb
  l.store "said", "sagde"
  l.store "This comment has been flagged for moderator approval.  It won't appear on this blog until the author approves it", "Denne kommentar er blevet markeret som krævende godkendelse. Den vil ikke blive vist før forfatteren godkender den."

  # app/views/articles/_comment_box.html.erb
  l.store "Your name", "Dit Navn"
  l.store "Your email", "Din email"
  l.store "Your message", "Din besked"
  l.store "Comment Markup Help", "Hjælp med kommentar markup"
  l.store "Preview comment", "Vis kommentar eksempel"
  # app/views/articles/_trackback.html.erb
  l.store "From", "Fra"

  # app/views/articles/archives.html.erb
  l.store "No articles found", "Fandt ingen artikler"
  l.store "posted in", ""

  # app/views/articles/comment_preview.html.erb
  l.store "is about to say", "vil gerne sige"

  # app/views/articles/groupings.html.erb
  l.store "There are", "Der er"

  # app/views/articles/read.html.erb
  l.store "Leave a response", "Skriv en kommentar"
  l.store "Trackbacks", ""
  l.store "Use the following link to trackback from your own site", "Brug følgende link til lave trackback fra din egen side"
  l.store "RSS feed for this post", "RSS Feed for denne artikel"
  l.store "trackback uri", "Trackback URI"
  l.store "Comments are disabled", "Kommentarer er deaktiveret"
  l.store "Trackbacks are disabled", ""

  l.store "later", "senere"

  # test/mocks/themes/typographic/views/articles/_comment_form.html.erb
  l.store "Leave a comment", "Skriv en kommentar"
  l.store "Name %s", "Navn %s"
  l.store "enabled", "aktiveret"
  l.store "never displayed", ""
  l.store "Website", ""
  l.store "Textile enabled", ""
  l.store "Markdown enabled", ""
  l.store "required", ""

  # test/mocks/themes/typographic/views/articles/_comment_list.html.erb
  l.store "No comments", ""

  # themes/dirtylicious/layouts/default.html.erb
  l.store "About", ""
  l.store "Designed by %s ported to publify by %s ", ""

  # themes/scribbish/layouts/default.html.erb
  l.store "styled with %s", ""

  # themes/scribbish/views/articles/_article.html.erb
  l.store "Meta", ""

  l.store "You are here: ", ""

  # themes/true-blue-3/views/articles/_article.html.erb
  l.store "%%a, %%d %%b %%Y %%H:%%M", ""

  # themes/true-blue-3/views/articles/_comment_form.html.erb
  l.store "Your website", ""

  # themes/true-blue-3/views/articles/read.html.erb
  l.store "If you liked this article you can %s", ""
  l.store "add me to Twitter", ""
  l.store "Trackbacks for", "Trackbacks for"

  l.store "Read all articles in %s", ""

  l.store "Previous", ""

  # vendor/plugins/archives_sidebar/views/content.rhtml
  l.store "Archives", "Arkiv"

  # vendor/plugins/authors_sidebar/views/content.rhtml
  l.store "Authors", ""

  # vendor/plugins/xml_sidebar/views/content.rhtml
  l.store "Syndicate", "Syndikat"
  l.store "Category %s", ""
  l.store "Tag %s", ""

  # Obsolete translations
  l.store "%d Categories", ["Kategori", "%d kategorier"]
  l.store "%d Comments", "%d Kommentarer"
  l.store "%d Users", ["Bruger", "%d Brugere"]
  l.store "AIM Presence", "AIM Presence"
  l.store "Action", "Aktion"
  l.store "Activate", "Aktiver"
  l.store "Add MetaData", "Tilføj MetaData"
  l.store "Add category", "Tilføj kategori"
  l.store "Add new user", "Tilføj ny user"
  l.store "Add pattern", "Tilføj mønster"
  l.store "Allow non-ajax comments", "Tillad ikke-ajax kommentarer"
  l.store "Are you sure you want to delete this filter", "Er du sikker på du vil slette dette filter"
  l.store "Are you sure you want to delete this item?", "Er du sikker på du vil slette dette mønster?"
  l.store "Article Attachments", "Artikel vedhæftninger"
  l.store "Article Body", "Artikel"
  l.store "Article Content", "Artikel indhold"
  l.store "Article Options", "Artikel egenskaber"
  l.store "Articles in", "Artikler i"
  l.store "Attachments", "Vedhæftet"
  l.store "Back to the blog", "Tilbage til Bloggen"
  l.store "Blacklist", "Blacklist"
  l.store "Blacklist Patterns", "Blacklist mønstre"
  l.store "Blog settings", "Blog indstillinger"
  l.store "Body", "Tekst"
  l.store "Category title", "Kategorititel"
  l.store "Choose password", "Kodeord"
  l.store "Comments and Trackbacks for", "Kommentarer og trackbacks for"
  l.store "Confirm password", "Gentag kodeord"
  l.store "Continue reading &raquo;", "L&aelig;s videre &raquo;"
  l.store "Copyright Information", "Copyright information"
  l.store "Create new Blacklist", "Opret ny blacklist"
  l.store "Create new category", "Opret ny kategori"
  l.store "Create new page", "Opret ny side"
  l.store "Create new text filter", "Opret nyt tekstfilter"
  l.store "Creating comment", "Opret kommentar"
  l.store "Creating text filter", "Oprettelse af tekstfilter"
  l.store "Creating trackback", "Opretter trackback"
  l.store "Creating user", "Opretter bruger"
  l.store "Currently this article is listed in following categories", "Artiklen er i følgende kategorier"
  l.store "Customize Sidebar", "Personliggør sidebar"
  l.store "Delete this filter", "Slet dette filter"
  l.store "Design", "Design"
  l.store "Desired login", "Ønsket brugernavn"
  l.store "Discuss", "Diskussion"
  l.store "Do you want to go to your blog?", "Vil du fortsætte til din blog?"
  l.store "Duration", "Varighed"
  l.store "Edit Article", "Rediger artikel"
  l.store "Edit MetaData", "Rediger MetaData"
  l.store "Edit this article", "Rediger denne artikkel"
  l.store "Edit this category", "Rediger denne kategori"
  l.store "Edit this filter", "Rediger dette filter"
  l.store "Edit this page", "Rediger denne side"
  l.store "Edit this trackback", "Rediger dette trackback"
  l.store "Editing User", "Redigerer bruger"
  l.store "Editing category", "Rediger kategori"
  l.store "Editing comment", "Rediger kommentar"
  l.store "Editing page", "Rediger side"
  l.store "Editing pattern", "Rediger mønster"
  l.store "Editing textfilter", "Redigerer tekstfilter"
  l.store "Editing trackback", "Redigerer trackback"
  l.store "Empty Fragment Cache", "Tøm Fragment Cache"
  l.store "Explicit", "Explicit"
  l.store "Extended Content", "Udvidet indhold"
  l.store "Feedback Search", "Søg i feedback"
  l.store "Filters", "Filtre"
  l.store "General Settings", "Generelle Indstillinger"
  l.store "IP", "IP-adresse"
  l.store "Jabber", "Jabber"
  l.store "Jabber account", "Jabber konto"
  l.store "Jabber account to use when sending Jabber notifications", "Jabber konto til når du sender Jabber beskeder"
  l.store "Jabber password", "Jabber kodeord"
  l.store "Key Words", "Key Words"
  l.store "Last updated", "Sidst opdateret den"
  l.store "Latest posts", "Seneste artikler"
  l.store "Limit to unconfirmed", "Indskrænk til ikke bekræftet"
  l.store "Limit to unconfirmed spam", "Indskrænk til ikke bekræftet Spam"
  l.store "Location", "Adresse"
  l.store "Logoff", "Log ud"
  l.store "Macros", "Makroer"
  l.store "Manage", "Administrer"
  l.store "Manage Categories", "Administrer kategorier"
  l.store "Manage Resources", "Administrer ressourcer"
  l.store "Manage Text Filters", "Administrer text filtre"
  l.store "Markup", "Markup"
  l.store "Markup type", "Markup type"
  l.store "MetaData", "MetaData"
  l.store "Name (required)", "Navn (skal udfyldes)"
  l.store "Not published by Apple", "Not published by Apple" #Need translate
  l.store "Notification", "Beskeder"
  l.store "Notified", "Besked sendt"
  l.store "Notify on new articles", "Send besked ved ny artikel"
  l.store "Notify on new comments", "Send besked ved ny kommentar"
  l.store "Notify via email", "Send besked via e-mail"
  l.store "Number of Articles", "Antal artikler"
  l.store "Number of Comments", "antal kommentarer"
  l.store "Offline", "Offline"
  l.store "Older posts", "Ældre artikler"
  l.store "Oops, something wrong happened. Have you filled out message and name?", "Hov der gik noget galt, har du udfyldt besked og dit navn?"
  l.store "Optional Name", "Optional Name" #Need translate
  l.store "Page", "Side"
  l.store "Page Body", "Sideindhold"
  l.store "Page Options", "Side instillinger"
  l.store "Parameters", "Parametre"
  l.store "Pattern", "Mønster"
  l.store "Personal information", "Personlig information"
  l.store "Pictures from", "Bileder fra"
  l.store "Post title", "Titel på artikel"
  l.store "Post-processing filters", "Efterbehandlingsfiltre"
  l.store "Posted date", "Udgivet den"
  l.store "Posted on", "Offentliggjort den"
  l.store "Posts", "Artikler"
  l.store "Preview Article", "Vis artikkel eksempel"
  l.store "Read", "Læs"
  l.store "Read more", "Læs mere"
  l.store "Rebuild cached HTML", "Genopbyg cached HTML"
  l.store "Recent comments", "Nyeste kommentarer"
  l.store "Recent trackbacks", "Nyeste trackbacks"
  l.store "Regex", "Regulært udtryk"
  l.store "Remove iTunes Metadata", "Slet iTunes metadata"
  l.store "Resource MetaData", "Ressource MetaData"
  l.store "Resource Settings", "Indstillinger for ressourcer"
  l.store "Save Settings", "Gem instillinger"
  l.store "Says", "Sagde"
  l.store "See help text for this filter", "Se hjælpeteksten til dette filter"
  l.store "Set iTunes metadata for this enclosure", "Sæt iTunes MetaData for denne fil"
  l.store "Setting for channel", "Instillinger for kanal"
  l.store "Settings", "Indstillinger"
  l.store "Show Help", "Vis hjælp"
  l.store "Show this article", "Vis denne artikel"
  l.store "Show this category", "Vis kategori"
  l.store "Show this comment", "Vis denne kommentar"
  l.store "Show this page", "Vis denne side"
  l.store "Show this pattern", "Vis mønster"
  l.store "Show this user", "Vis denne bruger"
  l.store "Spam Protection", "Spambeskyttelse"
  l.store "Spam protection", "Spam beskyttelse"
  l.store "Statistics", "Statistik"
  l.store "String", "Tekststreng"
  l.store "Subtitle", "Undertitel"
  l.store "Summary", "Resumé"
  l.store "System information", "System information"
  l.store "Text Filter Details", "Tekstfilter detaljer"
  l.store "Text Filters", "Tekst Filtre"
  l.store "Textfilter", "Textfilter"
  l.store "The below settings act as defaults when you choose to publish an enclosure with iTunes metadata", "The below settings act as defaults when you choose to publish an enclosure with iTunes metadata" #Need translate
  l.store "Things you can do", "Du kan udføre følgende ..."
  l.store "This option let you choose between the simple admin interface or the complete one, displaying much more options and therefore more complicated to use. For advanced users only!","This option let you choose between the simple admin interface or the complete one, displaying much more options and therefore more complicated to use. For advanced users only!" #Need translate
  l.store "Toggle Extended Content", "Slå udvidet indhold til/fra"
  l.store "Type", "Type"
  l.store "Publify admin", "Publify administrator"
  l.store "Upload a new File", "Upload en ny fil"
  l.store "Upload a new Resource", "Upload en ny ressource"
  l.store "Uploaded", "Uploaded"
  l.store "User's articles", "Brugerens artikler"
  l.store "View article on your blog", "Vis atikel på din blog"
  l.store "View comment on your blog", "Vis kommentar på din blog"
  l.store "View page on your blog", "Vis denne side på din blog"
  l.store "Which settings group would you like to edit", "Hvilke indstillinger vil du gerne redigere"
  l.store "Write a Page", "Skriv en side"
  l.store "Write an Article", "Skriv en artikkel"
  l.store "XML Syndication", "XML Syndikat"
  l.store "You are now logged out of the system", "Du er nu logget af systemet"
  l.store "You can add it to the following categories", "Du kan tilføje følgende kategorier"
  l.store "You can enable site wide feedback moderation. If you do so, no comment or trackback will appear on your blog unless you validate it", "Du kan slå feedback moderation til for hele bloggen. Hvis du gør dette kommer kommentarer og trackbacks først frem når du har godkendt dem"
  l.store "You can optionally disable non-Ajax comments. Publify will always use Ajax for comment submission if Javascript is enabled, so non-Ajax comments are either from spammers or users without Javascript.", "You can optionally disable non-Ajax comments. Publify will always use Ajax for comment submission if Javascript is enabled, so non-Ajax comments are either from spammers or users without Javascript." #Need translate
  l.store "add new", "tilføj ny"
  l.store "by", "af"
  l.store "on", "på"
  l.store "seperate with spaces", "Adskil med mellemrum"
  l.store "via email", "via e-mail"
  l.store "with %s Famfamfam iconset %s", "med %s Famfamfam ikoner %s"
end
