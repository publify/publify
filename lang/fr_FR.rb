#coding: utf-8
Localization.define("fr_FR") do |l|
  # app/controllers/accounts_controller.rb
  l.store "Login successful", "Connexion réussie"
  l.store "Login unsuccessful", "Échec de la connexion"
  l.store "An email has been successfully sent to your address with your new password", "Un courrier vous a été envoyé avec votre nouveau mot de passe"
  l.store "Oops, something wrong just happened", "Désolé, une erreur vient de se produire"
  l.store "Successfully logged out", "Vous êtes maintenant déconnecté"
  l.store "login", "identifiant"
  l.store "signup", "s'identifier"
  l.store "Recover your password", "Récupération d'un mot de passe perdu"

  # app/controllers/admin/cache_controller.rb
  l.store "Cache was successfully sweeped", "Le cache a été vidé avec succès"
  l.store "Oops, something wrong happened. Cache could not be cleaned", "Oops, un problème s'est produit et le cache n'a pas pu être vidé correctement"

  # app/controllers/admin/categories_controller.rb
  l.store "Category was successfully saved.", "La catégorie a été enregistrée avec succès"
  l.store "Category could not be saved.", "La catégorie n'a pas pu être sauvée"

  # app/controllers/admin/content_controller.rb
  l.store "Error, you are not allowed to perform this action", "Erreur, vous n'avez pas les droits requis pour effectuer cette action"
  l.store "This article was deleted successfully", "Cet article a été supprimé avec succès"
  l.store "Preview", "Prévisualiser "
  l.store "Article was successfully created", "Cet article a été créé avec succès"
  l.store "Article was successfully updated.", "Cet article a été mis à jour avec succès"

  # app/controllers/admin/dashboard_controller.rb
  l.store "Error: can't generate secret token. Security is at risk. Please, change %s content", "Erreur : nous n'avons pas pu générer le jeton secret. La sécurité de votre blog est à risque. Veuillez changer le contenu du fichier %s."
  l.store "For security reasons, you should restart your Typo application. Enjoy your blogging experience.", "Pour des raisons de sécurité, merci de redémarrer votre blog Typo. Bonne expérience de blogging !"
  l.store "You are late from at least one major version of Typo. You should upgrade immediately. Download and install %s", "Vous avez au moins une version majeure de Typo de retard. Vous devriez immédiatement vous mettre à jour. Téléchargez et installez %s" 
  l.store "the latest Typo version", "la dernière version de Typo"
  l.store "There's a new version of Typo available which may contain important bug fixes. Why don't you upgrade to %s ?", "Une nouvelle version de Typo est disponible. Celle-ci contient probablement d'importants correctifs. Pourquoi ne téléchargeriez-vous pas %s"
  l.store "There's a new version of Typo available. Why don't you upgrade to %s ?", "Une nouvelle version de Typo est disponible. Pouquoi n'installeriez-vous pas %s"
  l.store "at an unknown date", "à une date inconnue"

  # app/controllers/admin/feedback_controller.rb
  l.store "Deleted", "Supprimé"
  l.store "Not found", "Introuvable"
  l.store "Deleted %d item(s)", "%d commentaires ont été supprimés"
  l.store "Marked %d item(s) as Ham", "%d commentaires ont été validés"
  l.store "Marked %d item(s) as Spam", "%d commentaires ont été marqués comme spam"
  l.store "Confirmed classification of %s item(s)", "La classification de %d commentaires a été validée"
  l.store "Not implemented", "Non implémenté"
  l.store "All spam have been deleted", "Tout le spam a été supprimé"
  l.store "Comment was successfully created.", "Commentaire créé avec succès."
  l.store "Comment was successfully updated.", "Commentaire mis à jour avec succès."

  # app/controllers/admin/pages_controller.rb
  l.store "Page was successfully created.", "Cette page a été créée avec succès"
  l.store "Page was successfully updated.", "Cette page a été mise à jour avec succès"

  # app/controllers/admin/post_types_controller.rb
  l.store "Post Type was successfully saved.", "Le type d'article a été sauvé avec succès"
  l.store "Post Type could not be saved.", "Le type d'article n'a pas pu être sauvé"

  # app/controllers/admin/profiles_controller.rb
  l.store "User was successfully updated.", "L'utilisateur a été mis à jour avec succès."

  # app/controllers/admin/redirects_controller.rb
  l.store "Redirection was successfully deleted.", "La redirection a été supprimée avec succès."
  l.store "Redirection was successfully saved.", "La redirection a été enregistrée avec succès."
  l.store "Redirection could not be saved.", "La redirection n'a pas pu être enregistrée."

  # app/controllers/admin/resources_controller.rb
  l.store "complete", "fini"
  l.store "File uploaded: ", "Fichier envoyé: "
  l.store "Unable to upload", "impossible d'envoyer"
  l.store "Metadata was successfully updated.", "Les métadonnées ont été mises à jour avec succès."
  l.store "Not all metadata was defined correctly.", "Quelques métadonnées n'ont pas été définies correctement."

  # app/controllers/admin/seo_controller.rb
  l.store "config updated.", "Configuration mise à jour."

  # app/controllers/admin/settings_controller.rb
  l.store "Please review and save the settings before continuing", "SVP vérifiez et enregistrez votre configuration avant de continuer"

  # app/controllers/admin/sidebar_controller.rb
  l.store "It seems something went wrong. Maybe some of your sidebars are actually missing and you should either reinstall them or remove them manually", "Une erreur s'est produite. Un ou plusieurs plugins sont probablement manquants ou en erreur. Peut-être devriez-vous les supprimer ou les réinstaller"

  # app/controllers/admin/tags_controller.rb
  l.store "Tag was successfully updated.", "Le label a été mis à jour avec succès"

  # app/controllers/admin/themes_controller.rb
  l.store "Theme changed successfully", "Le thème a été changé avec succès"

  # app/controllers/admin/users_controller.rb
  l.store "User was successfully created.", "L'utilisateur a été créé avec succès."

  # app/controllers/application_controller.rb
  l.store "Localization.rtl", ""

  # app/controllers/articles_controller.rb
  l.store "No posts found...", "Aucun article n'a été trouvé"

  # app/controllers/grouping_controller.rb
  l.store "page", "page"

  # app/helpers/accounts_helper.rb
  l.store "Create an account", "Créer un compte"
  l.store "I've lost my password", "J'ai perdu mon mot de passe"

  # app/helpers/admin/base_helper.rb
  l.store "Cancel", "Annuler"
  l.store "Store", "Stocker"
  l.store "delete", "supprimer"
  l.store "Delete content", "Supprimer le contenu"
  l.store "Are you sure?", "Êtes-vous certain ?"
  l.store "none", "Aucun"
  l.store "Please select", "Veuillez sélectionner"
  l.store "All categories", "Tous les catégories"
  l.store "All authors", "Tous les auteurs"
  l.store "All published dates", "Tous les dates"
  l.store "There are no %s yet. Why don't you start and create one?", "Il n'y a pas encore de %s, pourquoi ne pas en créer un ? "
  l.store "Save", "Sauver"
  l.store "or", "ou"
  l.store "Short url:", ""
  l.store "Edit", "Éditer"
  l.store "Delete", "Supprimer"
  l.store "Show", "Affichage"
  l.store "Published", "Publié"
  l.store "Draft", ""
  l.store "Withdrawn", "Supprimé"
  l.store "Publication pending", "À publier"
  l.store "Show help on Typo macros", "Afficher l'aide sur les macros Typo"
  l.store "Update settings", "Mettre les paramètres à jour"
  l.store "Back to list", ""
  l.store "Name", "Nom"
  l.store "Description", "Description"
  l.store "Tag", "Label"

  # app/helpers/admin/categories_helper.rb
  l.store "no articles", "aucun article"
  l.store "1 article", "1 article"
  l.store "%d articles", "%d articles"

  # app/helpers/admin/content_helper.rb
  l.store "Destroy this draft", "Supprimer ce brouillon"
  l.store "Article type", ""
  l.store "Default", ""

  # app/helpers/admin/feedback_helper.rb
  l.store "Show conversation", "Afficher le fil"
  l.store "Flag as %s", "Marquer comme %s"

  # app/helpers/application_helper.rb
  l.store "%%d. %%b", ""
  l.store "Are you sure you want to delete this %s?", ""
  l.store "%%a, %%d %%b %%Y %%H:%%M:%%S GMT", ""
  l.store "%d comments", "%d commentaires"
  l.store "no comments", "aucun commentaire"
  l.store "1 comment", "1 commentaire"
  l.store "no trackbacks", "aucun rétrolien"
  l.store "1 trackback", "1 rétrolien"
  l.store "%d trackbacks", "%d rétroliens"
  l.store "at", ""

  # app/models/blog.rb
  l.store "You need a permalink format with an identifier : %%title%%", ""
  l.store "Can't end in .rss or .atom. These are reserved to be used for feed URLs", "Ne peut pas se terminer par .rss ou .atom. Cette extension est réservée aux flux de syndication"

  # app/models/post_type.rb
  l.store "This article type already exists", ""

  # app/views/accounts/login.html.erb
  l.store "Sign in", "S'identifier"
  l.store "Login", "Identifiant"
  l.store "Password", "Mot de passe"
  l.store "Remember me", "Rester connecté"

  # app/views/accounts/recover_password.html.erb
  l.store "Reset my password", "Me renvoyer un mot de passe"
  l.store "Username or email", "Identifiant ou email"
  l.store "Back to login", "S'identifier"

  # app/views/accounts/signup.html.erb
  l.store "Username", "Identifiant"
  l.store "Email", "Email"
  l.store "Signup", "S'inscrire"

  # app/views/admin/cache/index.html.erb
  l.store "To save resources Typo caches content in static files. Cache is cleared each time something gets published. You may however want to clear the cache yourself.", "Afin d'économiser des ressources, Typo génère des fichiers statiques avec votre contenu. Ces fichiers sont supprimés lors d'une nouvelle publication. Vous pouvez cependant les effacer vous même."
  l.store "There are currently %d files in cache for a total amount of %d Kb", "Il y a actuellement %d fichiers en cache pour un total de %d kilo octets."
  l.store "Sweep cache", "Vider le cache"
  l.store "Cache", "Cache"

  # app/views/admin/categories/new.html.erb
  l.store "Categories", "Catégories"
  l.store "Keywords", "Mots clés"
  l.store "Permalink", "Lien permanent"
  l.store "Your category slug. Leave empty if you don't know what to put here", "Le lien permanent de votre catégorie. Laissez le vide si vous ne savez pas quoi mettre"
  l.store "Title", "Titre"

  # app/views/admin/categories/new.js.erb
  l.store "%s Category", "%s catégories"
  l.store "close", "fermer"

  # app/views/admin/content/_attachment.html.erb
  l.store "Remove", "Supprimer"
  l.store "Currently this article has the following resources", "Les fichiers suivants sont actuellement liés à ce billet"
  l.store "You can associate the following resources", "Vous pouvez y lier les fichiers suivants"
  l.store "Really delete attachment", "Voulez-vous vraiment supprimer la pièce jointe"
  l.store "Add another attachment", "Ajouter une autre pièce jointe"

  # app/views/admin/content/_categories.html.erb
  l.store "New Category", "Nouvelle catégorie"

  # app/views/admin/content/_form.html.erb
  l.store "Change", "Modifier"
  l.store "Comments are %s and trackbacks are %s", "Les commentaires sont %s et les rétroliens %s"
  l.store "Publish settings", "Paramètres de publication"
  l.store "Status:", "État"
  l.store "Allow trackbacks", "Autoriser les rétroliens"
  l.store "Allow comments", "Autoriser les commentaires"
  l.store "Visibility", "Visibilité"
  l.store "public", "publique"
  l.store "protected", "protégée"
  l.store "Password:", "Mot de passe"
  l.store "Article filter", "Mise en forme des billets"
  l.store "now", "maintenant"
  l.store "Publish", "Publier"
  l.store "Tags", "Labels"
  l.store "Separate tags with commas. Use double quotes (&quot;) around multi-word tags, e.g. &quot;opera house&quot;.", ""
  l.store "Excerpt", "Extrait"
  l.store "Excerpts are post summaries that show only on your blog homepage and won’t appear on the post itself", "Les résumés vous permettent d'afficher un texte descriptif de votre article à la place de ce dernier sur la page d'accueil de votre blog"
  l.store "Uploads", "Pièces jointes"
  l.store "Save as draft", "Sauver comme brouillon"
  l.store "New article", "Nouvel article"
  l.store "disabled", "désactivés"
  l.store "Markdown with SmartyPants", "Mardown et SmartyPants"
  l.store "Markdown", "Markdown"
  l.store "Texttile", "Texttile"
  l.store "None", "Aucun"
  l.store "SmartyPants", "SmartyPants"
  l.store "Visual", "Éditeur riche"
  l.store "Edit article", "Éditer un article"

  # app/views/admin/content/index.html.erb
  l.store "New Article", "Nouvel article"
  l.store "Search", "Chercher"
  l.store "All articles", "Tous les articles"
  l.store "Drafts", "Brouillons"
  l.store "Filter", "Filtrer"
  l.store "Author", "Auteur"
  l.store "Date", "Date"
  l.store "Feedback", "Commentaires"
  l.store "Manage articles", "Gestion des articles"
  l.store "Select a category", "Catégorie"
  l.store "Select an author", "Auteur"
  l.store "Publication date", "Publié le"

  # app/views/admin/dashboard/_comments.html.erb
  l.store "Latest Comments", "Derniers commentaires"
  l.store "No comments yet", "Aucun commentaire pour l'instant"
  l.store "By", "Par"

  # app/views/admin/dashboard/_inbound.html.erb
  l.store "Inbound links", "Liens entrants"
  l.store "No one made a link to you yet", "Personne n'a fait de lien vers votre blog"
  l.store "made a link to you on", ""
  l.store "You have no internet connection", "Vous n'avez pas de connexion à internet"

  # app/views/admin/dashboard/_overview.html.erb
  l.store "This place gives you a quick overview of what happens on your Typo blog and what you can do. Maybe will you want to %s", "Voici un rapide aperçu de ce que peut faire votre blog Typo. Peux-être voulez vous %s"
  l.store "update your profile or change your password", "mettre votre profil à jour ou changer votre mot de passe"
  l.store "You can also do a bit of design, %s or %s.", "Vous pouvez également faire un peu de personnalisation, %s, %s"
  l.store "change your blog presentation", "changer l'apparence de votre blog"
  l.store "enable plugins", "activer des plugins"
  l.store "If you need help, %s.", "Si vous avez besoin d'aide, vous pouvez %s."
  l.store "You can also %s to customize your Typo blog.", "Vous pouvez également %s pour personnaliser votre blog Typo."
  l.store "write a post", "écrire un article"
  l.store "write a page", "publier une page statique"
  l.store "read our documentation", "consulter notre documentation"
  l.store "download some plugins", "installer des plugins"

  # app/views/admin/dashboard/_popular.html.erb
  l.store "Most popular", "Billets les plus populaires"
  l.store "Nothing to show yet", "Rien à afficher pour l'instant"

  # app/views/admin/dashboard/_posts.html.erb
  l.store "Latest Posts", "Derniers articles"
  l.store "No posts yet, why don't you start and write one", "Vous n'avez encore écrit aucun article, pourquoi ne pas commencer par là"

  # app/views/admin/dashboard/_typo_dev.html.erb
  l.store "Latest news from the Typo development blog", "Dernières nouvelles du blog officiel de Typo"
  l.store "Oh no, nothing new", "Non, rien de nouveau"

  # app/views/admin/dashboard/_welcome.html.erb
  l.store "Welcome back, %s!", "Bienvenue, %s !"
  l.store "%d articles and %d comments were posted since your last connexion", "Depuis votre dernière connexion, %d articles et %d commentaires ont été publiés"
  l.store "You're running Typo %s", "Vous utilisez Typo %s"
  l.store "Content", "Contenu"
  l.store "Total posts:", "Nombre total d'articles :"
  l.store "Your posts:", "Vos articles :"
  l.store "Categories:", ""
  l.store "Total comments:", "Nombre total de commentaires :"
  l.store "Spam comments:", "Nombre total de spam :"
  l.store "In your spam queue:", "En attente de modération :"

  # app/views/admin/feedback/_button.html.erb
  l.store "Select action", "Choisir de..."
  l.store "Delete Checked Items", "Supprimer les commentaires sélectionnés"
  l.store "Delete all spam", "Supprimer tout le spam"
  l.store "Mark Checked Items as Spam", "Marquer ces commentaires comme du spam"
  l.store "Mark Checked Items as Ham", "Valider ces commentaires"
  l.store "Submit", "Envoyer"

  # app/views/admin/feedback/_spam.html.erb
  l.store "This comment by <strong>%s</strong> was flagged as spam, %s?", "Ce commentaire de <strong>%s</strong> a été marqué comme spam, %s ?"

  # app/views/admin/feedback/article.html.erb
  l.store "Comments for %s", "Commentaire sur %s"
  l.store "Add a comment", "Ajouter un commentaire"
  l.store "Status", "État"
  l.store "Comment Author", "Auteur du commentaire"
  l.store "Comment", "Commentaire"
  l.store "Url", "Site"

  # app/views/admin/feedback/index.html.erb
  l.store "All", "Tous"
  l.store "Unapproved comments", "Commentaires non validés"
  l.store "Ham", "Désirable"
  l.store "Spam", "Spam"
  l.store "Presumed ham", "Probablement valide"
  l.store "Presumed spam", "Probablement du spam"
  l.store "Article", "Article"
  l.store "Select all", "Tout sélectionner"

  # app/views/admin/pages/_form.html.erb
  l.store "Online", "En ligne"
  l.store "Page settings", "Paramètres de la page"
  l.store "Permanent link", "Lien permanent"

  # app/views/admin/pages/index.html.erb
  l.store "New Page", "Nouvelle page"
  l.store "Manage pages", "Administrer les pages"
  l.store "All Pages", "Toutes les pages"

  # app/views/admin/post_types/new.html.erb
  l.store "Post Types", "Modèles d'articles"
  l.store "Template name", "Nom du modèle"
  l.store "Typo default post type", "Modèle d'article par défaut"
  l.store "The template name is the filename Typo will look for when calling an article of that type. It should be in your theme under views/articles/template name.html.erb", "Ce modèle est un fichier que Typo cherchera quand il voudra afficher un article de ce type. Il doit se trouver dans views/articles/template nom.html.erb"

  # app/views/admin/profiles/index.html.erb
  l.store "Your profile", "Votre profil"

  # app/views/admin/redirects/new.html.erb
  l.store "Redirects", "Redirections"
  l.store "From", "De"
  l.store "Leave empty to shorten a link", "Laissez vide pour créer un lien court"
  l.store "To", "Vers"

  # app/views/admin/resources/_pages.html.erb
  l.store "Previous page", "Page précédente"
  l.store "Next page", "Page suivante"

  # app/views/admin/resources/_upload.html.erb
  l.store "Upload a File to your Site", "Envoyer un fichier sur votre site"
  l.store "Upload", "Ajouter un fichier joint"
  l.store "Media Library", "Bibliothèque de média"

  # app/views/admin/resources/destroy.html.erb
  l.store "Are you sure you want to delete this file", "Êtes-vous certain de vouloir supprimer ce fichier"
  l.store "Delete this file from the webserver?", "Supprimer complètement ce fichier du site ?"
  l.store "File Uploads", "Ajout de fichiers"

  # app/views/admin/resources/index.html.erb
  l.store "Filename", "Fichier"
  l.store "Content Type", "Type de contenu"
  l.store "File Size", "Taille du fichier"
  l.store "Thumbnail", "Miniatures"
  l.store "Medium size", "Taille moyenne"
  l.store "Original size", "Fichier original"
  l.store "Files", "Fichiers"
  l.store "right-click for link", "clic droit pour le lien"
  l.store "Browse", "Parcourir"

  # app/views/admin/seo/index.html.erb
  l.store "SEO", "Référencement"
  l.store "Global SEO settings", "Options générales"
  l.store "Titles", "Titre des pages"
  l.store "General settings", "Options générales"
  l.store "Use meta keywords", "Utiliser les meta mots-clés"
  l.store "Meta description", "Meta description"
  l.store "Meta keywords", "Meta mots-clés"
  l.store "Use RSS description", "Utilisation de la description RSS"
  l.store "RSS description message", "Message de description du flux RSS"
  l.store "Indexing", "Indexation"
  l.store "Do not index categories", "Ne pas indexer les catégories"
  l.store "Checking this box will add <code>noindex, follow</code> meta tags in every category page, removing them from search engines and preventing duplicate content issues", "Sélectionner cette option ajoutera le métalabel <code>noindex, follow</code> dans toutes les pages de chaque categorie. Cela les enlevera des moteurs de recherches et préviendra ainsi des problèmes de contenu dupliqué."
  l.store "Do not index tags", "Ne pas indexer les labels"
  l.store "Checking this box will add <code>noindex, follow</code> meta tags in every tags page, removing them from search engines and preventing duplicate content issues", "Sélectionner cette option ajoutera le métalabel <code>noindex, follow</code> dans toutes les pages de chaque label. Cela les enlevera des moteurs de recherches et préviendra ainsi des problèmes de contenu dupliqué."
  l.store "Robots.txt", "Robots.txt"
  l.store "You robots.txt file is not writeable. Typo won't be able to write it", "Typo ne peut pas écrire dans votre fichier robots.txt."
  l.store "Use dofollow in comments", "Mettre les commentaires en dofollow"
  l.store "You may want to moderate feedback when turning this on", "Si vous activez cette option, peut-être devriez-vous également activer la modération des commentaires."
  l.store "Use canonical URL", "Utiliser les URL canoniques"
  l.store "Read more about %s", "En savoir plus à propos de %s"
  l.store "Google", "Google"
  l.store "Google Analytics", "Google Analytics"
  l.store "Google Webmaster Tools validation link", "Lien de validation des Google Webmaster Tools."
  l.store "Custom tracking code", "Code de tracking personnalisé"
  l.store "Global settings", "Options générales"
  l.store "This will display", "Cela affichera"
  l.store "at the bottom of each post in the RSS feed", "en bas de chacun de vos articles sur le flux RSS"
  l.store "Here you can add anything you want to appear in your application header, such as analytics service tracking code.", "Ici, vous pouve ajouter tout ce que vous souhaitez voir apparaître dans l'en-tête de votre blog, comme le code de suivi d'un service de statistiques."
  
  # app/views/admin/seo/permalinks.html.erb
  l.store "Typo offers you the ability to create a custom URL structure for your permalinks and archives. This can improve the aesthetics, usability, and forward-compatibility of your links.", "Les exemples ci-dessous vous aideront à démarrerTypo vous offre la possibilité de créer une structure d'URL personnalisée pour vos liens permanents et vos archives. Cela peut vous permettre d'améliorer l'esthétique, l'utilisabilité et la viralité de vos liens."
  l.store "Here are some examples to get you started.", "Les exemples ci-dessous vous aideront à démarrer."
  l.store "Permalink format", "Format des permaliens"
  l.store "Date and title", "Date et titre"
  l.store "Month and title", "Mois et titre"
  l.store "Title only", "Titre uniquement"
  l.store "You can custom your URL structure using the following tags:", "Vous pouvez personnaliser la structure de vos URL à l'aide des tags suivats:"
  l.store "your article slug. <strong>Using this slug is mandatory</strong>.", "le permalien de votre article <strong>ce champ est obligatoire</strong>"
  l.store "your article year of publication.", "L'année de publication de votre article."
  l.store "your article month of publication.", "Le mois de publication de votre article."
  l.store "your article day of publication.", "Le jour de publication de votre article."
  l.store "Permalinks", "Permaliens"
  l.store "Custom", "Personnalisé"

  # app/views/admin/seo/titles.html.erb
  l.store "Title settings", "Paramétrage des titres"
  l.store "Home", "Tableau de bord"
  l.store "Title template", "Titre"
  l.store "Description template", "Description"
  l.store "Articles", "Articles"
  l.store "Pages","Pages"
  l.store "Paginated archives", "Archives paginées"
  l.store "Dated archives", "Archives par date"
  l.store "Author page", "Page d'auteur"
  l.store "Search results", "Résultats de recherche"
  l.store "Help on title settings", "Aide sur le Paramétrage des titres"
  l.store "Replaced with the title of the article/page", "Remplacé par le titre de l'article ou de la page"
  l.store "The blog's name", "Le nom du blog"
  l.store "The blog's tagline / description", "Le sous-titre du blog"
  l.store "Replaced with the post/page excerpt", "Remplacé par l'introduction de l'article ou de la page"
  l.store "Replaced with the article tags (comma separated)", "Remplacé par les tags de l'article (séparés par une virgule)"
  l.store "Replaced with the article categories (comma separated)", "Remplacé par les catégories de l'article (séparées par une virgule)"
  l.store "Replaced with the article/page title", "Remplacé par le titre de l'article ou de la page"
  l.store "Replaced with the category/tag name", "Remplacé par le nom de la catégorie ou du mot-clé"
  l.store "Replaced with the current search phrase", "Remplacé avec le contenu de la recherche"
  l.store "Replaced with the current time", "Remplacé par l'heure actuelle"
  l.store "Replaced with the current date", "Remplacé par la date du jour"
  l.store "Replaced with the current month", "Remplacé par le mois en cours"
  l.store "Replaced with the current year", "Remplacé par l'année en cours"
  l.store "Replaced with the current page number", "Remplacé par le numéro de la page"
  l.store "Replaced by the archive date", "Remplacé par la date de l'archive"
  l.store "These tags can be included in your templates and will be replaced when displaying the page.", "Ces tags peuvent être ajoutés dans le template et seront remplacés lors de l'affichage de la page"

  # app/views/admin/settings/errors.html.erb
  l.store "Error 404", "Erreur 404 (le document demandé n'existe pas)"
  l.store "Message", "Message"
  l.store "Error messages", "Messages d'erreur"

  # app/views/admin/settings/feedback.html.erb
  l.store "Spam protection", "Protection contre le spam"
  l.store "Enable comments by default", "Activer les commentaires par défaut"
  l.store "Enable Trackbacks by default", "Activer les rétroliens par défaut"
  l.store "Enable feedback moderation", "Activer la modération des commentaires"
  l.store "You can enable site wide feedback moderation. If you do so, no comment or trackback will appear on your blog unless you validate it.", "Vous pouvez activez la modération des commentaires sur l'ensemble de votre site. Si vous le faites, aucun commentaire ou rétrolien ne sera publié sans une validation de votre part"
  l.store "Comments filter", "Mise en forme des commentaires"
  l.store "Avatars provider", "Fournisseur d’avatars"
  l.store "Show your email address", "Afficher votre adresse courriel"
  l.store "Enable spam protection", "Activer la protection contre le spam"
  l.store "Enabling spam protection will make Typo compare the IP address of posters as well as the contents of their posts against local and remote blacklists. Good defense against spam bots", "La protection contre le spam permettra à typo de comparer l'adresse IP des commentateurs ainsi que le contenu de leurs commentaires avec une liste noire distante"
  l.store "Akismet Key", "Clé Akismet"
  l.store "Typo can (optionally) use the %s spam-filtering service.  You need to register with Akismet and receive an API key before you can use their service.  If you have an Akismet key, enter it here", "Typo peut utiliser le service de lutte contre le spam %s. Vous devez vous enregistrer afin de pouvoir utiliser les services d'Akismet. Si vous possédez une clé Akismet, ajoutez là ici"
  l.store "Disable trackbacks site-wide", "Désactiver les trackbacks"
  l.store "This setting allows you to disable trackbacks for every article in your blog.  It won't remove existing trackbacks, but it will prevent any further attempt to add a trackback anywhere on your blog.", "Cette option vous permet de désactiver totalement les rétroliens sur votre blog. Ceci ne supprimera pas les rétroliens existants, mais empêchera tout nouveau rétrolien d'être créé"
  l.store "Disable comments after", "Désactiver les commentaires au bout de "
  l.store "days", "jours"
  l.store "Set to 0 to never disable comments", "Mettez cette option à 0 pour ne jamais désactiver les commentaires dans le temps"
  l.store "Max Links", "Nombre de liens maximum"
  l.store "Typo will automatically reject comments and trackbacks which contain over a certain amount of links in them", "Typo rejettera automatiquement les commentaires et les rétroliens contenant un certain nombre de liens"
  l.store "Set to 0 to never reject comments", "Mettez cette option à 0 pour ne jamais rejeter les commentaires"
  l.store "Enable reCaptcha", "Utiliser reCaptcha"
  l.store "Remember to set your reCaptcha keys inside config/initializers/recaptcha.rb", "N'oubliez pas de mettre votre clé d'activation dans config/initializers/recaptcha.rb"
  l.store "Feedback settings", "Paramètres des commentaires"

  # app/views/admin/settings/index.html.erb
  l.store "Your blog", "Votre blog "
  l.store "Blog name", "Titre du blog"
  l.store "Blog subtitle", "Sous-titre du blog"
  l.store "Blog URL", "Adresse du blog"
  l.store "Language", "Langue"
  l.store "Allow users to register", "Autoriser les utilisateurs à s'enregistrer"
  l.store "You can allow users to register to your blog. By default, they will register as contributors, an unpriviledged account level which grant them no rights but own a profile on the site. If you don't want users to register, you can thus add them by yourself in the users part of this admin.", "Vous pouvez permettre aux utilisateurs de s'enregistrer sur votre blog. Par défaut, ils seront enregistrés come contributeurs. Cet utilisateur a un niveau faible sans droit mais qui possède sont propre profile sur le site. Si vous ne voulez pas que les utilisateurs s'enregistrent, vous pouvez les ajouter vous même dans la partie d'administration des utilisateurs."
  l.store "Typo can notify you when new articles or comments are posted", "Typo peut vous alerter quand de nouveaux articles et commentaires sont publiés"
  l.store "Source Email", "Adresse courriel source"
  l.store "Email address used by Typo to send notifications", "Adresse courriel utilisée par Typo pour l'envoi d'alertes"
  l.store "Items to display in admin lists", "Nombre d'éléments à afficher dans les listes"
  l.store "Date format", "Afficher les dates"
  l.store "ago", "il y a"
  l.store "Time format", "Afficher les heures"
  l.store "Publishing options", "Options de publication"
  l.store "Display", "Afficher"
  l.store "articles on my homepage by default", "billet sur ma page d'accueil params par défaut"
  l.store "articles in my news feed by default", "billets dans mon flux RSS par défaut"
  l.store "Show only article excerpt on feed", "Tronquer les articles dans le flux RSS"
  l.store "Feedburner ID", "Identifiant Feedburner"
  l.store "You can use your Google Feedburner account instead of Typo feed URL. To enable this, fill this form with your Feedburner ID.", "Vous pouvez utiliser votre compte Google Feedburner plutôt que votre adresse de flux Typo. Pour l'autoriser, remplissez ce formulaire avec votre identifiant Feedburner."

  # app/views/admin/settings/update_database.html.erb
  l.store "Information", "Informations"
  l.store "Current database version", "Version actuelle de la base"
  l.store "New database version", "Nouvelle version de la base"
  l.store "Your database supports migrations", "Votre base de données supporte la mise à jour"
  l.store "Needed migrations", "Mise à jour nécessaire"
  l.store "You are up to date!", "Vous êtes à jour !"
  l.store "Update database now", "Mettez votre base à jour"
  l.store "may take a moment", "cela peut prendre un moment"
  l.store "Database migration", "Mise à jour de la base de données"
  l.store "yes", "oui"
  l.store "no", "non"

  # app/views/admin/settings/write.html.erb
  l.store "Send trackbacks", "Envoyer des rétroliens"
  l.store "When publishing articles, Typo can send trackbacks to websites that you link to. This should be disabled for private blogs as it will leak non-public information to sites that you're discussing. For public blogs, there's no real point in disabling this.", "Quand vous publiez un billet sur Typo, vous pouvez envoyer un rétrolien aux sites que vous liez. Cette fonctionnalité devrait être désactivée pour les blogs privée puisqu'elle permet de donner des informations à leur sujet à des tiers. Ceci ne s'impose cependant pas pour un blog public."
  l.store "URLs to ping automatically", "Sites à alerter automatiquement"
  l.store "Latitude, Longitude", "Latitude, Longitude"
  l.store "your latitude and longitude", "vos coordonnées géographiques"
  l.store "example", "exemple"
  l.store "Media", "Média"
  l.store "Image thumbnail size", "Taille des vignettes"
  l.store "Image medium size", "Taille des images réduites"
  l.store "Write", "Écrire"

  # app/views/admin/shared/destroy.html.erb
  l.store "Are you sure you want to delete this %s?", "Êtes-vous certain de vouloir supprimer ce %s ?"

  # app/views/admin/sidebar/_publish.html.erb
  l.store "Changes published", "Modifications publiées"

  # app/views/admin/sidebar/_target.html.erb
  l.store "Drag some plugins here to fill your sidebar", "Déplacez des plugins dans cet espace afin de remplir votre sidebar"

  # app/views/admin/sidebar/index.html.erb
  l.store "Drag and drop to change the sidebar items displayed on this blog. To remove items from the sidebar just click 'remove'. Changes are saved immediately, but not activated until you click the 'Publish changes' button", "Glissez / déplacez des éléments pour changer la sidebar de votre blog. Pour supprimer un élément de votre sidebar, cliquez simplement sur 'supprimer'. Les changements sont effectués immédiatement, mais ne seront pas actifs tant que vous n'aurez pas cliqué sur le bouton 'Publier'."
  l.store "Available Items", "Éléments disponibles"
  l.store "You have no plugins installed", "Aucun plugin n'est disponible"
  l.store "Active Sidebar items", "Éléments utilisés"
  l.store "Get more plugins", "Télécharger d'autres plugins"
  l.store "You can download and install sidebar plugins from our official %s. All you have to do is upload the theme directory in your vendor/plugins directory.", ""
  l.store "plugin repository", "catalogue de greffons"
  l.store "Sidebar", "Plugins"
  l.store "Publish changes", "Publier les modifications"
  l.store "Adds sidebar links to any Amazon.com books linked in the body of the page", "Ajoute des liens vers les articles amazon liés dans l'article ou la page"
  l.store "Displays links to monthly archives", "Affiche des liens vers les archives mensuelles"
  l.store "Displays a list of authors ordered by name with links to their articles and profile", "Affiche la liste des auteurs par ordre alphabétique avec un lien vers leur profil"
  l.store "Livesearch", "Recherche dynamique"
  l.store "Adds livesearch to your Typo blog", "Ajoute une recherche dynamique à votre blog"
  l.store "This widget just displays links to Typo main site, this blog's admin and RSS.", "Ce lien affiche juste un lien vers le site de Typo, l'administration de ce blog et son flux RSS"
  l.store "Page", "Page"
  l.store "Show pages for this blog", "Affiche la liste des pages de ce blog"
  l.store "Adds basic search sidebar in your Typo blog", "Ajoute un champ de recherche basic"
  l.store "Static", "Contenu statique"
  l.store "Static content, like links to other sites, advertisements, or blog meta-information", "Contenu statique, comme des liens, de la publicité ou toute autre information"
  l.store "Show most popular tags for this blog", "Affiche les tags les plus populaires"
  l.store "RSS and Atom feeds", "Flux RSS et Atom"
  l.store "XML Syndication", "Syndication XML"
  l.store "remove", "supprimer"

  # app/views/admin/tags/edit.html.erb
  l.store "Editing tag ", ""

  # app/views/admin/tags/index.html.erb
  l.store "Display Name", "Nom affiché"
  l.store "Manage tags", "Labels"

  # app/views/admin/themes/index.html.erb
  l.store "Active theme", "Thème actif"
  l.store "Choose a theme", "Sélectionnez un thème"
  l.store "Use this theme", "Choisir ce thème"

  # app/views/admin/users/_form.html.erb
  l.store "Account settings", "Paramètres du compte"
  l.store "Password", "Mot de passe"
  l.store "Password confirmation", "Confirmation du mot de passe"
  l.store "Profile", "Profil"
  l.store "User's status", "Statut de l'utilisateur"
  l.store "Active", "Actif"
  l.store "Inactive", "Inactif"
  l.store "Profile settings", "Paramètres du profil"
  l.store "Firstname", "Prénom"
  l.store "Lastname", "Nom"
  l.store "Nickname", "Surnom"
  l.store "Editor", "Éditeur"
  l.store "Use simple editor", "Utiliser l'éditeur simplifié"
  l.store "Use visual rich editor", "Utiliser l'éditeur visuel"
  l.store "Notifications", "Notifications"
  l.store "Send notification messages via email", "Envoi de notification des messages par email"
  l.store "Send notification messages when new articles are posted", "Envoi de notification de messages quand de nouveaux articles sont postés"
  l.store "Send notification messages when comments are posted", "Envoi de notification de messages quand des commentaires sont postés"
  l.store "Contact options", "Paramètres de contact"
  l.store "Your site", "Votre site"
  l.store "display URL on public profile", "Afficher votre site sur votre profil public"
  l.store "Your MSN", "Adresse MSN"
  l.store "display MSN ID on public profile", "Afficher votre adresse MSN sur votre profil public"
  l.store "Your Yahoo ID", "Identifiant Yahoo"
  l.store "display Yahoo! ID on public profile", "Afficher votre identifiant Yahoo sur votre profil public"
  l.store "Your Jabber ID", "Votre identifiant Jabber"
  l.store "display Jabber ID on public profile", "Afficher votre identifiant Jabber sur votre profil public"
  l.store "Your AIM id", "Identifiant AIM"
  l.store "display AIM ID on public profile", "Afficher votre identifiant AIM sur votre profil public"
  l.store "Your Twitter username", "Identifiant Twitter"
  l.store "display Twitter on public profile", "Afficher votre identifiant Twitter sur votre profil public"
  l.store "Tell us more about you", "Dites nous en plus à votre sujet"
  l.store "Typo administrator", "Administrateur"
  l.store "Blog publisher", "Rédacteur"
  l.store "Contributor", "Contributeur"

  # app/views/admin/users/edit.html.erb
  l.store "Edit User", "Modifier un utilisateur"

  # app/views/admin/users/index.html.erb
  l.store "New User", "Nouvel utilisateur"
  l.store "Comments", "Commentaires"
  l.store "State", "État"
  l.store "%s user", "%s"
  l.store "Users", "Utilisateurs"
  l.store "Manage users", "Gérer les utilisateurs"

  # app/views/admin/users/new.html.erb
  l.store "Add User", "Ajouter un utilisateur"

  # app/views/articles/_article.html.erb
  l.store "Posted by", "Publié par"

  # app/views/articles/_article_excerpt.html.erb
  l.store "Continue reading", "Lire plus"

  # app/views/articles/_comment_failed.html.erb
  l.store "Oops, something wrong happened, the comment could not be saved", "Oops, quelque chose s'est mal déroulé. Votre commentaire n'a donc pu être enregistré."

  # app/views/articles/_comment_form.html.erb
  l.store "Your name", "Votre nom "
  l.store "Your email", "Votre courriel"
  l.store "Your message", "Votre commentaire"
  l.store "Comment Markup Help", "Aide sur le balisage des commentaires"
  l.store "Preview comment", "Prévisualiser le commentaire"
  l.store "leave url/email", "laissez votre url/courriel"

  # app/views/articles/_comment_list.html.erb
  l.store "No comments", "Pas de commentaires"

  # app/views/articles/archives.html.erb
  l.store "No articles found", "Aucun article ne correspond à la recherche"
  l.store "posted in", "publié dans"

  # app/views/articles/comment_preview.html.erb
  l.store "is about to say", "va dire"

  # app/views/articles/groupings.html.erb
  l.store "There are", "Il y a"

  # app/views/articles/read.html.erb
  l.store "Leave a response", "Réagir à ce billet"
  l.store "Trackbacks", "Rétroliens"
  l.store "Use the following link to trackback from your own site", "Utilisez le lien ci-dessous pour envoyer un rétrolien depuis votre site"
  l.store "RSS feed for this post", "Flux RSS de ce billet"
  l.store "trackback uri", "URL de rétrolien"
  l.store "Comments are disabled", "Les commentaires sont désactivés"
  l.store "Trackbacks are disabled", "Les rétroliens sont désactivés"

  # app/views/authors/show.html.erb
  l.store "Web site:", "Site web:"
  l.store "MSN:", "MSN :"
  l.store "Yahoo:", "Yahoo :"
  l.store "Jabber:", "Jabber :"
  l.store "AIM:", "AIM :"
  l.store "Twitter:", "Twitter :"
  l.store "About %s", "À propos de %s"
  l.store "This author has not published any article yet", "Cet utilisateur n'a publié aucun article"

  # app/views/comments/_comment.html.erb
  l.store "said", "a dit"
  l.store "This comment has been flagged for moderator approval.  It won't appear on this blog until the author approves it", "Ce commentaire a été envoyé à la modération. Il ne sera affiché qu'une fois approuvé par un modérateur"

  # app/views/comments/show.html.erb
  l.store "This comment has been flagged for moderator approval.", "Ce commentaire est en attente de modération"

  # app/views/layouts/administration.html.erb
  l.store "Logged in as %s", "Salutations, %s"
  l.store "%s &raquo;", "%s &raquo;"
  l.store "Help", "Aide"
  l.store "Documentation", "Documentation"
  l.store "Report a bug", "Déclarer un bug"
  l.store "In page plugins", "Plugins"
  l.store "Sidebar plugins", "Widgets"
  l.store "is proudly powered by", "tourne fièrement sous"
  l.store "Dashboard", "Tableau de bord"

  # app/views/setup/index.html.erb
  l.store "Welcome", "Bienvenue"
  l.store "Welcome to your %s blog setup. Just fill in your blog title and your email, and Typo will take care of everything else", ""

  # app/views/shared/_confirm.html.erb
  l.store "Congratulations!", "Félicitations !"
  l.store "You have successfully signed up", "Vous vous êtes inscrit avec succès"
  l.store "<strong>Login:</strong> %s", "<strong>Identifiant&nbsp;:</strong> %s"
  l.store "<strong>Password:</strong> %s", "<strong>Mot de passe&nbsp;:</strong> %s"
  l.store "Don't lose the mail sent at %s or you won't be able to login anymore", "Ne perdez pas l'email que nous venons de vous envoyer à l'adresse %s ou vous ne pourrez plus vous connecter à l'application"
  l.store "Proceed to %s", "Allez sur %s"
  l.store "admin", "l'administration"

  # app/views/shared/_search.html.erb
  l.store "Live Search", "Recherche instantanée"

  # themes/bootstrap/helpers/theme_helper.rb
  l.store "%d comment", "%d commentaires"

  # themes/bootstrap/views/articles/_article.html.erb
  l.store "Published on", ""
  l.store "under", ""

  # themes/bootstrap/views/articles/_comment_form.html.erb
  l.store "Email address", "Adresse mail"
  l.store "Your website", "Votre site"
  l.store "comment", "commentaire"

  # themes/bootstrap/views/articles/read.html.erb
  l.store "If you liked this article you can %s", "Si vous avez aimé cet article, vous pouvez %s"
  l.store "add me to Twitter", "me suivre sur Twitter"
  l.store "Trackbacks for", "Rétroliens pour"

  # themes/bootstrap/views/articles/search.html.erb
  l.store "Search results for:", "Résultats de la recherche sur&nbsp;:"

  # themes/bootstrap/views/categories/index.html.erb
  l.store "Read all articles in %s", "Tous les articles dans %s sont lus"

  # themes/bootstrap/views/categories/show.html.erb
  l.store "Previous", "Précédent"
  l.store "Next", "Suivant"

  # themes/dirtylicious/views/articles/_comment_form.html.erb
  l.store "Leave a comment", "laisser un commentaire"

  # themes/dirtylicious/views/layouts/default.html.erb
  l.store "About", "À propos de"
  l.store "Designed by %s ported to typo by %s ", "Design par %s porté sous Typo par %s"
  l.store "Powered by %s", "Propulsé par %s"

  # themes/scribbish/views/articles/_article.html.erb
  l.store "Meta", "Méta"
  l.store "permalink", "lien permanent"

  # themes/scribbish/views/articles/_comment_form.html.erb
  l.store "Textile enabled", "Textile activé"
  l.store "Markdown enabled", "Markdown activé"

  # themes/scribbish/views/layouts/default.html.erb
  l.store "styled with %s", "stylé avec %s"

  # themes/standard_issue/views/articles/_article.html.erb
  l.store "This entry was posted on %s", "Ce billet a été posté le %s"
  l.store "and %s", "et %s"
  l.store "You can follow any response to this entry through the %s", "Vous pouvez suivre la discussion autour de cet article via le %s"
  l.store "Atom feed", "flux Atom"
  l.store "You can leave a %s", "Vous pouvez déposer un %s"
  l.store "or a %s from your own site", "ou un %s depuis votre site"
  l.store "Read full article", "Lire l'article complet"
  l.store "trackback", "rétrolien"

  # themes/standard_issue/views/articles/_comment_form.html.erb
  l.store "Name %s", "Votre nom %s"
  l.store "never displayed", "jamais affiché"
  l.store "Website", "Votre site"
  l.store "required", "obligatoire"

  # themes/true-blue-3/helpers/theme_helper.rb
  l.store "You are here: ", "Vous êtes ici&nbsp;: "

  # themes/true-blue-3/views/articles/_article.html.erb
  l.store "%%a, %%d %%b %%Y %%H:%%M", ""

  # themes/typographic/views/layouts/default.html.erb
  l.store "Designed by %s ", "Design par %s"

  # vendor/plugins/archives_sidebar/app/views/archives_sidebar/_content.html.erb
  l.store "Archives", "Archives"

  # vendor/plugins/authors_sidebar/app/views/authors_sidebar/_content.html.erb
  l.store "Authors", "Auteurs"

  # vendor/plugins/meta_sidebar/app/views/meta_sidebar/_content.html.erb
  l.store "RSS Feed", ""
  l.store "Admin", ""
  l.store "Powered by Typo", ""

  # vendor/plugins/xml_sidebar/app/views/xml_sidebar/_content.html.erb
  l.store "Syndicate", "Suivre ce blog"
  l.store "Category %s", "Catégorie %s"
  l.store "Tag %s", "Label %s"

  # Obsolete translations
  l.store " made a link to you saying ", " a fait un lien vers vous disant "
  l.store "%d posts", "%d articles"
  l.store "%s", ""
  l.store "%s Post Type", ""
  l.store "%s Redirect", ""
  l.store "(Done)", "(Terminé)"
  l.store "(leave url/email &#187;)", "(laissez votre url/email &#187;)"
  l.store ", Articles for ", ", articles pour "
  l.store "1 post", "1 article"
  l.store "Add MetaData", "Ajouter des métadonnées"
  l.store "All comments", "Tous les commentaires"
  l.store "Allow non-ajax comments", "Autoriser l'envoi de commentaires sans AJAX"
  l.store "Apr", "avr"
  l.store "April", "avril"
  l.store "Archives for", "Archives de"
  l.store "Archives for ", "Archives de"
  l.store "Are you sure you want to delete the Article Type ", ""
  l.store "Are you sure you want to delete the category ", "Êtes vous certain de vouloir supprimer cette catégorie "
  l.store "Are you sure you want to delete the page", "Voulez-vous vraiment effacer cette page"
  l.store "Are you sure you want to delete the redirection ", ""
  l.store "Are you sure you want to delete the tag", "Êtes-vous certain de vouloir supprimer le label"
  l.store "Are you sure you want to delete this %s", "Êtes-vous certain de vouloir supprimer cet %s"
  l.store "Are you sure you want to delete this item?", "Êtes vous certain de vouloir supprimer cette entrée ?"
  l.store "Article Types", "Modèles d'articles"
  l.store "Aug", "août"
  l.store "August", "août"
  l.store "Back to ", "Revenir à "
  l.store "Back to overview", "Revenir à la liste"
  l.store "Back to tags list", "Revenir à la liste des labels"
  l.store "Blacklist Pattern could not be created.", "Cette entrée n'a pas pu être créée"
  l.store "Blacklist Pattern could not be updated.", "Cette entrée n'a pas pu être mise à jour"
  l.store "Blacklist Pattern was successfully created.", "Cette entrée a été créée avec succès"
  l.store "Blacklist Patterns", "Liste noire"
  l.store "BlacklistPattern was successfully updated.", "Cette entrée a été mise à jour avec succès"
  l.store "Blog settings", "Configuration du blog"
  l.store "By %s on %s", "Par %s le %s"
  l.store "Category", "Catégorie"
  l.store "Comment Excerpt", "Extrait du commentaire"
  l.store "Comments for", "Commentaires pour"
  l.store "Comments for %s (%s)", "Commentaires sur l'article %s (%s)"
  l.store "Confirm Classification of Checked Items", "Confirmer la classification des commentaires"
  l.store "Contact options", "Options de contact"
  l.store "Content Type was successfully updated.", "Le type du contenu a été mis à jour avec succès."
  l.store "Continue reading...", "Lire la suite..."
  l.store "Copyright Information", "Informations sur le copyright"
  l.store "Dec", "déc"
  l.store "December", "décembre"
  l.store "Delete this Post Type", ""
  l.store "Delete this article", "Supprimer ce billet"
  l.store "Delete this category", "Supprimer cette catégorie"
  l.store "Delete this feedback", ""
  l.store "Delete this page", "Supprimer cette page"
  l.store "Delete this redirection", ""
  l.store "Delete this tag", "Supprimer ce label"
  l.store "Display name", "Nom affiché sur le site"
  l.store "Duration", "Durée"
  l.store "Edit Metadata", "Modifier les métadonnées"
  l.store "Editing ", "Vous éditez"
  l.store "Editing pattern", "Éditer un motif"
  l.store "Error occurred while updating Content Type.", "Une erreur est survenue lors de la mise à jour du type du contenu."
  l.store "Explicit", "Contenu explicite"
  l.store "Feb", "fév"
  l.store "February", "février"
  l.store "Feedback for", "Commentaires sur"
  l.store "File", "Fichier"
  l.store "File does not exist", ""
  l.store "File saved successfully", "Le fichier a été enregistré avec succès"
  l.store "Format of permalink", "Format des liens permanents"
  l.store "Fri", "Ven"
  l.store "Friday", "Vendredi"
  l.store "Get more themes", "Téléchargez d'autres thèmes"
  l.store "Google verification link", "Lien Google pour vérification"
  l.store "HTML was cleared", "le cache a est vidé"
  l.store "Ham?", "Désirable?"
  l.store "IP", "Adresse IP"
  l.store "If you are reading this article elsewhere than", "Si vous lisez cet article ailleurs que sur"
  l.store "If you need help, %s. You can also %s to customize your Typo blog.", "Si vous avez besoin d'aide, n'hésitez pas à %s. Vous pouvez aussi %s afin de personnaliser votre blog sous Typo"
  l.store "Images", "Images"
  l.store "Jan", "jan"
  l.store "January", "janvier"
  l.store "Jul", "juil"
  l.store "July", "juillet"
  l.store "Jun", "juin"
  l.store "June", "juin"
  l.store "Just Marked As Ham", "Marqué comme désirable"
  l.store "Just Marked As Spam", "Marqué comme spam"
  l.store "Just Presumed Ham", "Marqué commme supposé désirable"
  l.store "Key Words", "Mots clé"
  l.store "Latest posts", "Derniers articles"
  l.store "Layout", ""
  l.store "Limit to ham", "Uniquement les commentaires validés"
  l.store "Limit to presumed ham", ""
  l.store "Limit to presumed spam", ""
  l.store "Limit to spam", "N'afficher que le spam"
  l.store "Login %s", "Identifiant %s"
  l.store "Mandatory", "Obligatoire"
  l.store "Mar", "mars"
  l.store "March", "mars"
  l.store "May", "mai"
  l.store "Metadata", "Métadonnées"
  l.store "Metadata was successfully removed.", "Les métadonnées ont été supprimées avec succès."
  l.store "Mon", "Lun"
  l.store "Monday", "Lundi"
  l.store "New Redirect", ""
  l.store "No", "Non"
  l.store "Not published by Apple", "Donnée non publiée par Apple"
  l.store "Notification", "Notifications"
  l.store "Nov", "nov"
  l.store "November", "novembre"
  l.store "Oct", "oct"
  l.store "October", "octobre"
  l.store "Optional Name", "Nom facultatif"
  l.store "Options", "Options"
  l.store "Original article writen by", "Article original écrit par"
  l.store "Password %s", "Mot de passe %"
  l.store "Pattern", "Motif"
  l.store "Personal information", "Informations personnelles"
  l.store "Podcasts", "Podcasts"
  l.store "Post settings", "Paramètres de l'article"
  l.store "Posted in", "Publié sous"
  l.store "Posts", "Articles"
  l.store "Proceed to", "Aller sur"
  l.store "Publish at", "Publié le"
  l.store "Read", "Lire"
  l.store "Read more", "Lire la suite"
  l.store "Really delete user", "Vraiment supprimer cet utilisateur"
  l.store "Recent comments", "Derniers commentaires"
  l.store "Recent trackbacks", "Derniers rétroliens"
  l.store "Regex", "Expression rationnelle"
  l.store "Remove iTunes Metadata", "Supprimer les méta données iTunes"
  l.store "Reorder", "Trier"
  l.store "Resource MetaData", "Méta données des pièces jointes"
  l.store "Sat", "Sam"
  l.store "Saturday", "Samedi"
  l.store "Search Comments and Trackbacks that contain", "Chercher les commentaires et les rétroliens contenant"
  l.store "Search Engine Optimisation", "Optimisation pour les moteurs de recherche"
  l.store "Search Engine Optimization", "Optimisation pour les moteurs de recherche"
  l.store "Search articles that contain ...", "Chercher les articles contenant ..."
  l.store "Searching", "Recherche en cours"
  l.store "Sep", "sep"
  l.store "September", "septembre"
  l.store "Set iTunes metadata for this enclosure", "Ajouter des métadonnées iTunes pour cette pièce jointe"
  l.store "Setting for channel", "Options des canaux"
  l.store "Settings", "Configuration"
  l.store "Show content", "Afficher le contenu"
  l.store "Sorry the theme catalogue is not available", "Désolé le catalogue de thèmes n'est pas disponible"
  l.store "Sort alphabetically", "Trier par ordre alphabétique"
  l.store "Spam?", "Spam?"
  l.store "Statistics", "Statistiques"
  l.store "String", "Chaîne de caractères"
  l.store "Stylesheets", ""
  l.store "Subtitle", "Sous-titre"
  l.store "Summary", "Résumé"
  l.store "Sun", "Dim"
  l.store "Sunday", "Dimanche"
  l.store "System information", "Informations systèmes"
  l.store "The below settings act as defaults when you choose to publish an enclosure with iTunes metadata", "Les options suivantes seront ajoutées automatiquement quand vous publierez des enclosures contenant des métadonnées iTunes"
  l.store "Theme catalogue", "Catalogue de thèmes"
  l.store "Theme editor", "Éditeur de thèmes"
  l.store "There is no %s yet. Why don't you start and create one?", "Il n'y a aucun %s, pourquoi n'en créeriez-vous pas ?"
  l.store "Thu", "Jeu"
  l.store "Thursday", "Jeudi"
  l.store "To install a theme you  just need to upload the theme folder into your themes directory. Once a theme is uploaded, you should see it on this page.", "Pour installer votre thèmes, il suffit de l'uploader dans le dossier themes de votre projet."
  l.store "Tue", "Mar"
  l.store "Tuesday", "Mardi"
  l.store "Type", "Type"
  l.store "Typogarden", "Typogarden"
  l.store "Unable to write file", "Impossible d'écrire le fichier"
  l.store "Unclassified", "Non vérifié"
  l.store "Unpublished", "Non publié"
  l.store "Wed", "Mer"
  l.store "Wednesday", "Mercredi"
  l.store "Yes", "Oui"
  l.store "You are not authorized to open this file", "Vous n'êtes pas autorisé à ouvrir ce fichier"
  l.store "You can download third party themes from officially supported %s ", "Vous pouvez télécharger des thèmes officiellement supportés sur %s "
  l.store "You can optionally disable non-Ajax comments. Typo will always use Ajax for comment submission if Javascript is enabled, so non-Ajax comments are either from spammers or users without Javascript.", "Vous pouvez désactiver l'envoi des commentaires en AJAX. Typo utilisera toujours l'AJAX par défaut pour envoyer les commentaires si Javascript est activé. Désactiver l'AJAX sert donc aux gens ne disposant pas de Javascript et aux robots spammeurs"
  l.store "You need a permalink format with an identifier : %%month%%, %%year%%, %%day%%, %%title%%", "Vous devez spécifier un identifiant : %%month%%, %%year%%, %%day%%, %%title%%"
  l.store "Your robots.txt file is not writeable. Typo won't be able to write it", "Votre fichier Robots.txt n'est pas écrivable. Typo ne peux donc pas y écrire."
  l.store "add a comment", "Ajouter un commentaire"
  l.store "add new", "nouveau"
  l.store "and published on", "et publié sur"
  l.store "by %s on %s", "par %s sur %s"
  l.store "da_DK", "Danois"
  l.store "de_DE", "Allemand"
  l.store "direct link to this article", "lien direct vers cet article"
  l.store "en_US", "Anglais (Américain)"
  l.store "enabled", "activés"
  l.store "es_MX", "Espagnol (Mexicain)"
  l.store "everything about", "tout sur"
  l.store "example", "par exemple"
  l.store "for", "pour"
  l.store "fr_FR", "Français"
  l.store "from %s to %s", ""
  l.store "he_IL", "Hébreux"
  l.store "it has been illegally reproduced and without proper authorization", "c'est qu'il a été reproduit illégalement et sans autorisation"
  l.store "it_IT", "Italien"
  l.store "ja_JP", "Japonais"
  l.store "later", "plus tard"
  l.store "later:", "plus tard"
  l.store "Log out", "déconnexion"
  l.store "lt_LT", "Lituanien"
  l.store "nl_NL", "Hollandais"
  l.store "no posts", "aucun article"
  l.store "pl_PL", "Polonais"
  l.store "published", "publié"
  l.store "ro_RO", "Roumain"
  l.store "save", "Sauver"
  l.store "seperate with spaces", "séparez-les par des espaces"
  l.store "show", "afficher"
  l.store "theme catalogue", "catalogue de thèmes"
  l.store "unpublished", "hors ligne"
  l.store "your blog", "votre blog"
  l.store "your latitude and longitude", "votre latitude et votre longitude"
  l.store "zh_TW", "Chinois"
end
