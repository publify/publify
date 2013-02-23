# coding: utf-8
# localization Marcin Gil <marcin.gil@gmail.com>
# additional localization Szymon (jeznet) Jeż <szymon@jez.net.pl>

Localization.define("pl_PL") do |l|

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
  l.store "Error occurred while updating Content Type.", "Wystąpił błąd w trakcie aktualizacji typu zawartości."
  l.store "complete", "zakończony"
  l.store "File uploaded: ", "Załadowany plik: "
  l.store "Unable to upload", "Nie można załadować"
  l.store "Metadata was successfully updated.", "Metadane zostały pomyślnie zaktualizowane."
  l.store "Not all metadata was defined correctly.", "Nie wszystkie metadane zostały poprawnie zdefiniowane."
  l.store "Content Type was successfully updated.", "Typ zawartości został pomyślnie zaktualizowany."

  # app/controllers/admin/settings_controller.rb
  l.store "Please review and save the settings before continuing", ""
  l.store "config updated.", "konfiguracja zaktualizowana."

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
  l.store "Cancel", "Anuluj"
  l.store "Store", ""
  l.store "Delete", "Usuń"
  l.store "delete", ""
  l.store "Delete content", ""
  l.store "Are you sure?", ""
  l.store "Please select", ""
  l.store "All categories", "Wszystkie kategorie"
  l.store "All authors", "Wszystkie autorzy"
  l.store "All published dates", "Wszystkie daty"
  l.store "There are no %s yet. Why don't you start and create one?", ""
  l.store "or", "lub"
  l.store "Save", "Zapisz"
  l.store "Edit", "Zmień"
  l.store "Show", ""
  l.store "Published", "Opublikowane"
  l.store "Unpublished", ""
  l.store "Show help on Typo macros", ""
  l.store "Back to overview", "Wróć do podglądu"
  l.store "Name", "Nazwa"
  l.store "Description", "Opis"
  l.store "Tag", ""

  # app/helpers/admin/categories_helper.rb
  l.store "no articles", "brak artykułów"
  l.store "1 article", "1 artykuł"
  l.store "%d articles", "%d artykuły"

  # app/helpers/admin/content_helper.rb
  l.store "Destroy this draft", ""

  # app/helpers/admin/feedback_helper.rb
  l.store "Show conversation", ""
  l.store "Flag as %s", ""

  # app/helpers/application_helper.rb
  l.store "%%a, %%d %%b %%Y %%H:%%M:%%S GMT", ""
  l.store "%%d. %%b", ""
  l.store "%d comments", "%d komentarze"
  l.store "no comments", "brak komentarzy"
  l.store "1 comment", "1 komentarz"
  l.store "no trackbacks", "brak trackbacków"
  l.store "1 trackback", "1 trackback"
  l.store "%d trackbacks", "%d trackbacki"

  # app/helpers/content_helper.rb
  l.store "Posted in", ""
  l.store "Tags", "Tagi"
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
  l.store "Password", "Hasło"
  l.store "Remember me", ""
  l.store "Submit", ""
  l.store "Back to ", ""

  # app/views/accounts/recover_password.html.erb
  l.store "Back to login", ""
  l.store "Username or email", ""

  # app/views/accounts/signup.html.erb
  l.store "Create an account", ""
  l.store "Username", "Użytkownik"
  l.store "Email", "Email"
  l.store "Signup", "Zapisz się"

  # app/views/admin/categories/_categories.html.erb
  l.store "Title", "Tytuł"
  l.store "Reorder", "Zmień porządek"
  l.store "Sort alphabetically", "Sortuj alfabetycznie"

  # app/views/admin/categories/_form.html.erb
  l.store "Keywords", ""

  # app/views/admin/categories/destroy.html.erb
  l.store "Are you sure you want to delete the category ", "Czy na pewno chcesz skasować kategorię "
  l.store "Delete this category", "Usuń tą kategorię"
  l.store "Categories", ""

  # app/views/admin/categories/index.html.erb
  l.store "New Category", "Utwórz nową kategorię"

  # app/views/admin/categories/new.html.erb
  l.store "%s Category", ""

  # app/views/admin/categories/reorder.html.erb
  l.store "(Done)", "(Zakończono)"

  # app/views/admin/content/_attachment.html.erb
  l.store "Remove", "Skasuj"
  l.store "Currently this article has the following resources", "Artykuł ma dołączone następujące zasoby"
  l.store "You can associate the following resources", "Możesz przypisać do artykułu następujące zasoby"
  l.store "Really delete attachment", "Na pewno skasować?"
  l.store "Add another attachment", "Dodaj kolejny załącznik"

  # app/views/admin/content/_drafts.html.erb
  l.store "Drafts", ""

  # app/views/admin/content/_form.html.erb
  l.store "Publish settings", ""
  l.store "Allow comments", "Zezwól na dodawanie komentarzy"
  l.store "Allow trackbacks", "Zezwól na podawanie trackbacków"
  l.store "Password:", ""
  l.store "Publish", "Publikuj"
  l.store "Tags", ""
  l.store "Separate tags with commas. Use double quotes (&quot;) around multi-word tags, e.g. &quot;opera house&quot;.", ""
  l.store "Excerpt", ""
  l.store "Excerpts are post summaries that show only on your blog homepage and won’t appear on the post itself", ""
  l.store "Uploads", "Załadowane zasoby"
  l.store "Post settings", ""
  l.store "Publish at", "Opublikowane dnia"
  l.store "Permalink", "Permalink"
  l.store "Article filter", "Filtr artykułów"
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
  l.store "Are you sure you want to delete this article", "Czy na pewno chcesz usunąć ten artykuł"
  l.store "Delete this article", "Usuń artykuł"
  l.store "Articles", ""

  # app/views/admin/content/index.html.erb
  l.store "New Article", ""
  l.store "Search articles that contain ...", ""
  l.store "Search", "Szukaj"
  l.store "Author", "Autor"
  l.store "Date", "Data"
  l.store "Feedback", "Komentarze"
  l.store "Filter", ""
  l.store "Manage articles", ""
  l.store "Select a category", ""
  l.store "Select an author", ""
  l.store "Publication date", ""

  # app/views/admin/dashboard/_comments.html.erb
  l.store "Error: can't generate secret token. Security is at risk. Please, change %s content", ""
  l.store "For security reasons, you should restart your Typo application. Enjoy your blogging experience.", ""
  l.store "Latest Comments", "Ostatnie komentarze"
  l.store "No comments yet", "Brak komentarzy"
  l.store "By %s on %s", "Przez %s odnośnie %s"

  # app/views/admin/dashboard/_inbound.html.erb
  l.store "Inbound links", "Linki przychodzące"
  l.store "No one made a link to you yet", "Nikt jeszcze nie stworzył do ciebie łącza"
  l.store " made a link to you saying ", " wykonał do ciebie łącze o treści "
  l.store "You have no internet connection", "Nie masz połączenia internetowego"

  # app/views/admin/dashboard/_overview.html.erb
  l.store "This place gives you a quick overview of what happens on your Typo blog and what you can do. Maybe will you want to %s, %s or %s.", ""
  l.store "update your profile or change your password", "zaktualizować profil lub zmienić hasło"
  l.store "You can also do a bit of design, %s or %s.", "Możesz również trochę poprojektować wygląd, %s lub %s."
  l.store "change your blog presentation", "zmienić wygląd swojego bloga"
  l.store "enable plugins", "aktywować wtyczkę"
  l.store "write a post", "utworzyć wpis"
  l.store "write a page", "utworzyć stronę"

  # app/views/admin/dashboard/_popular.html.erb
  l.store "Most popular", "Najpopularniejsze"
  l.store "Nothing to show yet", "Nie ma jeszcze nic do pokazania"

  # app/views/admin/dashboard/_posts.html.erb
  l.store "Latest Posts", "Ostatnie Wpisy"
  l.store "No posts yet, why don't you start and write one", ""

  # app/views/admin/dashboard/_typo_dev.html.erb
  l.store "Latest news from the Typo development blog", "Najnowsze wieści z bloga developerskiego Typo"
  l.store "Oh no, nothing new", ""

  # app/views/admin/dashboard/_welcome.html.erb
  l.store "Welcome back, %s!", "Witamy spowrotem, %s!"
  l.store "%d articles and %d comments were posted since your last connexion", "%d artykułów i %d komentarzy zostało opublikowanych od twojego ostaniego połączenia"
  l.store "You're running Typo %s", "Działasz na Typo %s"
  l.store "Total posts : %d", "Liczba wszystkich wpisów: %d"
  l.store "Your posts : %d", "Twoje wpisy: %d"
  l.store "Total comments : %d", "Liczba wszystkich komentarzy: %d"
  l.store "Spam comments : %d", "Niechciane komentarze (spam): %d"

  # app/views/admin/feedback/_button.html.erb
  l.store "Select action", ""
  l.store "Delete Checked Items", ""
  l.store "Delete all spam", ""
  l.store "Mark Checked Items as Spam", ""
  l.store "Mark Checked Items as Ham", ""
  l.store "All comments", ""
  l.store "Limit to ham", ""
  l.store "Unapproved comments", ""
  l.store "Limit to spam", "Pokaż spam"

  # app/views/admin/feedback/_form.html.erb
  l.store "Add a comment", ""
  l.store "Url", "Strona web"

  # app/views/admin/feedback/_spam.html.erb
  l.store "This comment by <strong>%s</strong> was flagged as spam, %s?", ""

  # app/views/admin/feedback/article.html.erb
  l.store "Comments for %s", ""
  l.store "Status", "Stan"
  l.store "Comment Author", ""
  l.store "Comment", ""

  # app/views/admin/feedback/edit.html.erb
  l.store "Comments for", "Komentarze do"

  # app/views/admin/feedback/index.html.erb
  l.store "Search Comments and Trackbacks that contain", ""
  l.store "Article", ""

  # app/views/admin/pages/_form.html.erb
  l.store "Online", "Online"
  l.store "Page settings", ""
  l.store "Permanent link", ""

  # app/views/admin/pages/destroy.html.erb
  l.store "Pages", "Strony"
  l.store "Are you sure you want to delete the page", "Czy na pewno chcesz usunąć tą stronę"
  l.store "Delete this page", "Usuń tą stronę"

  # app/views/admin/pages/index.html.erb
  l.store "New Page", ""
  l.store "Manage pages", ""

  # app/views/admin/profiles/index.html.erb
  l.store "Your profile", ""

  # app/views/admin/resources/_mime_edit.html.erb
  l.store "Content Type", "Typ treści"

  # app/views/admin/resources/_pages.html.erb
  l.store "Previous page", "Poprzednia strona"
  l.store "Next page", "Następna strona"

  # app/views/admin/resources/_upload.html.erb
  l.store "Upload a File to your Site", "Wyślij plik na swój blog"
  l.store "File", "Plik"
  l.store "Upload", "Wyślij"

  # app/views/admin/resources/destroy.html.erb
  l.store "Are you sure you want to delete this file", "Czy na pewno chcesz skasować ten plik"
  l.store "Delete this file from the webserver?", "Skasować ten plik z serwera?"
  l.store "File Uploads", "Wysłane pliki"

  # app/views/admin/resources/images.html.erb
  l.store "Thumbnail", ""
  l.store "File Size", "Rozmiar pliku"
  l.store "Images", "Grafika"
  l.store "right-click for link", "Kliknij PPM by uzyskać łącze"

  # app/views/admin/resources/index.html.erb
  l.store "Filename", "Nazwa pliku"
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
  l.store "Enable comments by default", "Komentarze domyślnie włączone"
  l.store "Enable Trackbacks by default", "Trackbacki domyślnie włączone"
  l.store "Enable feedback moderation", "Włącz moderację komentarzy"
  l.store "You can enable site wide feedback moderation. If you do so, no comment or trackback will appear on your blog unless you validate it.", "Możesz włączyć globalną moderację komentarzy. W takim przypadku żaden komentarz nie ukaże się na blogu aż do momentu jego akceptacji."
  l.store "Comments filter", "Filtr komentarzy"
  l.store "Enable gravatars", "Włącz gravatary"
  l.store "Show your email address", "Pokaż swój adres email"
  l.store "Notifications", ""
  l.store "Typo can notify you when new articles or comments are posted", "Typo może wysyłać powiadomienia o nowych artykułach bądź komentarzach"
  l.store "Source Email", "Źródłowy adres email"
  l.store "Email address used by Typo to send notifications", "Adres email używany przez Typo do wysyłania powiadomień"
  l.store "Enabling spam protection will make Typo compare the IP address of posters as well as the contents of their posts against local and remote blacklists. Good defense against spam bots", "Włączenie ochrony przed spamem sprawi, iż Typo będzie porównywać adresy IP nadawców oraz treść ich postów z lokalnymi i zdalnymi czarnymi listami. To dobra obrona przed spam botami."
  l.store "Enable spam protection", "Włącz ochronę przed spamem"
  l.store "Akismet Key", "Klucz Akismet"
  l.store "Typo can (optionally) use the %s spam-filtering service.  You need to register with Akismet and receive an API key before you can use their service.  If you have an Akismet key, enter it here", "Typo może (opcjonalnie) stosować usługę %s do filtrowania spamu. Musisz zarejestrować się w serwisie Akismet by otrzymać klucz API nim będzie można używać tej usługi. Jeśli posiadasz klucz API Akismet, wprowadź go tutaj"
  l.store "Disable trackbacks site-wide", ""
  l.store "This setting allows you to disable trackbacks for every article in your blog.  It won't remove existing trackbacks, but it will prevent any further attempt to add a trackback anywhere on your blog.", "Ta opcja pozwala na wyłączenie trackbacków we wszystkich artykułach. Nie usunie jednak istniejących trackbacków, a jedynie zabroni dodawania nowych."
  l.store "Disable comments after", "Wyłącz komentarze po "
  l.store "days", "dni"
  l.store "Set to 0 to never disable comments", "Ustaw 0 by komentarze były zawsze włączone"
  l.store "Max Links", "Max. liczba łączy"
  l.store "Typo will automatically reject comments and trackbacks which contain over a certain amount of links in them", "Typo automatycznie odrzuca komentarze i trackbacki, które zawierają większą, niż podana, liczbę łączy"
  l.store "Set to 0 to never reject comments", "Ustaw 0 by komentarze były zawsze akceptowane"
  l.store "Feedback settings", ""

  # app/views/admin/settings/index.html.erb
  l.store "Your blog", "Twój blog"
  l.store "Blog name", "Nazwa bloga"
  l.store "Blog subtitle", "Podtytuł bloga"
  l.store "Blog URL", "Adres URL bloga"
  l.store "Language", "Język"
  l.store "Allow users to register", ""
  l.store "You can allow users to register to your blog. By default, they will register as contributors, an unpriviledged account level which grant them no rights but own a profile on the site. If you don't want users to register, you can thus add them by yourself in the users part of this admin.", ""
  l.store "Items to display in admin lists", ""
  l.store "Publishing options", ""
  l.store "Display", "Wyświetl"
  l.store "articles on my homepage by default", "domyślnie artykułów na stronie głównej"
  l.store "articles in my news feed by default", "domyślnie artykułów w subskrypcji RSS"
  l.store "Show full article on feed", "Pokaż pełną treść artykułu w subskrypcji RSS"
  l.store "Feedburner ID", ""
  l.store "General settings", "Ustawienia ogólne"
  l.store "You can use your Google Feedburner account instead of Typo feed URL. To enable this, fill this form with your Feedburner ID.", ""

  # app/views/admin/settings/seo.html.erb
  l.store "Search Engine Optimisation", "Optymalizacja silnika wyszukiwania"
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
  l.store "Information", "Informacja"
  l.store "Current database version", "Aktualna wersja bazy danych"
  l.store "New database version", "Nowa wersja bazy danych"
  l.store "Your database supports migrations", "Twoja baza danych wspiera migracje"
  l.store "Needed migrations", "Potrzebne migracje"
  l.store "You are up to date!", "Wszystko jest aktualne!"
  l.store "Update database now", "Aktualizuj bazę danych"
  l.store "may take a moment", "może zająć dłuższą chwilę"
  l.store "Database migration", "Migruj bazę danych"
  l.store "yes", "tak"
  l.store "no", "nie"

  # app/views/admin/settings/write.html.erb
  l.store "Send trackbacks", "Wyślij trackbacki"
  l.store "When publishing articles, Typo can send trackbacks to websites that you link to. This should be disabled for private blogs as it will leak non-public information to sites that you're discussing. For public blogs, there's no real point in disabling this.", "Publikując artykuły, Typo może powiadomić strony, do których podasz łącza. Opcja ta powinna być wyłączona w przypadku blogów osobistych, gdyż może doprowadzić do wycieku prywatnych informacji. W przypadku blogów publicznych wyłączenie tej opcji nie ma większego sensu."
  l.store "URLs to ping automatically", "Automatycznie pingowane łącza"
  l.store "Latitude, Longitude", "Szerokość geogr., długość geogr."
  l.store "your latitude and longitude", "Twoją szerokość i długość geograficzna"
  l.store "example", "na przykład"
  l.store "Write", "Pisanie"

  # app/views/admin/sidebar/_availables.html.erb
  l.store "You have no plugins installed", "Brak zainstalowanych wtyczek"

  # app/views/admin/sidebar/_publish.html.erb
  l.store "Changes published", "Opublikowane zmiany"

  # app/views/admin/sidebar/_target.html.erb
  l.store "Drag some plugins here to fill your sidebar", "Przeciągnij i upuść wtyczki na pasek boczny"

  # app/views/admin/sidebar/index.html.erb
  l.store "Drag and drop to change the sidebar items displayed on this blog. To remove items from the sidebar just click 'remove'. Changes are saved immediately, but not activated until you click the 'Publish changes' button", "Przeciągnij i upuść pozycje, które mają być wyświetlone na blogu. By usunąć pozycję naciśnij *Usuń*. Zmiany są zapisywane od razu, lecz nie są aktywne do momentu kliknięcia 'Publikuj zmiany'"
  l.store "Available Items", "Dostępne elementy"
  l.store "Active Sidebar items", "Aktywne elementy paska"
  l.store "Get more plugins", ""
  l.store "Sidebar", ""
  l.store "Publish changes", "Publikuj zmiany"
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
  l.store "Display name", "Wyświetlana nazwa"

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
  l.store "Active theme", "Temat aktywny"
  l.store "Choose a theme", ""
  l.store "Use this theme", ""

  # app/views/admin/users/_form.html.erb
  l.store "Account settings", ""
  l.store "Password confirmation", ""
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
  l.store "Send notification messages via email", "Wysyłaj powiadomienia emailem"
  l.store "Send notification messages when new articles are posted", "Wysyłaj powiadomienia o nowych artykułach"
  l.store "Send notification messages when comments are posted", "Wysyłaj powiadomienia o nowych komentarzach"
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
  l.store "Really delete user", "Na pewno usunąć użytkownika"
  l.store "Yes", ""
  l.store "Users", ""

  # app/views/admin/users/edit.html.erb
  l.store "Edit User", "Zmień dane użytkownika"

  # app/views/admin/users/index.html.erb
  l.store "New User", "Nowy użytkownik"
  l.store "Comments", ""
  l.store "State", ""
  l.store "%s user", ""
  l.store "Manage users", ""

  # app/views/admin/users/new.html.erb
  l.store "Add User", ""

  # app/views/articles/_article.html.erb
  l.store "Posted by", "Opublikowane przez"
  l.store "Continue reading", "Czytaj dalej"

  # app/views/articles/_comment.html.erb
  l.store "said", "powiedział"
  l.store "This comment has been flagged for moderator approval.  It won't appear on this blog until the author approves it", "Ten komentarz oczekuje na akceptację.  Nie ukaże się do czasu zaakceptowania przez autora."

  # app/views/articles/_comment_box.html.erb
  l.store "Your name", "Twoja nazwa"
  l.store "Your email", "Twój email"
  l.store "Your message", "Treść"
  l.store "Comment Markup Help", "Pomoc języka formatowania"
  l.store "Preview comment", "Obejrzyj komentarz"
  l.store "leave url/email", ""

  # app/views/articles/_comment_failed.html.erb
  l.store "Oops, something wrong happened, the comment could not be saved", ""

  # app/views/articles/_trackback.html.erb
  l.store "From", "Z"

  # app/views/articles/archives.html.erb
  l.store "No articles found", "Brak artykułów"
  l.store "posted in", ""

  # app/views/articles/comment_preview.html.erb
  l.store "is about to say", "zaraz powie"

  # app/views/articles/groupings.html.erb
  l.store "There are", "Istnieje"

  # app/views/articles/read.html.erb
  l.store "Leave a response", "Skomentuj"
  l.store "Trackbacks", ""
  l.store "Use the following link to trackback from your own site", "Użyj następującego trackbacka na swojej stronie"
  l.store "RSS feed for this post", "Subskrypcja RSS dla tego wpisu"
  l.store "trackback uri", "Adres trackback"
  l.store "Comments are disabled", "Komentarze wyłączone"
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
  l.store "Help", "Pomocy"
  l.store "Documentation", ""
  l.store "Report a bug", ""
  l.store "In page plugins", ""
  l.store "Sidebar plugins", ""
  l.store "is proudly powered by", "dumnie działa na"
  l.store "Dashboard", "Podsumowanie"

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
  l.store "Trackbacks for", "Trackbacki do"

  # themes/true-blue-3/views/articles/search.html.erb
  l.store "Search results for:", ""

  # themes/true-blue-3/views/categories/index.html.erb
  l.store "Read all articles in %s", ""

  # themes/true-blue-3/views/categories/show.html.erb
  l.store "Previous", "Poprzednie"
  l.store "Next", "Następne"

  # vendor/plugins/archives_sidebar/views/content.rhtml
  l.store "Archives", "Archiwa"

  # vendor/plugins/authors_sidebar/views/content.rhtml
  l.store "Authors", ""

  # vendor/plugins/xml_sidebar/views/content.rhtml
  l.store "Syndicate", "Subskrypcje"
  l.store "Category %s", ""
  l.store "Tag %s", ""

  # Obsolete translations
  l.store "%d categories", "%d kategorie"
  l.store "%d tags", "%d tagi"
  l.store "%d users", "%d użytkownicy"
  l.store "1 category", "kategoria"
  l.store "1 tag", "1 tag"
  l.store "1 user", "użytkownik"
  l.store "A new message was posted to ", "Nowy wpis został dodany do "
  l.store "AIM Presence", "Status AIM"
  l.store "AIM Status", "Status AIM"
  l.store "Action", "Akcje"
  l.store "Activate", "Aktywuj"
  l.store "Add MetaData", "Dodaj metadane"
  l.store "Add category", "Dodaj kategorię"
  l.store "Add new user", "Dodaj nowego użytkownika"
  l.store "Add pattern", "Dodaj wzorzec"
  l.store "Advanced settings", "Ustawienia zaawansowane"
  l.store "Allow non-ajax comments", "Zezwól na nie-AJAXowe komentarze"
  l.store "Are you sure you want to delete this filter", "Czy na pewno chcesz usunąć ten filtr tekstu"
  l.store "Are you sure you want to delete this item?", "Czy na pewno chcesz usunąć tą pozycję?"
  l.store "Article Attachments", "Załączniki artykułu"
  l.store "Article Body", "Nagłówek artykułu"
  l.store "Article Content", "Treść artykułu"
  l.store "Article Options", "Opcje artykułu"
  l.store "Articles in", "Artykuły w"
  l.store "Attachments", "Załączniki"
  l.store "Back to the blog", "Wróć do bloga"
  l.store "Basic settings", "Ustawienia podstawowe"
  l.store "Blacklist", "Czarna lista"
  l.store "Blacklist Patterns", "Czarna lista"
  l.store "Blog advanced settings", "Ustawienia zaawansowane bloga"
  l.store "Blog settings", "Ustawienia bloga"
  l.store "Body", "Treść"
  l.store "Cache", "Bufor"
  l.store "Cache was cleared", "Bufor opróżniono"
  l.store "Category", "Kategoria"
  l.store "Category could not be created.", "Kategoria nie została utworzona."
  l.store "Category title", "Tytuł kategorii"
  l.store "Category was successfully created.", "Kategoria została pomyślnie utworzona."
  l.store "Category was successfully updated.", "Kategoria została pomyślnie zaktualizowana."
  l.store "Change your blog presentation", "Zmienić wygląd swojego bloga"
  l.store "Choose password", "Wybierz hasło"
  l.store "Choose theme", "Wybierz temat"
  l.store "Comments and Trackbacks for", "Komentarze i trackbacki do"
  l.store "Confirm password", "Potwierdź hasło"
  l.store "Copyright Information", "Informacje o prawach (copyright)"
  l.store "Create new Blacklist", "Utwórz nową czarną listę"
  l.store "Create new category", "Utwórz nową kategorię"
  l.store "Create new page", "Utwórz nową stronę"
  l.store "Create new text filter", "Utwórz nowy filtr"
  l.store "Creating comment", "Tworzenie komentarza"
  l.store "Creating text filter", "Tworzenie filtra tekstó"
  l.store "Creating trackback", "Tworzenie trackbacka"
  l.store "Creating user", "Tworzenie użytkownika"
  l.store "Currently this article is listed in following categories", "Artykuł jest opublikowany w następujących kategoriach"
  l.store "Customize", "Personalizuj"
  l.store "Customize Sidebar", "Personalizuj pasek boczny"
  l.store "Delete this filter", "Usuń filtr"
  l.store "Design", "Wygląd"
  l.store "Desired login", "Proponowany login"
  l.store "Discuss", "Dyskusje"
  l.store "Do you want to go to your blog?", "Czy chcesz obejrzeć Twój blog?"
  l.store "Duration", "Czas trwania"
  l.store "Edit Article", "Edytuj artykuł"
  l.store "Edit MetaData", "Zmień metadane"
  l.store "Edit this article", "Edytuj ten artykuł"
  l.store "Edit this category", "Edytuj tą kategorię"
  l.store "Edit this filter", "Modyfikuj ten filtr"
  l.store "Edit this page", "Edytuj tą stronę"
  l.store "Edit this trackback", "Modyfikuj ten trackback"
  l.store "Editing User", "Zmiana danych użytkownika"
  l.store "Editing category", "Edytuj kategorię"
  l.store "Editing comment", "Edycja komentarza"
  l.store "Editing page", "Edytuj stronę"
  l.store "Editing pattern", "Zmiana wzorca"
  l.store "Editing textfilter", "Modyfikuj filtr"
  l.store "Editing trackback", "Modyfikuj trackback"
  l.store "Empty Fragment Cache", "Usuń bufor fragmentów"
  l.store "Enable plugins", "Aktywować wtyczki"
  l.store "Explicit", "Tylko dla dorosłych"
  l.store "Extended Content", "Treść rozszerzona"
  l.store "Feedback Search", "Przeszukaj komentarze"
  l.store "Files", "Pliki"
  l.store "Filters", "Filtry"
  l.store "General Settings", "Ustawienia ogólne"
  l.store "HTML was cleared", "HTML opróżniono"
  l.store "IP", "Adres IP"
  l.store "Jabber", "Jabber"
  l.store "Jabber account", "Konto Jabber"
  l.store "Jabber account to use when sending Jabber notifications", "Konto Jabber do wysyłania powiadomień"
  l.store "Jabber password", "Hasło konta Jabber"
  l.store "Key Words", "Słowa kluczowe"
  l.store "Last updated", "Ostatnio zmieniany"
  l.store "Limit to unconfirmed", "Pokaż niepotwierdzone"
  l.store "Limit to unconfirmed spam", "Pokaż niepotwierdzony spam"
  l.store "Location", "Lokacja"
  l.store "Log out", "Wyloguj"
  l.store "Logoff", "Wyloguj"
  l.store "Macro Filter Help", "Pomoc makr filtrów"
  l.store "Macros", "Makra"
  l.store "Manage", "Zarządzaj"
  l.store "Manage Articles", "Zarządzaj artykułami"
  l.store "Manage Categories", "Zarządzaj kategoriami"
  l.store "Manage Pages", "Zarządzaj stronami"
  l.store "Manage Resources", "Zarządzaj zasobami"
  l.store "Manage Text Filters", "Zarządzaj filtrami tekstu"
  l.store "Markup", "Znaczniki"
  l.store "Markup type", "Typ znaczników"
  l.store "MetaData", "Metadane"
  l.store "Metadata was successfully removed.", "Metadane zostały pomyślnie usunięte."
  l.store "New post", "Nowy wpis"
  l.store "Not published by Apple", "Nie publikowane przez Apple"
  l.store "Notification", "Powiadomienia"
  l.store "Notified", "Powiadamiony"
  l.store "Notify on new articles", "Powiadamiaj o nowych artykułach"
  l.store "Notify on new comments", "Powiadamiaj o nowych komentarzach"
  l.store "Notify via email", "Powiadamiaj emailem"
  l.store "Number of Articles", "Liczba artykułów"
  l.store "Number of Comments", "Liczba komentarzy"
  l.store "Offline", "Offline"
  l.store "Older posts", "Starsze wpisy"
  l.store "Optional Extended Content", "Opcjonalna treść rozszerzona"
  l.store "Optional Name", "Nazwa opcjonalna"
  l.store "Optional extended content", "Opcjonalna treść rozszerzona"
  l.store "Page Body", "Nagłówek strony"
  l.store "Page Content", "Treść strony"
  l.store "Page Options", "Opcje strony"
  l.store "Parameters", "Parametry"
  l.store "Password Confirmation", "Potwierdzenie hasła"
  l.store "Pattern", "Wzorzec"
  l.store "Pictures from", "Zdjęcia z"
  l.store "Post", "Wpis"
  l.store "Post title", "Tytuł wpisu"
  l.store "Post-processing filters", "Filtr post-process"
  l.store "Posted at", "Data publikacji"
  l.store "Posted date", "Data publikacji"
  l.store "Posts", "Wpisy"
  l.store "Preview Article", "Podgląd artykułu"
  l.store "Read", "Odczyt"
  l.store "Read more", "Czytaj dalej"
  l.store "Rebuild cached HTML", "Przebuduj bufor HTML"
  l.store "Recent comments", "Ostatnie komentarze"
  l.store "Recent trackbacks", "Ostatnie trackbacki"
  l.store "Regex", "Wyrażenie regularne"
  l.store "Remove iTunes Metadata", "Usuń metadane iTunes"
  l.store "Resource MetaData", "Metadane zasobu"
  l.store "Resource Settings", "Ustawienia zasobów"
  l.store "Save Settings", "Zapisz ustawienia"
  l.store "See help text for this filter", "Zobacz pomoc dla tego filtra"
  l.store "Set iTunes metadata for this enclosure", "Ustaw metadane iTunes"
  l.store "Setting for channel", "Ustawienia kanału"
  l.store "Settings", "Ustawienia"
  l.store "Show Help", "Pomoc"
  l.store "Show this article", "Pokaż artykuł"
  l.store "Show this category", "Pokaż tą kategorię"
  l.store "Show this comment", "Pokaż komentarz"
  l.store "Show this page", "Pokaż tą stronę"
  l.store "Show this pattern", "Pokaż ten wzorzec"
  l.store "Show this user", "Pokazuj tego użytkownika"
  l.store "Spam Protection", "Ochrona przed spamem"
  l.store "Spam protection", "Ochrona przed spamem"
  l.store "String", "Ciąg znaków"
  l.store "Subtitle", "Podtytuł"
  l.store "Summary", "Streszczenie"
  l.store "Text Filter Details", "Szczegóły filtra tekstu"
  l.store "Text Filters", "Filtry tekstu"
  l.store "Textfilter", "Filtr tekstu"
  l.store "The below settings act as defaults when you choose to publish an enclosure with iTunes metadata", "Poniższe ustawienia podawane są jako domyślne jeśli publikacja będzie zawierać metadane iTunes"
  l.store "Things you can do", "Dostępne działania"
  l.store "This option let you choose between the simple admin interface or the complete one, displaying much more options and therefore more complicated to use. For advanced users only!", "Ta opcja pozwala wybrać prosty lub pełny panel administracyjny. Pełny panel administracyjny zawiera więcej opcji przez co jest bardziej skomplikowany. Tylko dla zaawansowanych użytkowników!"
  l.store "Toggle Extended Content", "Przełącz treść rozszerzoną"
  l.store "Type", "Typ"
  l.store "Typo admin", "administracja Typo"
  l.store "Typo documentation", "Oficjalna dokumentacja Typo"
  l.store "Update your profile or change your password", "Zaktualizować profil lub zmienić hasło"
  l.store "Upload a new File", "Wyślij nowy plik"
  l.store "Upload a new Resource", "Wyślij nowy zasób"
  l.store "Uploaded", "Załadowany"
  l.store "User's articles", "Artykuły użytkownika"
  l.store "View", "Obejrzyj"
  l.store "View article on your blog", "Obejrzyj artykuł na blogu"
  l.store "View comment on your blog", "Obejrzyj komentarz na blogu"
  l.store "View page on your blog", "Zaprezentuj stronę na blogu"
  l.store "What can you do ?", "Co możesz zrobić?"
  l.store "Which settings group would you like to edit", "Którą grupę ustawień chcesz zmodyfikować"
  l.store "Write Page", "Utworzyć stronę"
  l.store "Write Post", "Utworzyć wpis"
  l.store "Write a Page", "Utwórz stronę"
  l.store "Write an Article", "Utwórz artykuł"
  l.store "XML Syndication", "Subskrypcja XML"
  l.store "You are now logged out of the system", "Wylogowano z systemu"
  l.store "You can add it to the following categories", "Możesz dodać go do następujących kategorii"
  l.store "You can optionally disable non-Ajax comments. Typo will always use Ajax for comment submission if Javascript is enabled, so non-Ajax comments are either from spammers or users without Javascript.", "Można opcjonalnie wyłączyć nie-Ajaxowe komentarze. Typo zawsze używa technologii Ajax do przesyłania komentarzy - o ile Javascript jest włączony. Przeważnie komentarze nie-Ajaxowe pochodzą od spamerów lub użytkowników bez Javascript."
  l.store "add new", "dodaj nową"
  l.store "by", "przez"
  l.store "log out", "wyloguj"
  l.store "no ", "brak "
  l.store "no categories", "brak kategori"
  l.store "no tags", "brak tagów"
  l.store "no users", "brak użytkowników"
  l.store "on", "na"
  l.store "seperate with spaces", "rozdziel spacjami"
  l.store "via email", "emailem"
  l.store "with %s Famfamfam iconset %s", "z %s ze zbioru ikon Famfamfam %s"
  l.store "your blog", "Twój blog"
end
