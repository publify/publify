Localization.define("nl_NL") do |l|

  # app/controllers/accounts_controller.rb
  l.store "Login successful", "Login geslaagd"
  l.store "Login unsuccessful", "Login mislukt"
  l.store "An email has been successfully sent to your address with your new password", "Er is u met succes een e-mail gestuurd met uw nieuwe wachtwoord"
  l.store "Oops, something wrong just happened", "Oeps, er is net iets misgegaan"
  l.store "Successfully logged out", "Succesvol uitgelogd"
  l.store "login", "inloggen"
  l.store "signup", "aanmelden"
  l.store "Recover your password", ""

  # app/controllers/admin/categories_controller.rb
  l.store "Category was successfully saved.", "Categorie succesvol opgeslagen."
  l.store "Category could not be saved.", "Categorie kon niet opgeslagen worden."

  # app/controllers/admin/content_controller.rb
  l.store "Error, you are not allowed to perform this action", "Fout, u mag dit niet doen"
  l.store "Preview", "Bekijk"
  l.store "Article was successfully created", "Artikel is succesvol gemaakt"
  l.store "Article was successfully updated.", "Artikel is succesvol bijgewerkt."

  # app/controllers/admin/feedback_controller.rb
  l.store "Deleted", "Verwijderd"
  l.store "Not found", "Niet gevonden"
  l.store "Deleted %d item(s)", "%d items verwijderd"
  l.store "Marked %d item(s) as Ham", "%d Item(s) gemarkeerd als Ham"
  l.store "Marked %d item(s) as Spam", "%d Item(s) gemarkeerd als Spam"
  l.store "Confirmed classification of %s item(s)", "Classificatie van %s item(s) bevestigd"
  l.store "Not implemented", "Niet geimplementeerd"
  l.store "All spam have been deleted", "Alle spam is verwijderd"
  l.store "Comment was successfully created.", "Commentaar is succesvol aangemaakt."
  l.store "Comment was successfully updated.", "Commentaar is succesvol bijgewerkt."

  # app/controllers/admin/pages_controller.rb
  l.store "Page was successfully created.", "Pagina is succesvol aangemaakt."
  l.store "Page was successfully updated.", "Pagina is succesvol bijgewerkt."

  # app/controllers/admin/profiles_controller.rb
  l.store "User was successfully updated.", "Gebruiker is succesvol bijgewerkt."

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
  l.store "No posts found...", "Geen berichten gevonden..."
  l.store "Archives for", "Archieven voor"
  l.store "Archives for ", "Archieven voor "
  l.store ", Articles for ", ", Berichten voor "

  # app/controllers/grouping_controller.rb
  l.store "page", "pagina"
  l.store "everything about", "alles over"

  # app/helpers/admin/base_helper.rb
  l.store "Cancel", "Terug"
  l.store "Store", ""
  l.store "Delete", ""
  l.store "delete", ""
  l.store "Delete content", ""
  l.store "Are you sure?", ""
  l.store "Please select", ""
  l.store "There are no %s yet. Why don't you start and create one?", "Er zijn nog geen %s. Waarom begin je er niet een te maken?"
  l.store "or", "of"
  l.store "Save", "Bewaar"
  l.store "Edit", ""
  l.store "Show", ""
  l.store "Published", "Gepubliceerd"
  l.store "Unpublished", ""
  l.store "Show help on Typo macros", ""
  l.store "Back to overview", ""
  l.store "Name", "Naam"
  l.store "Description", "Omschrijving"
  l.store "Tag", ""

  # app/helpers/admin/categories_helper.rb
  l.store "no articles", "geen artikelen"
  l.store "1 article", "1 artikel"
  l.store "%d articles", "%d artikelen"

  # app/helpers/admin/content_helper.rb
  l.store "Destroy this draft", ""

  # app/helpers/admin/feedback_helper.rb
  l.store "Show conversation", ""
  l.store "Flag as %s", ""

  # app/helpers/application_helper.rb
  l.store "%%a, %%d %%b %%Y %%H:%%M:%%S GMT", "%%a, %%d %%b %%Y %%H:%%M:%%S GMT"
  l.store "%%d. %%b", "%%d. %%b"
  l.store "%d comments", "%d reacties"
  l.store "no comments", "geen reacties"
  l.store "1 comment", "één reactie"
  l.store "no trackbacks", "geen trackbacks"
  l.store "1 trackback", "één trackback"
  l.store "%d trackbacks", "%d trackbacks"

  # app/helpers/content_helper.rb
  l.store "Posted in", "Geplaatst in"
  l.store "Tags", "Trefwoorden"
  l.store "no posts", "geen berichten"
  l.store "1 post", "één bericht"
  l.store "%d posts", "%d berichten"

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
  l.store "Unclassified", "Niet geclassificeerd"
  l.store "Just Presumed Ham", ""
  l.store "Ham?", "Ham?"
  l.store "Just Marked As Ham", ""
  l.store "Ham", "Ham"
  l.store "Spam?", "Spam?"
  l.store "Just Marked As Spam", ""
  l.store "Spam", "Spam"

  # app/views/accounts/login.html.erb
  l.store "I've lost my password", ""
  l.store "Login", ""
  l.store "Password", ""
  l.store "Remember me", "Onthou me"
  l.store "Submit", "Verstuur"
  l.store "Back to ", "Terug naar"

  # app/views/accounts/recover_password.html.erb
  l.store "Username or email", ""

  # app/views/accounts/signup.html.erb
  l.store "Create an account", ""
  l.store "Username", ""
  l.store "Email", "Email"
  l.store "Signup", "Meld aan"

  # app/views/admin/categories/_categories.html.erb
  l.store "Title", "Titel"
  l.store "Reorder", "Orden opnieuw"
  l.store "Sort alphabetically", "Sorteer alfabetisch"

  # app/views/admin/categories/_form.html.erb
  l.store "Keywords", "Trefwoorden"

  # app/views/admin/categories/destroy.html.erb
  l.store "Are you sure you want to delete the category ", "Weet je zeker dat je de categorie wilt verwijderen?"
  l.store "Delete this category", "Verwijder deze categorie"
  l.store "Categories", "Categoriën"

  # app/views/admin/categories/index.html.erb
  l.store "New Category", ""

  # app/views/admin/categories/new.html.erb
  l.store "%s Category", "%s Categorie"

  # app/views/admin/categories/reorder.html.erb
  l.store "(Done)", "(Gedaan)"

  # app/views/admin/content/_attachment.html.erb
  l.store "Remove", ""
  l.store "Currently this article has the following resources", ""
  l.store "You can associate the following resources", ""
  l.store "Really delete attachment", ""
  l.store "Add Another Attachment", ""

  # app/views/admin/content/_drafts.html.erb
  l.store "Drafts", ""

  # app/views/admin/content/_form.html.erb
  l.store "Publish settings", ""
  l.store "Allow comments", "Sta reacties toe"
  l.store "Allow trackbacks", ""
  l.store "Password:", ""
  l.store "Publish", "Publiceer"
  l.store "Excerpt", ""
  l.store "Excerpts are posts summaries that are shown on your blog homepage only but won’t appear on the post itself", ""
  l.store "Uploads", ""
  l.store "Post settings", ""
  l.store "Publish at", ""
  l.store "Permalink", ""
  l.store "Article filter", ""
  l.store "Save as draft", ""

  # app/views/admin/content/destroy.html.erb
  l.store "Are you sure you want to delete this article", "Weet je zeker dat je dit artikel wilt verwijderen?"
  l.store "Delete this article", "Verwijder dit artikel"
  l.store "Articles", "Artikelen"

  # app/views/admin/content/index.html.erb
  l.store "New Article", ""
  l.store "Search articles that contain ...", "Zoek artikelen met ..."
  l.store "Search", "Zoek"
  l.store "Author", "Auteur"
  l.store "Date", "Datum"
  l.store "Feedback", "Feedback"
  l.store "Filter", "Filter"
  l.store "Manage articles", "Beheer artikelen"

  # app/views/admin/dashboard/_comments.html.erb
  l.store "Latest Comments", "Laatste reacties"
  l.store "No comments yet", "Nog geen reacties"
  l.store "By %s on %s", "door %s op %s"

  # app/views/admin/dashboard/_inbound.html.erb
  l.store "Inbound links", "Binnenkomende links"
  l.store "No one made a link to you yet", "Niemand maakte nog een link naar je"
  l.store " made a link to you saying ", " maakte een link naar je met als tekst "
  l.store "You have no internet connection", "Je hebt geen internetverbinding"

  # app/views/admin/dashboard/_overview.html.erb
  l.store "This place gives you a quick overview of what happens on your Typo blog and what you can do. Maybe will you want to %s, %s or %s.", ""
  l.store "update your profile or change your password", ""
  l.store "You can also do a bit of design, %s or %s.", ""
  l.store "change your blog presentation", ""
  l.store "enable plugins", ""
  l.store "write a post", ""
  l.store "write a page", ""

  # app/views/admin/dashboard/_popular.html.erb
  l.store "Most popular", "Meest populair"
  l.store "Nothing to show yet", "Nog niets te zien"

  # app/views/admin/dashboard/_posts.html.erb
  l.store "Latest Posts", "Laatste berichten"
  l.store "No posts yet, why don't you start and write one", "Nog geen berichten, waarom begin je er niet een te schrijven"

  # app/views/admin/dashboard/_typo_dev.html.erb
  l.store "Latest news from the Typo development blog", ""
  l.store "Oh no, nothing new", ""

  # app/views/admin/dashboard/_welcome.html.erb
  l.store "Welcome back, %s!", "Welkom terug, %s!"
  l.store "%d articles and %d comments were posted since your last connexion", ""
  l.store "You're running Typo %s", "Je gebruikt Typo %s"
  l.store "Total posts : %d", "Aantal berichten : %d"
  l.store "Your posts : %d", "Jouw berichten : %d"
  l.store "Total comments : %d", "Aantal reacties : %d"
  l.store "Spam comments : %d", "Spam reacties : %d"

  # app/views/admin/feedback/_button.html.erb
  l.store "Select action", ""
  l.store "Delete Checked Items", "Verwijder aangevinkte reacties"
  l.store "Delete all spam", "Verwijder alle spam"
  l.store "Mark Checked Items as Spam", "Markeer aangevinkte reacties als Spam"
  l.store "Mark Checked Items as Ham", "Markeer aangevinkte reacties als Ham"
  l.store "All comments", ""
  l.store "Limit to ham", ""
  l.store "Unapproved comments", ""
  l.store "Limit to spam", ""

  # app/views/admin/feedback/_form.html.erb
  l.store "Add a comment", ""
  l.store "Url", ""

  # app/views/admin/feedback/_spam.html.erb
  l.store "This comment by <strong>%s</strong> was flagged as spam, %s?", ""

  # app/views/admin/feedback/article.html.erb
  l.store "Comments for %s", ""
  l.store "Status", "Status"
  l.store "Comment Author", ""
  l.store "Comment", "Reactie"

  # app/views/admin/feedback/edit.html.erb
  l.store "Comments for", ""

  # app/views/admin/feedback/index.html.erb
  l.store "Search Comments and Trackbacks that contain", ""
  l.store "Article", ""

  # app/views/admin/pages/_form.html.erb
  l.store "Online", ""
  l.store "Page settings", ""
  l.store "Permanent link", ""

  # app/views/admin/pages/destroy.html.erb
  l.store "Pages", "Pagina's"
  l.store "Are you sure you want to delete the page", "Weet je zeker dat je deze pagina wilt verwijderen"
  l.store "Delete this page", "Verwijder deze pagina"

  # app/views/admin/pages/index.html.erb
  l.store "New Page", ""
  l.store "Manage pages", ""

  # app/views/admin/profiles/index.html.erb
  l.store "Your profile", ""

  # app/views/admin/resources/_mime_edit.html.erb
  l.store "Content Type", "Content Type"

  # app/views/admin/resources/_pages.html.erb
  l.store "Previous page", "Vorige pagina"
  l.store "Next page", "Volgende pagina"

  # app/views/admin/resources/_upload.html.erb
  l.store "Upload a File to your Site", ""
  l.store "File", ""
  l.store "Upload", ""

  # app/views/admin/resources/destroy.html.erb
  l.store "Are you sure you want to delete this file", "Weet je zeker dat je dit bestand wilt verwijderen?"
  l.store "Delete this file from the webserver?", ""
  l.store "File Uploads", ""

  # app/views/admin/resources/images.html.erb
  l.store "Thumbnail", ""
  l.store "File Size", ""
  l.store "Images", ""
  l.store "right-click for link", ""

  # app/views/admin/resources/index.html.erb
  l.store "Filename", ""

  # app/views/admin/settings/_submit.html.erb
  l.store "Update settings", ""

  # app/views/admin/settings/feedback.html.erb
  l.store "Enable comments by default", ""
  l.store "Enable Trackbacks by default", ""
  l.store "Enable feedback moderation", ""
  l.store "You can enable site wide feeback moderation. If you do so, no comment or trackback will appear on your blog unless you validate it", ""
  l.store "Comments filter", ""
  l.store "Enable gravatars", ""
  l.store "Show your email address", ""
  l.store "Notifications", ""
  l.store "Typo can notify you when new articles or comments are posted", ""
  l.store "Source Email", ""
  l.store "Email address used by Typo to send notifications", ""
  l.store "Enabling spam protection will make typo compare the IP address of posters as well as the contents of their posts against local and remote blacklists. Good defense against spam bots", ""
  l.store "Enable spam protection", ""
  l.store "Akismet Key", ""
  l.store "Typo can (optionally) use the %s spam-filtering service.  You need to register with Akismet and receive an API key before you can use their service.  If you have an Akismet key, enter it here", ""
  l.store "Disable trackbacks site-wide", ""
  l.store "This setting allows you to disable trackbacks for every article in your blog.  It won't remove existing trackbacks, but it will prevent any further attempt to add a trackback anywhere on your blog.", ""
  l.store "Disable comments after", ""
  l.store "days", ""
  l.store "Set to 0 to never disable comments", ""
  l.store "Max Links", ""
  l.store "Typo will automatically reject comments and trackbacks which contain over a certain amount of links in them", ""
  l.store "Set to 0 to never reject comments", ""
  l.store "Feedback settings", ""

  # app/views/admin/settings/index.html.erb
  l.store "Your blog", ""
  l.store "Blog name", ""
  l.store "Blog subtitle", ""
  l.store "Blog URL", ""
  l.store "Language", ""
  l.store "Allow users to register", ""
  l.store "You can allow users to register to your blog. By default, they will register as contributors, an unpriviledged account level which grant them no rights but own a profile on the site. If you don't want users to register, you can thus add them by yourself in the users part of this admin.", ""
  l.store "Items to display in admin lists", ""
  l.store "Publishing options", ""
  l.store "Display", ""
  l.store "articles on my homepage by default", ""
  l.store "articles in my news feed by default", ""
  l.store "Show full article on feed", ""
  l.store "Feedburner ID", ""
  l.store "General settings", ""
  l.store "You can use your Google Feedburner account instead of Typo feed URL. To enable this, fill this form with your Feedburner ID.", ""

  # app/views/admin/settings/seo.html.erb
  l.store "Search Engine Optimisation", ""
  l.store "Show blog name", ""
  l.store "At the beginning of page title", ""
  l.store "At the end of page title", ""
  l.store "Don't show blog name in page title", ""
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
  l.store "Information", ""
  l.store "Current database version", ""
  l.store "New database version", ""
  l.store "Your database supports migrations", ""
  l.store "Needed migrations", ""
  l.store "You are up to date!", ""
  l.store "Update database now", ""
  l.store "may take a moment", ""
  l.store "Database migration", ""
  l.store "yes", ""
  l.store "no", ""

  # app/views/admin/settings/write.html.erb
  l.store "Send trackbacks", ""
  l.store "When publishing articles, Typo can send trackbacks to websites that you link to. This should be disabled for private blogs as it will leak non-public information to sites that you're discussing. For public blogs, there's no real point in disabling this.", ""
  l.store "URLs to ping automatically", ""
  l.store "Latitude, Longitude", ""
  l.store "your lattitude and longitude", ""
  l.store "exemple", ""
  l.store "Write", "Schrijf"

  # app/views/admin/sidebar/_publish.html.erb
  l.store "Changes published", ""

  # app/views/admin/sidebar/_target.html.erb
  l.store "Drag some plugins here to fill your sidebar", ""

  # app/views/admin/sidebar/index.html.erb
  l.store "Drag and drop to change the sidebar items displayed on this blog.  To remove items from the sidebar just click remove  Changes are saved immediately, but not activated until you click the 'Publish' button", ""
  l.store "Available Items", ""
  l.store "You have no plugins installed", ""
  l.store "Active Sidebar items", ""
  l.store "Get more plugins", ""
  l.store "Sidebar", ""
  l.store "Publish changes", ""

  # app/views/admin/tags/_form.html.erb
  l.store "Display name", "Schermnaam"

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
  l.store "Active theme", ""
  l.store "Get more themes", ""
  l.store "You can download third party themes from officially supported %s ", ""
  l.store "Typogarden", ""
  l.store "To install a theme you  just need to upload the theme folder into your themes directory. Once a theme is uploaded, you should see it on this page.", ""
  l.store "Choose a theme", ""

  # app/views/admin/users/_form.html.erb
  l.store "Account settings", ""
  l.store "Password confirmation", "Bevestig wachtwoord"
  l.store "Profile", "Profiel"
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
  l.store "Send notification messages via email", ""
  l.store "Send notification messages when new articles are posted", ""
  l.store "Send notification messages when comments are posted", ""
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
  l.store "Really delete user", ""
  l.store "Yes", ""
  l.store "Users", ""

  # app/views/admin/users/edit.html.erb
  l.store "Edit User", ""

  # app/views/admin/users/index.html.erb
  l.store "New User", ""
  l.store "Comments", "Reacties"
  l.store "State", ""
  l.store "%s user", ""

  # app/views/admin/users/new.html.erb
  l.store "Add User", ""

  # app/views/articles/_article.html.erb
  l.store "Posted by", "Geplaatst door"
  l.store "Continue reading", "Verder lezen"

  # app/views/articles/_comment.html.erb
  l.store "said", "zei"
  l.store "This comment has been flagged for moderator approval.  It won't appear on this blog until the author approves it", "Dit commentaar is gemarkeerd voor goedkeuring. Het zal niet getoond worden totdat de auteur het goedkeurd."

  # app/views/articles/_comment_box.html.erb
  l.store "Your name", "Jouw naam"
  l.store "Your email", "Jouw e-mail"
  l.store "Your message", "Jouw bericht"
  l.store "Comment Markup Help", ""
  l.store "Preview comment", "Bekijk reactie"
  l.store "leave url/email", "plaats url/e-mail"

  # app/views/articles/_comment_failed.html.erb
  l.store "Oops, something wrong happened, the comment could not be saved", "Er is iets mis gegaan en je reactie is niet bewaard"

  # app/views/articles/_trackback.html.erb
  l.store "From", "Van"

  # app/views/articles/archives.html.erb
  l.store "No articles found", "Geen artikelen gevonden"
  l.store "posted in", "geplaatst in"

  # app/views/articles/comment_preview.html.erb
  l.store "is about to say", "gaat zeggen"

  # app/views/articles/groupings.html.erb
  l.store "There are", "Er zijn"

  # app/views/articles/read.html.erb
  l.store "Leave a response", "Geef een reactie"
  l.store "Trackbacks", "Trackbacks"
  l.store "Use the following link to trackback from your own site", "Gebruik de volgende link voor een trackback van jouw site"
  l.store "RSS feed for this post", "RSS feed voor dit bericht"
  l.store "trackback uri", "trackback uri"
  l.store "Comments are disabled", "Reacties zijn niet mogelijk"

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
  l.store "This comment has been flagged for moderator approval.", "Deze reactie is aangemerkt voor goedkeuring."

  # app/views/layouts/administration.html.erb
  l.store "%s &raquo;", ""
  l.store "is proudly powered by", ""
  l.store "Dashboard", "Dashboard"

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

  # lib/action_web_service/casting.rb
  l.store "#{name}=", ""

  # lib/action_web_service/struct.rb
  l.store "%s=", ""

  # test/mocks/themes/typographic/layouts/default.html.erb
  l.store "Powered by %s", "Powered by %s"
  l.store "Designed by %s ", "Ontworpen door %s"

  # test/mocks/themes/typographic/views/articles/_article.html.erb
  l.store "Continue reading...", "Lees meer..."
  l.store "This entry was posted on %s", "Dit bericht was geplaatst op %s"
  l.store "and %s", "en %s"
  l.store "You can follow any any response to this entry through the %s", "Je kunt reacties op dit bericht volgen via de %s"
  l.store "Atom feed", "Atom feed"
  l.store "You can leave a %s", "Je kunt een %s achterlaten"
  l.store "or a %s from your own site", "of een %s vanaf je eigen site"
  l.store "Read full article", "Lees volledige artikel"
  l.store "comment", "reactie"
  l.store "trackback", "trackback"

  # test/mocks/themes/typographic/views/articles/_comment.html.erb
  l.store "later", "later"

  # test/mocks/themes/typographic/views/articles/_comment_form.html.erb
  l.store "Leave a comment", "Geef een reactie"
  l.store "Name %s", "Naam %s"
  l.store "enabled", "aangezet"
  l.store "never displayed", "wordt niet getoond"
  l.store "Website", "Website"
  l.store "Textile enabled", "Textile beschikbaar"
  l.store "Markdown enabled", "Markdown beschikbaar"
  l.store "required", "verplicht"

  # test/mocks/themes/typographic/views/articles/_comment_list.html.erb
  l.store "No comments", "Geen reacties"

  # test/mocks/themes/typographic/views/shared/_search.html.erb
  l.store "Searching", "Aan het zoeken"

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
  l.store "Trackbacks for", ""

  # themes/true-blue-3/views/articles/search.html.erb
  l.store "Search results for:", ""

  # themes/true-blue-3/views/categories/index.html.erb
  l.store "Read all articles in %s", ""

  # themes/true-blue-3/views/categories/show.html.erb
  l.store "Previous", ""
  l.store "Next", ""

  # vendor/plugins/archives_sidebar/views/content.rhtml
  l.store "Archives", "Archieven"

  # vendor/plugins/authors_sidebar/views/content.rhtml
  l.store "Authors", ""

  # vendor/plugins/xml_sidebar/views/content.rhtml
  l.store "Syndicate", ""
  l.store "Category %s", ""
  l.store "Tag %s", ""

  # Obsolete translations
  l.store "Blacklist Patterns", "Blacklist patronen"
  l.store "Choose password", "Kies wachtwoord"
  l.store "Confirm Classification of Checked Items", "Bevestig classificatie van aangevinkte reacties"
  l.store "Content", "Inhoud"
  l.store "Editing pattern", "Wijzig patroon"
  l.store "Pattern", "Patroon"
  l.store "Posts", "Berichten"
  l.store "Read more", "Lees meer"
  l.store "Recent comments", "Recente reacties"
  l.store "Recent trackbacks", "Recente trackbacks"
  l.store "Type", "Type"
  l.store "add new", "voeg toe"
end
