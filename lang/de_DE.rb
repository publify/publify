# coding: utf-8
Localization.define("de_DE") do |l|

  # app/controllers/accounts_controller.rb
  l.store "Login successful", ""
  l.store "Login unsuccessful", ""
  l.store "Oops, something wrong just happened", ""
  l.store "Successfully logged out", ""
  l.store "login", ""
  l.store "signup", ""

  # app/controllers/admin/categories_controller.rb
  l.store "Category was successfully saved.", ""
  l.store "Category could not be saved.", ""

  # app/controllers/admin/content_controller.rb
  l.store "Error, you are not allowed to perform this action", ""
  l.store "Preview", ""
  l.store "Article was successfully created", ""
  l.store "Article was successfully updated.", ""

  l.store "Deleted", ""
  l.store "Not found", ""
  l.store "Deleted %d item(s)", ""
  l.store "Marked %d item(s) as Ham", ""
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
  l.store "complete", ""
  l.store "File uploaded: ", ""
  l.store "Unable to upload", ""
  l.store "Metadata was successfully updated.", ""
  l.store "Not all metadata was defined correctly.", ""

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

  # app/controllers/admin/users_controller.rb
  l.store "User was successfully created.", ""

  # app/controllers/application_controller.rb
  l.store "Localization.rtl", ""

  # app/controllers/articles_controller.rb
  l.store "No posts found...", ""
  l.store "Archives for", ""
  l.store "Archives for ", ""
  l.store ", Articles for ", ""

  l.store "Delete", "Löschen"
  l.store "delete", ""
  l.store "Delete content", ""
  l.store "Are you sure?", ""
  l.store "All categories", "Alle kategorien"
  l.store "All authors", "Alle autoren"
  l.store "All published dates", "Alle termine"
  l.store "Edit", "Bearbeiten"
  l.store "Back to overview", "Zurück zur Übersicht"
  l.store "no trackbacks", "keine Trackbacks"
  l.store "Reorder", "Sortieren"
  l.store "Sort alphabetically", "Alphabetisch sortieren"

  l.store "Are you sure you want to delete the category ", "Sind Sie sicher, die Kategorie zu löschen: "
  l.store "Delete this category", "Kategorie löschen"

  l.store "(Done)", "(Fertig)"

  # app/views/admin/content/_attachment.html.erb
  l.store "Remove", "Löschen"
  l.store "Currently this article has the following resources", "Aktuell sind folgende Ressourcen dem Artikel zugeordnet"
  l.store "You can associate the following resources", "Sie können folgende Ressourcen zuordnen"
  l.store "Really delete attachment", "Anhang wirklich löschen"
  l.store "Add another attachment", "Einen weiteren Anhang hinzufügen"

  # app/views/admin/content/_form.html.erb
  l.store "Publish at", "Veröffentlicht am"

  # app/views/admin/content/destroy.html.erb
  l.store "Are you sure you want to delete this article", "Sind Sie sicher, diesen Artikel zu löschen"
  l.store "Delete this article", "Diesen Artikel löschen"


  # app/views/admin/dashboard/_posts.html.erb
  l.store "Latest Posts", ""

  # app/views/admin/dashboard/_publify_dev.html.erb
  l.store "Latest news from the Publify development blog", ""
  l.store "Oh no, nothing new", ""
  l.store "Limit to spam", "Einschränken auf Spam"
  l.store "Pages","Seiten"
  l.store "Are you sure you want to delete the page", "Sind Sie sicher, diese Seite zu löschen"
  l.store "Delete this page", "Diese Seite löschen"

  # app/views/admin/pages/index.html.erb
  l.store "Manage pages", ""

  # app/views/admin/profiles/index.html.erb
  l.store "Your profile", ""

  # app/views/admin/resources/_mime_edit.html.erb
  l.store "Content Type", "Content Type"

  # app/views/admin/resources/_pages.html.erb
  l.store "Previous page", "Vorherige Seite"
  l.store "Next page", "Nächste Seite"

  # app/views/admin/resources/_upload.html.erb
  l.store "Upload a File to your Site", "Legen Sie einen Dateianhang an ihrer Site an"
  l.store "File", ""
  l.store "Upload", "Upload"

  # app/views/admin/resources/destroy.html.erb
  l.store "Are you sure you want to delete this file", "Sind Sie sicher, diese Datei zu löschen"
  l.store "Delete this file from the webserver?", "Diese Datei vom Webserver löschen?"
  l.store "File Uploads", "Dateianhänge"

  l.store "Thumbnail", ""
  l.store "File Size", "Dateigröße"
  l.store "right-click for link", ""

  # app/views/admin/resources/index.html.erb
  l.store "Filename", "Dateiname"
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
  l.store "Enable comments by default", "Kommentare per default erlauben"
  l.store "Enable Trackbacks by default", "Trackbacks per default aktivieren"
  l.store "Enable feedback moderation", "Moderation von Kommentaren aktivieren"
  l.store "Comments filter", "Textfilter für Kommentar"
  l.store "Enable gravatars", "Gratavare aktivieren"
  l.store "Show your email address", "Ihre Email Adresse anzeigen"
  l.store "Notifications", ""
  l.store "Publify can notify you when new articles or comments are posted", "Publify kann Sie benachrichtigen, wenn neue Artikel oder Kommentare angelegt werden"
  l.store "Source Email", "Email Adresse"
  l.store "Email address used by Publify to send notifications", "Email Adresse, die Publify beim Versenden von Benachrichtigungen verwenden soll"
  l.store "Enabling spam protection will make Publify compare the IP address of posters as well as the contents of their posts against local and remote blacklists. Good defense against spam bots", "Bei Aktivierung des Spamschutzes wird Publify sowohl die IP Adresse des Autors als auch den Inhalt seiner Veröffentlichung gegen lokale und entfernte Blacklisten vergleichen. Gute Abwehr von Spambots"
  l.store "Enable spam protection", "Spamschutz aktivieren"
  l.store "Akismet Key", "Akismet Key"
  l.store "Publify can (optionally) use the %s spam-filtering service.  You need to register with Akismet and receive an API key before you can use their service.  If you have an Akismet key, enter it here", "Publify kann (optional) den %s Spam-Filterdienst verwenden. Sie müssen sich dort registriert und einen API Key erhalten haben, bevor Sie diesen Dienst nutzen können. Wenn Sie einen solchen Key haben, geben Sie ihn hier ein"
  l.store "Disable trackbacks site-wide", ""
  l.store "This setting allows you to disable trackbacks for every article in your blog.  It won't remove existing trackbacks, but it will prevent any further attempt to add a trackback anywhere on your blog.", "Diese Option erlaubt es Ihnen, Trackbacks für alle Artikel im gesamten Blog zu deaktivieren. Dadurch werden zwar keine bereits existierenden Trackbacks entfernt, aber alle zukünftig irgendwo in Ihrem Blog eintreffenden Trackbacks werden abgewiesen."
  l.store "Disable comments after", "Kommentare abschalten nach"
  l.store "days", "Tagen"
  l.store "Set to 0 to never disable comments", "Wert 0 bewirkt, dass die Möglichkeit für Kommentare immer bestehen bleibt"
  l.store "Max Links", "Maximale Anzahl Links"
  l.store "Publify will automatically reject comments and trackbacks which contain over a certain amount of links in them", "Publify kann automatisch Kommentare und Trackbacks abweisen, die mehr als eine bestimmte Anzahl von Links enthalten"
  l.store "Set to 0 to never reject comments", "Wert 0 bewirkt, dass Kommentare nie abgewiesen werden"

  # app/views/admin/settings/index.html.erb
  l.store "Your blog", "Mein Blog"
  l.store "Blog name", "Blog Titel"
  l.store "Blog subtitle", "Blog Untertitel"
  l.store "Blog URL", "Blog Adresse"
  l.store "Language", "Language" #Need translate
  l.store "Allow users to register", ""
  l.store "You can allow users to register to your blog. By default, they will register as contributors, an unpriviledged account level which grant them no rights but own a profile on the site. If you don't want users to register, you can thus add them by yourself in the users part of this admin.", ""
  l.store "Items to display in admin lists", ""
  l.store "Display", "Zeige"
  l.store "articles on my homepage by default", "Artikel auf einmal auf meiner Homepage"
  l.store "articles in my news feed by default", "Artikel auf einmal in meinen RSS News Feeds"
  l.store "Show full article on feed", "Ganzen Artikel im RSS News Feed anzeigen"
  l.store "Feedburner ID", ""
  l.store "General settings", "Allgemeine Einstellungen"
  l.store "You can use your Google Feedburner account instead of Publify feed URL. To enable this, fill this form with your Feedburner ID.", ""

  # app/views/admin/settings/seo.html.erb
  l.store "Google Analytics", ""
  l.store "Google verification link", ""
  l.store "Meta description", ""
  l.store "Meta keywords", ""
  l.store "Use RSS description", ""
  l.store "Robots.txt", ""
  l.store "This will display", ""
  l.store "at the bottom of each post in the RSS feed", ""
  l.store "Here you can add anything you want to appear in your application header, such as analytics service tracking code.", ""

  # app/views/admin/settings/update_database.html.erb
  l.store "Information", "Information"
  l.store "Current database version", "Aktuelle Datenbank Version"
  l.store "New database version", "Neue Datenbank Version"
  l.store "Your database supports migrations", "Ihre Datenbank unterstützt Migrationen"
  l.store "Needed migrations", "Migrationen sind notwendig"
  l.store "You are up to date!", "Sie sind auf dem aktuellsten Stand!"
  l.store "Update database now", "Update der Datenbank jetzt"
  l.store "may take a moment", "dauert einen Moment"
  l.store "Database migration", "Datenbank Migration"
  l.store "yes", "ja"
  l.store "no", "nein"

  l.store "Send trackbacks", "Trackbacks verschicken"
  l.store "When publishing articles, Publify can send trackbacks to websites that you link to. This should be disabled for private blogs as it will leak non-public information to sites that you're discussing. For public blogs, there's no real point in disabling this.", "Publify kann Trackbacks zu anderen Websites schicken, zu denen Sie in veröffentlichten Artikeln verlinken. Das sollte für private Blogs deaktiviert werden, weil sonst nicht-öffentliche Informationen mit dem Trackback Ping nach außen zu den Seiten gehen, die Sie in Ihren Artikeln diskutieren. Für öffentliche Blogs jedoch besteht kein wirklicher Grund, das zu deaktivieren."
  l.store "URLs to ping automatically", "Automatisch diese URLs anpingen"
  l.store "Latitude, Longitude", "geografische Breite, Länge"
  l.store "your latitude and longitude", "Ihrer geografischen Breite und Länge"
  l.store "example", "Beispiel"
  l.store "Write", "Schreiben"

  # app/views/admin/sidebar/_availables.html.erb
  l.store "You have no plugins installed", "Sie haben keine Plugins installiert"

  # app/views/admin/sidebar/_publish.html.erb
  l.store "Changes published", "Änderungen veröffentlicht"

  # app/views/admin/sidebar/_target.html.erb
  l.store "Drag some plugins here to fill your sidebar", "Ziehen Sie Plugins hierher, um sie in die Seitenleiste aufzunehmen"

  # app/views/admin/sidebar/index.html.erb
  l.store "Drag and drop to change the sidebar items displayed on this blog. To remove items from the sidebar just click 'remove'. Changes are saved immediately, but not activated until you click the 'Publish changes' button", "Verwenden Sie Drag&Drop, um die Einträge der Seitenleiste ihres Blogs zu ändern. Um Einträge zu löschen, klicken Sie auf 'remove'. Änderungen sind hier sofort sichtbar, werden aber erst permanent aktiviert, wenn Sie 'Änderungen veröffentlichen' klicken."
  l.store "Available Items", "Verfügbare Einträge"
  l.store "Active Sidebar items", "Aktive Einträge der Seitenleiste"
  l.store "Get more plugins", ""
  l.store "Sidebar", ""
  l.store "Publish changes", "Änderungen veröffentlichen"
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

  l.store "Display name", "Anzeigename"

  l.store "Are you sure you want to delete the tag", ""
  l.store "Delete this tag", ""

  l.store "Editing ", ""

  l.store "Display Name", ""

  # app/views/admin/themes/catalogue.html.erb
  l.store "Sorry the theme catalogue is not available", ""
  l.store "Theme catalogue", ""

  # app/views/admin/themes/index.html.erb
  l.store "Active theme", "Aktives Motiv"
  l.store "Choose a theme", "Motiv auswählen"
  l.store "Use this theme", ""

  # app/views/admin/users/_form.html.erb
  l.store "Account settings", ""
  l.store "Active", ""
  l.store "Inactive", ""
  l.store "Profile settings", ""
  l.store "Firstname", ""
  l.store "Nickname", ""
  l.store "Send notification messages via email", "Benachrichtigung via Email schicken"
  l.store "Send notification messages when new articles are posted", "Benachrichtigung schicken, wenn neue Artikel veröffentlicht werden"
  l.store "Send notification messages when comments are posted", "Benachrichtigung schicken, wenn neue Kommentare eintreffen"
  l.store "Contact options", ""
  l.store "Your site", ""
  l.store "Your MSN", ""
  l.store "Your Yahoo ID", ""
  l.store "Your Jabber ID", ""
  l.store "Your AIM id", ""
  l.store "Your Twitter username", ""
  l.store "Tell us more about you", ""

  # app/views/admin/users/destroy.html.erb
  l.store "Really delete user", "Benutzer wirklich löschen"
  l.store "Yes", ""
  l.store "Users", ""

  # app/views/admin/users/edit.html.erb
  l.store "Edit User", "Benutzer bearbeiten"

  # app/views/admin/users/index.html.erb
  l.store "Manage users", ""
  l.store "New User", "Neuer Benutzer"
  l.store "Comments", ""
  l.store "State", ""
  l.store "%s user", ""

  # app/views/admin/users/new.html.erb
  l.store "Add User", ""

  # app/views/articles/_article.html.erb
  l.store "Posted by", "Angelegt von"
  l.store "Continue reading", "Weiter lesen"

  # app/views/articles/_comment.html.erb
  l.store "said", "sagte"
  l.store "This comment has been flagged for moderator approval.  It won't appear on this blog until the author approves it", "Dieser Kommentar wurde für die Moderatorfreigabe markiert. Er wird erst nach Freigabe durch den Moderator in diesem Blog erscheinen"

  # app/views/articles/_comment_box.html.erb
  l.store "Your name", "Mein Name"
  l.store "Your email", "Meine Email"
  l.store "Your message", "Meine Nachricht"
  l.store "Comment Markup Help", "Hilfe zu Kommentar Markup"
  l.store "Preview comment", "Kommentar Vorschau"

  # app/views/articles/_comment_failed.html.erb
  l.store "Oops, something wrong happened, the comment could not be saved", ""

  # app/views/articles/_trackback.html.erb
  l.store "From", "Von"

  # app/views/articles/archives.html.erb
  l.store "No articles found", "Keine Artikel gefunden"
  l.store "posted in", ""

  # app/views/articles/comment_preview.html.erb
  l.store "is about to say", "will sagen"

  # app/views/articles/groupings.html.erb
  l.store "There are", "Es gibt"

  # app/views/articles/read.html.erb
  l.store "Leave a response", "Einen Kommentar hinterlassen"
  l.store "Trackbacks", ""
  l.store "Use the following link to trackback from your own site", "Verwenden Sie den folgenden Link zur Rückverlinkung von Ihrer eigenen Seite"
  l.store "RSS feed for this post", "RSS Feed für diesen Artikel"
  l.store "trackback uri", "Trackback URI"
  l.store "Comments are disabled", "Kommentare sind deaktiviert"
  l.store "Trackbacks are disabled", ""

  l.store "Trackbacks for", "Trackback für"

  l.store "Read all articles in %s", ""

  l.store "Previous", ""

  # vendor/plugins/archives_sidebar/views/content.rhtml
  l.store "Archives", "Archive"

  # vendor/plugins/authors_sidebar/views/content.rhtml
  l.store "Authors", ""

  # vendor/plugins/xml_sidebar/views/content.rhtml
  l.store "Syndicate", "Syndikat"
  l.store "Category %s", ""
  l.store "Tag %s", ""

  # Obsolete translations
  l.store "%d Articles", ["Artikel", "%d Artikel"]
  l.store "%d Categories", ["Kategorie", "%d Kategorien"]
  l.store "%d Comments", ["Kommentar", "%d Kommentare"]
  l.store "%d Tags", ["Tag", "%d Tags"]
  l.store "%d Trackbacks", ["Trackback", "%d Trackbacks"]
  l.store "%d Users", ["Benutzer", "%d Benutzer"]
  l.store "AIM Presence", "AIM Anwesenheit"
  l.store "Action", "Aktion"
  l.store "Activate", "Aktivieren"
  l.store "Add MetaData", "Metadaten hinzufügen"
  l.store "Add category", "Kategorie hinzufügen"
  l.store "Add new user", "Neuen Benutzer anlegen"
  l.store "Add pattern", "Muster hinzufügen"
  l.store "Allow non-ajax comments", "non-AJAX Kommentare erlauben"
  l.store "Are you sure you want to delete this filter", "Sind sie sicher, diesen Textfilter zu löschen"
  l.store "Are you sure you want to delete this item?", "Diesen Eintrag löschen, sind Sie sicher?"
  l.store "Article Attachments", "Artikel Anhänge"
  l.store "Article Body", "Artikel"
  l.store "Article Content", "Artikel Inhalt"
  l.store "Article Options", "Artikel Optionen"
  l.store "Articles in", "Artikel in"
  l.store "Attachments", "Anhänge"
  l.store "Back to the blog", "Zurück zum Blog"
  l.store "Blacklist", "Blacklist"
  l.store "Blacklist Patterns", "Blacklist Muster"
  l.store "Blog settings", "Blog Einstellungen"
  l.store "Body", "Text"
  l.store "Category title", "Name der Kategorie"
  l.store "Choose password", "Passwort"
  l.store "Comments and Trackbacks for", "Kommentare und Trackbacks für"
  l.store "Confirm password", "Passwort bestätigen"
  l.store "Copyright Information", "Copyright Informationen"
  l.store "Create new Blacklist", "Neue Blacklist anlegen"
  l.store "Create new category", "Neue Kategorie anlegen"
  l.store "Create new page", "Neue Seite anlegen"
  l.store "Create new text filter", "Neuen Textfilter anlegen"
  l.store "Creating comment", "Kommentar anlegen"
  l.store "Creating text filter", "Textfilter anlegen"
  l.store "Creating trackback", "Trackback anlegen"
  l.store "Creating user", "Benutzer anlegen"
  l.store "Currently this article is listed in following categories", "Aktuell ist dieser Artikel den folgenden Kategorien zugeordnet"
  l.store "Customize Sidebar", "Seitenleiste einstellen"
  l.store "Delete this filter", "Diesen Textfilter löschen"
  l.store "Design", "Design"
  l.store "Desired login", "Benutzername"
  l.store "Discuss", "Diskussion"
  l.store "Do you want to go to your blog?", "Möchten Sie zum Blog gehen?"
  l.store "Duration", "Dauer"
  l.store "Edit Article", "Artikel bearbeiten"
  l.store "Edit MetaData", "Metadaten bearbeiten"
  l.store "Edit this article", "Diesen Artikel bearbeiten"
  l.store "Edit this category", "Diese Kategorie bearbeiten"
  l.store "Edit this filter", "Filter bearbeiten"
  l.store "Edit this page", "Diese Seite bearbeiten"
  l.store "Edit this trackback", "Trackback bearbeiten"
  l.store "Editing User", "Aufbereitung des Benutzers"
  l.store "Editing category", "Kategorie bearbeiten"
  l.store "Editing comment", "Kommentar bearbeiten"
  l.store "Editing page", "Seite bearbeiten"
  l.store "Editing pattern", "Muster bearbeiten"
  l.store "Editing textfilter", "Textfilter bearbeiten"
  l.store "Editing trackback", "Trackback bearbeiten"
  l.store "Empty Fragment Cache", "Cache leeren"
  l.store "Explicit", "Explizit"
  l.store "Extended Content", "Erweiterter Inhalt"
  l.store "Feedback Search", "Suche"
  l.store "Filters", "Filter"
  l.store "General Settings", "Allgemeine Einstellungen"
  l.store "IP", "IP-Adresse"
  l.store "Jabber", "Jabber"
  l.store "Jabber account", "Jabber Account"
  l.store "Jabber account to use when sending Jabber notifications", "Jabber Account für das Senden von Jabber Benachrichtigungen"
  l.store "Jabber password", "Jabber Passwort"
  l.store "Key Words", "Schlagwörter"
  l.store "Last updated", "Zuletzt aktualisiert"
  l.store "Limit to unconfirmed", "Einschränken auf Unbestätigte"
  l.store "Limit to unconfirmed spam", "Einschränken auf unbestätigten Spam"
  l.store "Location", "Adresse"
  l.store "Logoff", "Logoff"
  l.store "Macro Filter Help", "Hilfe zu Makrofilter"
  l.store "Macros", "Makros"
  l.store "Manage", "Verwalten"
  l.store "Manage Categories", "Kategorien verwalten"
  l.store "Manage Pages", "Seiten verwalten"
  l.store "Manage Resources", "Ressourcen verwalten"
  l.store "Manage Text Filters", "Textfilter verwalten"
  l.store "Markup", "Markup"
  l.store "Markup type", "Markup Typ"
  l.store "MetaData", "Metadaten"
  l.store "Not published by Apple", "Nicht von Apple publiziert"
  l.store "Notification", "Benachrichtigung"
  l.store "Notified", "Benachrichtigt"
  l.store "Notify on new articles", "Benachrichtigung bei neuen Artikeln"
  l.store "Notify on new comments", "Benachrichtigung bei neuen Kommentaren"
  l.store "Notify via email", "Benachrichtigung via Email"
  l.store "Number of Articles", "Anzahl Artikel"
  l.store "Number of Comments", "Anzahl Kommentare"
  l.store "Offline", "Offline"
  l.store "Older posts", "Weitere Artikel"
  l.store "Optional Name", "Optionaler Name"
  l.store "Page Body", "Seiteninhalt"
  l.store "Page Options", "Seiten Optionen"
  l.store "Parameters", "Parameter"
  l.store "Password Confirmation", "Passwort bestätigen"
  l.store "Pattern", "Muster"
  l.store "Pictures from", "Bilder von"
  l.store "Post title", "Titel des Artikels"
  l.store "Post-processing filters", "Filter für Post-Processing"
  l.store "Posted at", "Veröffentlicht am"
  l.store "Posted date", "Angelegt am"
  l.store "Preview Article", "Artikel Vorschau "
  l.store "Read", "Lesen"
  l.store "Read more", "Mehr lesen"
  l.store "Rebuild cached HTML", "Im Cache gespeicherte HTML Seiten neu generieren"
  l.store "Recent comments", "Neueste Kommentare"
  l.store "Recent trackbacks", "Neueste Trackbacks"
  l.store "Regex", "Regulärer Ausdruck"
  l.store "Remove iTunes Metadata", "iTunes Metadaten entfernen"
  l.store "Resource MetaData", "Metadaten der Ressource"
  l.store "Resource Settings", "Einstellungen für Ressourcen"
  l.store "Save Settings", "Einstellungen speichern"
  l.store "See help text for this filter", "Hilfe für diesen Filter"
  l.store "Set iTunes metadata for this enclosure", "iTunes Metadaten für diesen Anhang festlegen"
  l.store "Setting for channel", "Kanaloptionen"
  l.store "Settings", "Einstellungen"
  l.store "Show Help", "Hilfe"
  l.store "Show this article", "Diesen Artikel anzeigen"
  l.store "Show this category", "Kategorie anzeigen"
  l.store "Show this comment", "Diesen Kommentar anzeigen"
  l.store "Show this page", "Diese Seite anzeigen"
  l.store "Show this pattern", "Muster anzeigen"
  l.store "Show this user", "Diesen Benutzer anzeigen"
  l.store "Spam Protection", "Spamschutz"
  l.store "Spam protection", "Spamschutz"
  l.store "String", "Zeichenkette"
  l.store "Subtitle", "Untertitel"
  l.store "Summary", "Zusammenfassung"
  l.store "Text Filter Details", "Details zum Textfilter"
  l.store "Text Filters", "Textfilter"
  l.store "Textfilter", "Textfilter"
  l.store "The below settings act as defaults when you choose to publish an enclosure with iTunes metadata", "Folgende Einstellungen wirken als Voreinstellungen, wenn Sie einen Anhang mit iTunes Metadaten veröffentlichen"
  l.store "Things you can do", "Folgendes können Sie tun ..."
  l.store "This option let you choose between the simple admin interface or the complete one, displaying much more options and therefore more complicated to use. For advanced users only!","This option let you choose between the simple admin interface or the complete one, displaying much more options and therefore more complicated to use. For advanced users only!" #Need translate
  l.store "Toggle Extended Content", "Erweiterten Inhalt umschalten"
  l.store "Type", "Typ"
  l.store "Publify admin", "Publify Administrator"
  l.store "Upload a new File", "Eine neue Datei hochladen"
  l.store "Upload a new Resource", "Eine neue Ressource hochladen"
  l.store "Uploaded", "Upload beendet"
  l.store "User's articles", "Artikel des Benutzers"
  l.store "View article on your blog", "Artikel in Ihrem Blog anschauen"
  l.store "View comment on your blog", "Kommentar in Ihrem Blog anschauen"
  l.store "View page on your blog", "Seite in Ihrem Blog anschauen"
  l.store "Which settings group would you like to edit", "Welche Einstellungsgruppe möchten Sie bearbeiten"
  l.store "Write an Article", "Einen Artikel schreiben"
  l.store "XML Syndication", "XML Syndikat"
  l.store "You are now logged out of the system", "Sie sind nun vom System abgemeldet"
  l.store "You can add it to the following categories", "Sie können ihn zu den folgenden Kategorien hinzufügen"
  l.store "You can enable site wide feedback moderation. If you do so, no comment or trackback will appear on your blog unless you validate it", "Sie können die Moderation von Kommentaren auf der gesamten Website aktivieren. Dann erscheinen keine Kommentare oder Trackbacks in Ihrem Blog, die sie nicht überprüft haben"
  l.store "You can optionally disable non-Ajax comments. Publify will always use Ajax for comment submission if Javascript is enabled, so non-Ajax comments are either from spammers or users without Javascript.", "Sie können optional non-Ajax Kommentare verbieten. Publify verwendet immer Ajax für die Übertragung von Kommentaren, sofern Javascript eingeschaltet ist. non-Ajax Kommentare stamme somit entweder von Spammern oder von Anwendern ohne aktiviertes Javascript."
  l.store "by", "bei"
  l.store "on", "über"
  l.store "seperate with spaces", "mit Leerzeichen trennen"
  l.store "via email", "per Email"
  l.store "with %s Famfamfam iconset %s", "mit %s Famfamfam Icons %s"
  l.store "your blog", "Ihr Blog"
end
