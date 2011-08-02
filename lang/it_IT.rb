# coding: utf-8
Localization.define("it_IT") do |l|

  # app/controllers/accounts_controller.rb
  l.store "Login successful", ""
  l.store "Login unsuccessful", ""
  l.store "An email has been successfully sent to your address with your new password", ""
  l.store "Oops, something wrong just happened", ""
  l.store "Successfully logged out", "Sei correttamente uscito"
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
  l.store "Confirmed classification of %s item(s)", "Conferma classificazione di %s elementi"
  l.store "Not implemented", "Non implementato"
  l.store "All spam have been deleted", ""
  l.store "Comment was successfully created.", ""
  l.store "Comment was successfully updated.", ""

  # app/controllers/admin/pages_controller.rb
  l.store "Page was successfully created.", ""
  l.store "Page was successfully updated.", ""

  # app/controllers/admin/profiles_controller.rb
  l.store "User was successfully updated.", ""

  # app/controllers/admin/resources_controller.rb
  l.store "Error occurred while updating Content Type.", "Si e' verificato un errore mentre aggiornavo il tipo di contenuto."
  l.store "complete", "completato"
  l.store "File uploaded: ", "File inviata: "
  l.store "Unable to upload", "Impossibile inviare"
  l.store "Metadata was successfully updated.", "I metadata sono stati correttamente aggiornati."
  l.store "Not all metadata was defined correctly.", "Non tutti i metadata sono stati definiti correttamente."
  l.store "Content Type was successfully updated.", "Il tipo di contenuto e' stato correttamente aggiornato."

  # app/controllers/admin/settings_controller.rb
  l.store "Please review and save the settings before continuing", ""
  l.store "config updated.", "Configurazione aggiornata."

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
  l.store "Cancel", "Annulla"
  l.store "Store", "Salva"
  l.store "Delete", "Elimina"
  l.store "delete", ""
  l.store "Delete content", ""
  l.store "Are you sure?", ""
  l.store "Please select", ""
  l.store "There are no %s yet. Why don't you start and create one?", ""
  l.store "or", "o"
  l.store "Save", "Salva"
  l.store "Edit", "Modifica"
  l.store "Show", ""
  l.store "Published", "Pubblicato"
  l.store "Unpublished", ""
  l.store "Show help on Typo macros", ""
  l.store "Back to overview", "Torna al sommario"
  l.store "Name", "Nome"
  l.store "Description", "Descrizione"
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
  l.store "no comments", "nessun commento"
  l.store "1 comment", ""
  l.store "no trackbacks", "nessun trackback"
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
  l.store "I've lost my password", ""
  l.store "Login", "Login"
  l.store "Password", "Password"
  l.store "Remember me", ""
  l.store "Submit", ""
  l.store "Back to ", "Torna al "

  # app/views/accounts/recover_password.html.erb
  l.store "Username or email", ""

  # app/views/accounts/signup.html.erb
  l.store "Create an account", ""
  l.store "Username", "Nome Utente"
  l.store "Email", "Email"
  l.store "Signup", "Iscrizione"

  # app/views/admin/categories/_categories.html.erb
  l.store "Title", "Titolo"
  l.store "Reorder", "Riordina"
  l.store "Sort alphabetically", "Ordina alfabeticamente"

  # app/views/admin/categories/_form.html.erb
  l.store "Keywords", ""

  # app/views/admin/categories/destroy.html.erb
  l.store "Are you sure you want to delete the category ", "Sei sicuro di voler eliminare questa categoria "
  l.store "Delete this category", "Elimina questa categoria"
  l.store "Categories", ""

  # app/views/admin/categories/index.html.erb
  l.store "New Category", ""

  # app/views/admin/categories/new.html.erb
  l.store "%s Category", ""

  # app/views/admin/categories/reorder.html.erb
  l.store "(Done)", "(Termina)"

  # app/views/admin/content/_attachment.html.erb
  l.store "Remove", "Elimina"
  l.store "Currently this article has the following resources", "Questo articolo ha le seguenti risorse"
  l.store "You can associate the following resources", "Puoi associare le seguenti risorse"
  l.store "Really delete attachment", "Vuoi realmente eliminare l'allegato"
  l.store "Add Another Attachment", "Aggiungi un'altro allegato"

  # app/views/admin/content/_drafts.html.erb
  l.store "Drafts", ""

  # app/views/admin/content/_form.html.erb
  l.store "Publish settings", ""
  l.store "Allow comments", "Permetti commenti"
  l.store "Allow trackbacks", "Permetti trackbacks"
  l.store "Password:", ""
  l.store "Publish", "Pubblica"
  l.store "Excerpt", ""
  l.store "Excerpts are posts summaries that are shown on your blog homepage only but won’t appear on the post itself", ""
  l.store "Uploads", "Uploads"
  l.store "Post settings", ""
  l.store "Publish at", "Pubblicato il"
  l.store "Permalink", "Permalink"
  l.store "Article filter", "Filtra articolo"
  l.store "Save as draft", ""

  # app/views/admin/content/destroy.html.erb
  l.store "Are you sure you want to delete this article", "Sei sicuro di voler eliminare questo articolo"
  l.store "Delete this article", "Elimina articolo"
  l.store "Articles", ""

  # app/views/admin/content/index.html.erb
  l.store "New Article", ""
  l.store "Search articles that contain ...", ""
  l.store "Search", "Cerca"
  l.store "Author", "Autore"
  l.store "Date", ""
  l.store "Feedback", "Commenti"
  l.store "Filter", ""
  l.store "Manage articles", ""

  # app/views/admin/dashboard/_comments.html.erb
  l.store "Latest Comments", ""
  l.store "No comments yet", "Nessun commento"
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
  l.store "Most popular", "I più popolari"
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
  l.store "Delete Checked Items", "Elimina gli elementi selezionati"
  l.store "Delete all spam", ""
  l.store "Mark Checked Items as Spam", "Segna come spam"
  l.store "Mark Checked Items as Ham", "Segna come confermati"
  l.store "All comments", ""
  l.store "Limit to ham", ""
  l.store "Unapproved comments", ""
  l.store "Limit to spam", "Limita a spam"

  # app/views/admin/feedback/_form.html.erb
  l.store "Add a comment", ""
  l.store "Url", "Sito"

  # app/views/admin/feedback/_spam.html.erb
  l.store "This comment by <strong>%s</strong> was flagged as spam, %s?", ""

  # app/views/admin/feedback/article.html.erb
  l.store "Comments for %s", ""
  l.store "Status", "Stato"
  l.store "Comment Author", ""
  l.store "Comment", ""

  # app/views/admin/feedback/edit.html.erb
  l.store "Comments for", "Commenti per"

  # app/views/admin/feedback/index.html.erb
  l.store "Search Comments and Trackbacks that contain", "Cerca commenti o trackback che contengono"
  l.store "Article", ""

  # app/views/admin/pages/_form.html.erb
  l.store "Online", "Online"
  l.store "Page settings", ""
  l.store "Permanent link", ""

  # app/views/admin/pages/destroy.html.erb
  l.store "Pages","Pagine"
  l.store "Are you sure you want to delete the page", "Sei sicuro di voler eliminare questa pagina"
  l.store "Delete this page", "Elimina questa pagina"

  # app/views/admin/pages/index.html.erb
  l.store "New Page", ""
  l.store "Manage pages", ""

  # app/views/admin/profiles/index.html.erb
  l.store "Your profile", ""

  # app/views/admin/resources/_mime_edit.html.erb
  l.store "Content Type", "Tipo di contenuto"

  # app/views/admin/resources/_pages.html.erb
  l.store "Previous page", "Pagina precedente"
  l.store "Next page", "Pagina successiva"

  # app/views/admin/resources/_upload.html.erb
  l.store "Upload a File to your Site", "Invia un file al tuo sito"
  l.store "File", "File"
  l.store "Upload", "Invia"

  # app/views/admin/resources/destroy.html.erb
  l.store "Are you sure you want to delete this file", "Sei sicuro di voler eliminare questo file"
  l.store "Delete this file from the webserver?", "Eliminare questo file dal webserver ?"
  l.store "File Uploads", "Invia file"

  # app/views/admin/resources/images.html.erb
  l.store "Thumbnail", ""
  l.store "File Size", "Dimensione"
  l.store "Images", ""
  l.store "right-click for link", "clicca col destro per il link"

  # app/views/admin/resources/index.html.erb
  l.store "Filename", "Nome del file"

  # app/views/admin/settings/_submit.html.erb
  l.store "Update settings", ""

  # app/views/admin/settings/feedback.html.erb
  l.store "Enable comments by default", "Abilita commenti di defaault"
  l.store "Enable Trackbacks by default", "Abilita Trackbacks come default"
  l.store "Enable feedback moderation", "Abilita la moderazione dei feedback"
  l.store "You can enable site wide feeback moderation. If you do so, no comment or trackback will appear on your blog unless you validate it", "Puoi abilitare in modo globale la moderazione dei feedback. Se fai cio', nessun commento o trackback apparira' sul tuo blog se tu non lo autorizzi."
  l.store "Comments filter", "Filtra commenti"
  l.store "Enable gravatars", "Abilita gravatars"
  l.store "Show your email address", "Mostra il tuo indirizzo mail"
  l.store "Notifications", ""
  l.store "Typo can notify you when new articles or comments are posted", "Il blog puo' notificarti l'inserimento di un nuovo articolo e/o commento"
  l.store "Source Email", "Indirizzo mittente mail"
  l.store "Email address used by Typo to send notifications", "Indirizzo email usato dal blog per inviare le notifiche"
  l.store "Enabling spam protection will make typo compare the IP address of posters as well as the contents of their posts against local and remote blacklists. Good defense against spam bots", "Abilitando la protezione contro lo spam fa si che il blog compari gli IP di chi invia i commenti e anche il loro contenuto con una blacklist remota. E' una buona difesa contro gli spam robot"
  l.store "Enable spam protection", "Abilita la protezione spam"
  l.store "Akismet Key", "Chiave Akismet"
  l.store "Typo can (optionally) use the %s spam-filtering service.  You need to register with Akismet and receive an API key before you can use their service.  If you have an Akismet key, enter it here", ""
  l.store "Disable trackbacks site-wide", ""
  l.store "This setting allows you to disable trackbacks for every article in your blog.  It won't remove existing trackbacks, but it will prevent any further attempt to add a trackback anywhere on your blog.", ""
  l.store "Disable comments after", "Disabilita commenti dopo "
  l.store "days", "giorni"
  l.store "Set to 0 to never disable comments", "Usa 0 per non disabilitare mai i commenti"
  l.store "Max Links", "Max Links"
  l.store "Typo will automatically reject comments and trackbacks which contain over a certain amount of links in them", "Il blog cancellera' automaticamente commenti e trackbacks che contengono un certo numero di link"
  l.store "Set to 0 to never reject comments", "Inserisci 0 per accettare sempre i commenti."
  l.store "Feedback settings", ""

  # app/views/admin/settings/index.html.erb
  l.store "Your blog", "Tuo blog "
  l.store "Blog name", "Nome blog"
  l.store "Blog subtitle", "Sottotitolo del blog"
  l.store "Blog URL", "Indirizzo Blog"
  l.store "Language", "Lingua"
  l.store "Allow users to register", ""
  l.store "You can allow users to register to your blog. By default, they will register as contributors, an unpriviledged account level which grant them no rights but own a profile on the site. If you don't want users to register, you can thus add them by yourself in the users part of this admin.", ""
  l.store "Items to display in admin lists", ""
  l.store "Publishing options", ""
  l.store "Display", "Mostra"
  l.store "articles on my homepage by default", "articoli nella homepage"
  l.store "articles in my news feed by default", "articoli nei miei rss feed"
  l.store "Show full article on feed", "Visualizza articolo completo su feed"
  l.store "Feedburner ID", ""
  l.store "General settings", "Configurazione generale"
  l.store "You can use your Google Feedburner account instead of Typo feed URL. To enable this, fill this form with your Feedburner ID.", ""

  # app/views/admin/settings/seo.html.erb
  l.store "Search Engine Optimisation", "Ottimizzazione motori di ricerca"
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
  l.store "at the bottom of each of your post in the RSS feed", ""

  # app/views/admin/settings/update_database.html.erb
  l.store "Information", "Informazioni"
  l.store "Current database version", "Versione corrente del database"
  l.store "New database version", "Nuova versione del database"
  l.store "Your database supports migrations", "Il tuo database supporta le migrazioni"
  l.store "Needed migrations", "Necessarie migrazioni"
  l.store "You are up to date!", "Aggiornato!"
  l.store "Update database now", "Aggiorna il tuo database ora"
  l.store "may take a moment", "attendi alcuni istanti"
  l.store "Database migration", "Migrazione del database"
  l.store "yes", "si"
  l.store "no", "no"

  # app/views/admin/settings/write.html.erb
  l.store "Send trackbacks", "Invia trackbacks"
  l.store "When publishing articles, Typo can send trackbacks to websites that you link to. This should be disabled for private blogs as it will leak non-public information to sites that you're discussing. For public blogs, there's no real point in disabling this.", "Quando pubblichi gli articoli, e' possibile inviare trackback ai siti di cui fornisci l'url. E' possibile disabilitare questa funzione nel caso di blog privato di cui non si vogliono condividere le informazioni. Per blog pubblici non esiste una necessita' reale di disabilitare questa funzione."
  l.store "URLs to ping automatically", "Indirizzi da pingare automaticamente"
  l.store "Latitude, Longitude", "Latitudine, Longitudine"
  l.store "your lattitude and longitude", "la tua latitudine e longitudine"
  l.store "exemple", "esempio"
  l.store "Write", "Scrivi"

  # app/views/admin/sidebar/_availables.html.erb
  l.store "You have no plugins installed", "Non hai plugins installati"

  # app/views/admin/sidebar/_publish.html.erb
  l.store "Changes published", "Modifiche pubblicate"

  # app/views/admin/sidebar/_target.html.erb
  l.store "Drag some plugins here to fill your sidebar", "Trascina alcuni plugins qui per popolare la tua sidebar"

  # app/views/admin/sidebar/index.html.erb
  l.store "Drag and drop to change the sidebar items displayed on this blog.  To remove items from the sidebar just click remove  Changes are saved immediately, but not activated until you click the 'Publish' button", "Trascina e rilascia per cambiare gli elementi visualizzati nella sidebar del tuo blog. Per rimuorverli clicca su annulla Cambiamenti perche' comunque non sono salvati automaticamente ma devi cliccare il bottone 'Pubblica'"
  l.store "Available Items", "Elementi disponibili"
  l.store "Active Sidebar items", "Attiva elementi Sidebar"
  l.store "Get more plugins", ""
  l.store "Sidebar", ""
  l.store "Publish changes", "Pubblica cambiamenti"

  # app/views/admin/tags/_form.html.erb
  l.store "Display name", "Nome visualizzato"

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
  l.store "Theme editor", "Editor dei temi"

  # app/views/admin/themes/index.html.erb
  l.store "Active theme", "Tema Attivo"
  l.store "Get more themes", ""
  l.store "You can download third party themes from officially supported %s ", ""
  l.store "Typogarden", ""
  l.store "To install a theme you  just need to upload the theme folder into your themes directory. Once a theme is uploaded, you should see it on this page.", ""
  l.store "Choose a theme", "Seleziona un tema"

  # app/views/admin/users/_form.html.erb
  l.store "Account settings", ""
  l.store "Password confirmation", ""
  l.store "Profile", "Profilo"
  l.store "User's status", ""
  l.store "Active", ""
  l.store "Inactive", ""
  l.store "Profile Settings", ""
  l.store "Firstname", ""
  l.store "Lastname", ""
  l.store "Nickname", ""
  l.store "Editor", ""
  l.store "Use simple editor", ""
  l.store "Use visual rich editor", ""
  l.store "Send notification messages via email", "Invia notifiche via mail"
  l.store "Send notification messages when new articles are posted", "Invia notifiche quando viene pubblicato un nuovo articolo"
  l.store "Send notification messages when comments are posted", "Invia notifiche quando viene inserito un nuovo commento"
  l.store "Contact Options", ""
  l.store "Your site", ""
  l.store "display url on public profile", ""
  l.store "Your MSN", ""
  l.store "display MSN ID on public profile", ""
  l.store "Your Yahoo ID", ""
  l.store "display Yahoo! ID on public profile", ""
  l.store "Your Jabber ID", ""
  l.store "display Jabber ID on public profile", ""
  l.store "Your AIM id", ""
  l.store "display AIM ID on public profile", ""
  l.store "Your Twitter username", ""
  l.store "display twitter on public profile", ""
  l.store "Tell us more about you", ""

  # app/views/admin/users/destroy.html.erb
  l.store "Really delete user", "Veramente eliminare questo utente"
  l.store "Yes", ""
  l.store "Users", ""

  # app/views/admin/users/edit.html.erb
  l.store "Edit User", "Modifica utente"

  # app/views/admin/users/index.html.erb
  l.store "New User", "Nuovo utente"
  l.store "Comments", ""
  l.store "State", ""
  l.store "%s user", ""

  # app/views/admin/users/new.html.erb
  l.store "Add User", "Aggiungi Utente"

  # app/views/articles/_article.html.erb
  l.store "Posted by", "Scritto da"
  l.store "Continue reading", ""

  # app/views/articles/_comment.html.erb
  l.store "said", "dice"
  l.store "This comment has been flagged for moderator approval.  It won't appear on this blog until the author approves it", ""

  # app/views/articles/_comment_box.html.erb
  l.store "Your name", "Tuo nome "
  l.store "Your email", "Tua email"
  l.store "Your message", "Tuo messaggio"
  l.store "Comment Markup Help", "Aiuto sul markup dei comemnti"
  l.store "Preview comment", "Anteprima commento"
  l.store "leave url/email", ""

  # app/views/articles/_comment_failed.html.erb
  l.store "Oops, something wrong happened, the comment could not be saved", ""

  # app/views/articles/_trackback.html.erb
  l.store "From", "Da"

  # app/views/articles/archives.html.erb
  l.store "No articles found", "Nessun articolo trovato"
  l.store "posted in", ""

  # app/views/articles/comment_preview.html.erb
  l.store "is about to say", "sta per dire"

  # app/views/articles/groupings.html.erb
  l.store "There are", "Ci sono"

  # app/views/articles/read.html.erb
  l.store "Leave a response", "Commenta"
  l.store "Trackbacks", ""
  l.store "Use the following link to trackback from your own site", "Usa il link seguente per fare un trackback dal tuo sito"
  l.store "RSS feed for this post", "Feed RSS per questo post"
  l.store "trackback uri", "trackback urk"
  l.store "Comments are disabled", "Commenti disabilitati"

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
  l.store "%s &raquo;", ""
  l.store "is proudly powered by", ""
  l.store "Dashboard", ""

  # app/views/setup/index.html.erb
  l.store "Welcome", ""
  l.store "Welcome to your %s blog setup. Just fill in your blog title and your email, and Typo will take care of everything else", ""

  # app/views/shared/_confirm.html.erb
  l.store "Congratulation!", ""
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
  l.store "Read full article", "Leggi articolo completo"
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
  l.store "Trackbacks for", "Trackbacks per"

  # themes/true-blue-3/views/articles/search.html.erb
  l.store "Search results for:", ""

  # themes/true-blue-3/views/categories/index.html.erb
  l.store "Read all articles in %s", ""

  # themes/true-blue-3/views/categories/show.html.erb
  l.store "Previous", ""
  l.store "Next", ""

  # vendor/plugins/archives_sidebar/views/content.rhtml
  l.store "Archives", "Archivi"

  # vendor/plugins/authors_sidebar/views/content.rhtml
  l.store "Authors", ""

  # vendor/plugins/xml_sidebar/views/content.rhtml
  l.store "Syndicate", "Syndicate"
  l.store "Category %s", ""
  l.store "Tag %s", ""

  # Obsolete translations
  l.store "%d Articles", ["Categoria", "%d Categorie"]
  l.store "%d Categories", ["Categoria", "%d Categorie"]
  l.store "%d Comments", ["Commento", "%d Commenti"]
  l.store "%d Tags", ["Tag", "%d Tags"]
  l.store "%d Trackbacks", ["Trackback", "%d Trackbacks"]
  l.store "%d Users", ["Utente", "%d Utenti"]
  l.store "A new message was posted to ", "Un nuovo messaggio inserito in "
  l.store "AIM Presence", "Presenza AIM"
  l.store "AIM Status", "Stato AIM"
  l.store "Action", "Azioni"
  l.store "Activate", "Attiva"
  l.store "Add MetaData", "Aggiungi MetaData"
  l.store "Add category", "Aggiungi categoria"
  l.store "Add new user", "Aggiungi nuovo utente"
  l.store "Add pattern", "Aggiungi modello"
  l.store "Advanced settings", "Configurazione avanzata"
  l.store "Allow non-ajax comments", "Abilita commenti non Ajax"
  l.store "Are you sure you want to delete this filter", "Sei sicuro di voler eliminare questo filtro"
  l.store "Are you sure you want to delete this item?", "Sei sicuro di voler eliminare questo elemento?"
  l.store "Article Attachments", "Allegati articolo"
  l.store "Article Body", "Contenuto articolo"
  l.store "Article Content", "Contenuto Articolo"
  l.store "Article Options", "Opzioni articolo"
  l.store "Articles in", "Articoli in"
  l.store "Attachments", "Allegati"
  l.store "Basic settings", "Configurazione base"
  l.store "Blacklist", "Blacklist"
  l.store "Blacklist Patterns", "Lista nera"
  l.store "Blog advanced settings", "Settaggi avanzati del blog"
  l.store "Blog settings", "Configurazione blog"
  l.store "Body", "Messaggio"
  l.store "Cache", "Cache"
  l.store "Cache was cleared", "Cache pulita"
  l.store "Category", "Catégorie"
  l.store "Category could not be created.", "La categoria non puo' essere creata"
  l.store "Category title", "Nome della categoria"
  l.store "Category was successfully created.", "Categoria correttamente creata"
  l.store "Category was successfully updated.", "Categoria correttamente aggiornata"
  l.store "Change you blog presentation", "Cambiare l'aspetto del tuo blog"
  l.store "Choose password", "Password"
  l.store "Choose theme", "Scegli un tema"
  l.store "Comment Excerpt", "Contenuto commento"
  l.store "Comments and Trackbacks for", "Commenti e trackbacks per"
  l.store "Confirm Classification of Checked Items", "Conferma classificazione degli elementi selezionati"
  l.store "Confirm password", "Conferma password"
  l.store "Copyright Information", "Informazioni sul Copyright"
  l.store "Create new Blacklist", "Aggiungi nuova lista nera"
  l.store "Create new category", "Crea una nuova categoria"
  l.store "Create new page", "Crea una nuova pagina"
  l.store "Create new text filter", "Crea un nuovo filtro testo"
  l.store "Creating comment", "Creazione commento"
  l.store "Creating text filter", "Crea un nuovo filtro testo"
  l.store "Creating trackback", "Creaa trackback"
  l.store "Currently this article is listed in following categories", "Questo articolo e' presente nelle seguenti categorie"
  l.store "Customize Sidebar", "Personalizza la Sidebar"
  l.store "Delete this filter", "Elimina questo filtro"
  l.store "Deleted %s item(s)", "Eliminati %s elementi"
  l.store "Design", "Temi"
  l.store "Desired login", "Nome utente"
  l.store "Discuss", "Discussione"
  l.store "Do you want to go to your blog?", "Vuoi andare al tuo blog?"
  l.store "Duration", "Durata"
  l.store "Edit Article", "Modifica articolo"
  l.store "Edit MetaData", "Modifica MetaData"
  l.store "Edit this article", "Modifica questo articolo"
  l.store "Edit this category", "Modifica questa categoria"
  l.store "Edit this filter", "Modifica questo filtro"
  l.store "Edit this page", "Modifica questa pagina"
  l.store "Edit this trackback", "Modifica questo trackback"
  l.store "Editing User", "Modifica utente"
  l.store "Editing category", "Modifica categoria"
  l.store "Editing comment", "Modifica commento"
  l.store "Editing page", "Modifica pagina"
  l.store "Editing pattern", "Modifica modello"
  l.store "Editing textfilter", "Modifica filtro testo"
  l.store "Editing trackback", "Modifica trackback"
  l.store "Empty Fragment Cache", "Svuota la cache"
  l.store "Enable plugins", "Aggiungere plugins"
  l.store "Explicit", "Contenuto esplicito"
  l.store "Extended Content", "Contenuto esteso"
  l.store "Feedback Search", "Ricerca feedback"
  l.store "Filters", "Filtri"
  l.store "General Settings", "Configurazione generale"
  l.store "HTML was cleared", "l'HTML cancellato"
  l.store "IP", "IP"
  l.store "Jabber", "Jabber"
  l.store "Jabber account", "Account Jabber"
  l.store "Key Words", "Parole chiave"
  l.store "Last Comments", "Ultimi commenti"
  l.store "Last posts", "Ultimi articoli"
  l.store "Last updated", "Ultimo aggiornamento"
  l.store "Limit to unconfirmed", "Limita a non confermati"
  l.store "Limit to unconfirmed spam", "Limita a spam non confermato"
  l.store "Location", "Link permanente"
  l.store "Logoff", "Esci"
  l.store "Macro Filter Help", "Aiuto filtro macro"
  l.store "Macros", "Macros"
  l.store "Manage", "Gestisci"
  l.store "Manage Articles", "Gestisci gli articoli"
  l.store "Manage Categories", "Gestisci categorie"
  l.store "Manage Pages", "Gestisci le pagine"
  l.store "Manage Resources", "Gestici le risorse"
  l.store "Manage Text Filters", "Gestisci i filtri del testo"
  l.store "Markup", "Markup"
  l.store "Markup type", "Tipo di markup"
  l.store "MetaData", "MetaData"
  l.store "Metadata was successfully removed.", "I metadata sono stati correttamente rimossi."
  l.store "New post", "Nuovo post"
  l.store "Not published by Apple", "Non pubblicato da Apple"
  l.store "Notification", "Notifice"
  l.store "Notified", "Notificato"
  l.store "Notify on new articles", "Notifiche di nuovi articoli"
  l.store "Notify on new comments", "Notifiche di nuovi commenti"
  l.store "Notify via email", "Notifiche via mail"
  l.store "Number of Articles", "Numero di articoli"
  l.store "Number of Comments", "Numero di commenti"
  l.store "Offline", "Offline"
  l.store "Older posts", "Articoli precedenti"
  l.store "Optional Extended Content", "Contenuto Esteso Opzionale"
  l.store "Optional Name", "Nome opzionale"
  l.store "Optional extended content", "Contenuto esteso opzionale"
  l.store "Options", "Opzioni"
  l.store "Page Body", "Contenuto della pagina"
  l.store "Page Content", "Contenuto della pagina"
  l.store "Page Options", "Opzioni pagina"
  l.store "Parameters", "Parametri"
  l.store "Password Confirmation", "Conferma password"
  l.store "Pattern", "Modello"
  l.store "Pictures from", "Immagine da"
  l.store "Post", "Contenuto"
  l.store "Post title", "Titolo articolo"
  l.store "Post-processing filters", "Filtri di dopo il produzione"
  l.store "Posted at", "Data pubblicazione"
  l.store "Posted date", "Data di inserimento"
  l.store "Posts", "Articoli"
  l.store "Preview Article", "Anteprima articolo"
  l.store "Read", "Mostra"
  l.store "Read more", "Continua"
  l.store "Rebuild cached HTML", "Ricostruisci l'html in cache"
  l.store "Recent comments", "Commenti recenti"
  l.store "Recent trackbacks", "Trackbacks recenti"
  l.store "Regex", "Espressione regolare"
  l.store "Remove iTunes Metadata", "Rimuovi i metadata iTunes"
  l.store "Resource MetaData", "Risorse metadata"
  l.store "Resource Settings", "Configurazione risorse"
  l.store "Save Settings", "Salva configurazione"
  l.store "See help text for this filter", "Visualizza aiuto per questo filtro"
  l.store "Set iTunes metadata for this enclosure", "Setta i metadata iTunes per questa risorsa"
  l.store "Setting for channel", "Configurazione per il canale"
  l.store "Settings", "Configurazione"
  l.store "Show Help", "Mostra l'aiuto"
  l.store "Show this article", "Vedi l'articolo"
  l.store "Show this category", "Mostra questa categoria"
  l.store "Show this comment", "Mostra questo commento"
  l.store "Show this page", "Mostra questa pagina"
  l.store "Show this pattern", "Vedi modello"
  l.store "Show this user", "Visualizza questo utente"
  l.store "Spam Protection", "Protezione spam"
  l.store "Spam protection", "Protezione contro lo spam"
  l.store "String", "Stringa"
  l.store "Subtitle", "Sottotitolo"
  l.store "Summary", "Riassunto"
  l.store "Text Filter Details", "Dettagli filtro testo"
  l.store "Text Filters", "Filtri testo"
  l.store "Textfilter", "Formato testo"
  l.store "The below settings act as defaults when you choose to publish an enclosure with iTunes metadata", "Le impostazioni di seguito agiscono come default quando si sceglie di pubblicare delle risorse con metadati iTunes"
  l.store "Themes", "Temi"
  l.store "Things you can do", "Cose che puoi fare"
  l.store "This comment has been flagged for moderator approval. It won't appear on this blog until the author approves it", "Questo commento e' stato segnalato per essere moderato. Non apparira' finche' gli amministratori non l'approvano"
  l.store "This option let you choose between the simple admin interface or the complete one, displaying much more options and therefore more complicated to use. For advanced users only!", "Queste opzioni ti permettono di scegliere tra una amministrazione semplice o quella completa, mostrando maggiori opzioni anche complicate da usare. Solo per utenti esperti!!"
  l.store "This setting allows you to disable trackbacks for every article in your blog. It won't remove existing trackbacks, but it will prevent any further attempt to add a trackback anywhere on your blog.", "Questo settaggio ti permette di disabilitare i trackbacks sugli articoli. Non rimuovera' i trackback esistenti, ma ti proteggera' in futuro."
  l.store "Toggle Extended Content", "Mostra contenuto esteso"
  l.store "Type", "Tipo"
  l.store "Typo admin", "amministrazione typo"
  l.store "Typo can (optionally) use the %s spam-filtering service. You need to register with Akismet and receive an API key before you can use their service. If you have an Akismet key, enter it here", "Il blog puo' opzionalmente utilizzare %s come filtro spam. Registrati ad Akismet e reiceverai una chiave API prima di poter utilizzare il loro servizio. Se hai una chiave Akismet, inseriscila qui"
  l.store "Typo documentation", "Documentazione ufficale Typo"
  l.store "Update your profile or change your password", "Aggiornare il tuo profilo o cambiare la tua password"
  l.store "Upload a new File", "Invia un nuovo file"
  l.store "Upload a new Resource", "Invia una nuova risorsa"
  l.store "Uploaded", "Inviato"
  l.store "User's articles", "Articoli dell'utente"
  l.store "View", "Vedi"
  l.store "View article on your blog", "Guarda l'articolo sul blog"
  l.store "View comment on your blog", "Visualizza commento sul blog"
  l.store "View page on your blog", "Visualizza pagina sul blog"
  l.store "What can you do ?", "Cosa puoi fare?"
  l.store "Which settings group would you like to edit", "Quale gruppo di settaggi vuoi modificare "
  l.store "Write Page", "Creare Pagine"
  l.store "Write a Page", "Scrivi un pagina"
  l.store "Write a post", "Scrivere Articoli"
  l.store "Write an Article", "Scrivi un articolo"
  l.store "XML Syndication", "XML Syndication"
  l.store "You are now logged out of the system", "Sei uscito dall'amministrazione"
  l.store "You can add it to the following categories", "Puoi aggiungerlo alle seguenti categorie"
  l.store "You can optionally disable non-Ajax comments. Typo will always use Ajax for comment submission if Javascript is enabled, so non-Ajax comments are either from spammers or users without Javascript.", "Puoi disabilitare i commenti non Ajax. Il blog usera' Ajax per l'invio dei commenti se i Javascript sono abilitati, in questo modo i commenti non Ajax saranno bloccati dagli spammer e dagli utenti senza javascript."
  l.store "add new", "aggiungi nuovo"
  l.store "by", "da"
  l.store "log out", "esci"
  l.store "no ", "no "
  l.store "on", "su"
  l.store "seperate with spaces", "séparez-les par des espaces"
  l.store "via email", "per mail"
  l.store "with %s Famfamfam iconset %s", "con %s le icone Famfamfam %s"
  l.store "your blog", "il tuo blog"
end
