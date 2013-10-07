# coding: utf-8
Localization.define("ru_RU") do |l|
  # Available languages
  l.store "en_US", "Английский (американский)"
  l.store "ru_RU", "Русский"

  # app/controllers/accounts_controller.rb
  l.store "Login successful", "Вход успешный"
  l.store "Login unsuccessful", "Не получилось зайти"
  l.store "An email has been successfully sent to your address with your new password", "Письмо с паролем было выслано на ваш адрес"
  l.store "Oops, something wrong just happened", "Упс, произошло что-то нехорошее"
  l.store "Successfully logged out", "Вы успешно вышли"
  l.store "login", "логин"
  l.store "signup", "войти"
  l.store "Recover your password", "Восстановление пароля"

  # app/helpers/admin/base_helper.rb
  l.store "Cancel", "Отменить"
  l.store "Delete", "Удалить"
  l.store "delete", "удалить"
  l.store "Are you sure?", "Вы уверены?"
  l.store "All categories", "Все категории"
  l.store "All authors", "Все авторы"
  l.store "Save", "Сохранить"
  l.store "Short url:", "Короткий URL:"
  l.store "Edit", "Редактировать"
  l.store "Published", "Опубликован"
  l.store "Unpublished", "Не опубликован"
  l.store "There are no %s yet. Why don't you start and create one?", "Ничего нет. Почему бы не начать и не добавить?" # XXX
  l.store "or", "или"
  l.store "Save", "Сохранить"
  l.store "Short url:", "Короткий URL:"
  l.store "Edit", "Редактировать"
  l.store "Show", "Показать"
  l.store "Published", "Опубликован"
  l.store "Unpublished", "Неопубликован"
  l.store "Show help on Publify macros", "Показать помощь по Publify-макросам"
  l.store "Update settings", "Обновить настройки"
  l.store "Back to list", "Назад к списку"
  l.store "Tag", "Тег"

  # app/helpers/admin/categories_helper.rb
  l.store "no articles", "нет постов"
  l.store "1 article", "1 пост"
  l.store "%d articles", "постов: %d"

  # app/helpers/admin/content_helper.rb
  l.store "Destroy this draft", "Удалить этот черновик"

  # app/helpers/application_helper.rb
  l.store "%%d. %%b", ""
  l.store "Are you sure you want to delete this %s?", "Вы уверены, что хотите удалить %s?"
  l.store "%%a, %%d %%b %%Y %%H:%%M:%%S GMT", ""
  l.store "%d comments", "комментариев: %d"
  l.store "no comments", "нет комментариев"
  l.store "1 comment", "1 комментарий"
  l.store "at", "в"

  # app/models/article.rb
  l.store "Original article writen by", "Автор оригинальной статьи —"
  l.store "and published on", " — и она опубликована"
  l.store "direct link to this article", "прямая ссылка на эту статью"
  l.store "If you are reading this article elsewhere than", "Если вы увидите эту статью где-то еще кроме"
  l.store "it has been illegally reproduced and without proper authorization", " — это может быть незаконным воспроизведением без разрешения"


  # app/views/accounts/login.html.erb
  l.store "password", "пароль"
  l.store "Submit", "Войти"

  # app/views/admin/categories/_categories.html.erb
  l.store "Sort alphabetically", "Сортировать по алфавиту"

  # app/views/admin/categories/destroy.html.erb
  l.store "Are you sure you want to delete the category ", "Вы уверены, что хотите удалитьэту категорию?"
  l.store "Delete this category", "Удалить эту категорию"

  # app/views/admin/categories/index.html.erb

  # app/views/admin/content/_form.html.erb
  l.store "Publish settings", "Настройки публикации"
  l.store "Password:", "Пароль"
  l.store "Publish", "Опубликовать"
  l.store "Tags", "Теги"
  l.store "Excerpt", "Выдержка"
  l.store "Excerpts are post summaries that show only on your blog homepage and won’t appear on the post itself", "Выдержка — это анонс поста, который будет отображаться только на главной странице, и не будет присутствовать при просмотре полного поста"
  l.store "Uploads", "Загрузки"
  l.store "Post settings", "Настройки поста"
  l.store "Publish at", "Опубликован"
  l.store "Save as draft", "Сохранить как черновик"
  l.store "disabled", "выключены"
  l.store "Markdown with SmartyPants", "Markdown со SmartyPants"
  l.store "Markdown", "Markdown"
  l.store "Texttile", "Textile" # XXX: ttile?
  l.store "None", "Нет"
  l.store "SmartyPants", "SmartyPants"
  l.store "Visual", "Визуально"
  l.store "Edit article", "Редактировать пост"

  # app/views/admin/content/index.html.erb
  l.store "New Article", "Новый пост"
  l.store "Search", "Найти"
  l.store "Filter", "Фильтровать"
  l.store "Author", "Автор"
  l.store "Date", "Дата"
  l.store "Feedback", "Комментарии"
  l.store "All Articles", "Все посты"
  l.store "Manage articles", "Управление постами"
  l.store "Select a category", "Выбрать категорию"
  l.store "Select an author", "Выбрать автора"
  l.store "Publication date", "Дата публикации"

  # app/views/admin/dashboard/_comments.html.erb
  l.store "For security reasons, you should restart your Publify application. Enjoy your blogging experience.", "По соображениям безопасности вам следует перезапустить ваше Publify-приложение. Приятного блогерства!"
  l.store "Latest Comments", "Последние комментарии"
  l.store "No comments yet", "Пока нет комментариев"

  # app/views/admin/dashboard/_overview.html.erb
  l.store "This place gives you a quick overview of what happens on your Publify blog and what you can do. Maybe will you want to %s, %s or %s.", "Здесь можно посмотреть, что происходит в вашем Publify-блоге и что в нем можно сделать. Возможно, вы хотели бы %s, %s или %s."
  l.store "update your profile or change your password", "изменить свой профиль или поменять пароль"
  l.store "You can also do a bit of design, %s or %s.", "Вы также можете изменить дизайн, %s или %s"
  l.store "change your blog presentation", "изменив тему блога"
  l.store "enable plugins", "включив плагины"
  l.store "If you need help, %s. You can also browse our %s or %s to customize your Publify blog.", "Если вам нужна помощь, %s. Вы также можете просмотреть %s или %s для изменения своего Publify-блога." # XXX: wtf?
  l.store "write a post", "написать пост"
  l.store "write a page", "создать страницу"
  l.store "read our documentation", "ознакомьтесь с документацией"
  l.store "theme catalogue", "каталог тем"
  l.store "download some plugins", "загрузить плагины"

  # app/views/admin/dashboard/_posts.html.erb
  l.store "Latest Posts", "Последние посты"
  l.store "No posts yet, why don't you start and write one", "Пока нет постов. Почему бы не начать и не написать один"

  # app/views/admin/dashboard/_welcome.html.erb
  l.store "Welcome back, %s!", "Добро пожаловать снова, %s!"
  l.store "%d articles and %d comments were posted since your last connexion", "%d постов и %d комментариев получено с вашего последнего посещения" # XXX: connexion?
  l.store "You're running Publify %s", "Работает Publify %s"
  l.store "Total posts : %d", "Всего постов: %d"
  l.store "Your posts : %d", "Ваших постов: %d"
  l.store "Total comments : %d", "Всего комментариев: %d"
  l.store "Spam comments : %d", "Спама: %d"

  # app/views/admin/redirects/destroy.html.erb
  l.store "Are you sure you want to delete the redirection ", "Вы уверены, что хотите удалить это перенаправление?"
  l.store "from %s to %s", "от %s на %s"
  l.store "Delete this redirection", "Удалить это перенаправление"
  l.store "Redirects", "Перенаправления"

  # app/views/admin/profiles/index.html.erb
  l.store "Your profile", "Ваш профиль"

  # app/views/admin/seo/index.html.erb
  l.store "Titles", "Заголовки"
  l.store "General settings", "Основные настройки"

  # app/views/admin/seo/permalinks.html.erb
  l.store "Permalinks", "Постоянные ссылки"

  # app/views/admin/settings/index.html.erb
  l.store "Your blog", "Ваш блог"
  l.store "Blog name", "Имя блога"
  l.store "Blog subtitle", "Подзаголовок блога"
  l.store "Blog URL", "URL блога"
  l.store "Language", "Язык"
  l.store "Allow users to register", "Разрешить пользователям регистрироваться"
  l.store "You can allow users to register to your blog. By default, they will register as contributors, an unpriviledged account level which grant them no rights but own a profile on the site. If you don't want users to register, you can thus add them by yourself in the users part of this admin.", "Вы можете разрешить пользователям регистрироваться в вашем блоге. По умолчанию они регистрируются как контрибьюторы, то есть получают непривелигированные учетные записи, которые не имеют никаких прав — только профиль на сайте. Если вы не хотите давать пользователям возможность регистрироваться, вы можете добавлять их вручную в разделе «пользователи» панели администратора"
  l.store "Items to display in admin lists", "Элементы для отображения в администраторских списках"
  l.store "Show full article on feed", "Показывать полные версии статей в ленте"
  l.store "Feedburner ID", ""
  l.store "General settings", "Главные настройки"
  l.store "You can use your Google Feedburner account instead of Publify feed URL. To enable this, fill this form with your Feedburner ID.", "Вы можете использовать учетную запись сервиса Google Feedburner вместо использования URL’а, которые дает Publify. Для этого введите в форму свой Feedburner ID."

  # app/views/articles/_comment_box.html.erb
  l.store "Your name", "Ваше имя"
  l.store "Your email", "Ваш email"
  l.store "Your message", "Ваше сообщение"
  l.store "Comment Markup Help", "Помощь по разметке"
  l.store "Preview comment", "Просмотреть комментарий"

  # app/views/articles/_comment_failed.html.erb
  l.store "Oops, something wrong happened, the comment could not be saved", "Ох! Что-то случилось, и комментарий не сохранился"

  # app/views/articles/_comment_form.html.erb
  l.store "Your name", "Ваше имя"
  l.store "Your email", "Ваш email"
  l.store "Your message", "Ваше сообщение"
  l.store "Preview comment", "Предпросмотр комментария"
  l.store "Comment", "Отправить комментарий"

  # app/views/articles/_comment_list.html.erb
  l.store "No comments", "Нет комментариев"

  # app/views/articles/read.html.erb
  l.store "Leave a response", "Оставить отзыв"
  l.store "Comments are disabled", "Комментарии выключены"

  # app/views/authors/show.html.erb
  l.store "Web site:", "Веб-сайт:"
  l.store "MSN:", ""
  l.store "Yahoo:", ""
  l.store "Jabber:", ""
  l.store "AIM:", ""
  l.store "Twitter:", ""
  l.store "About %s", "Об авторе %s"
  l.store "This author has not published any article yet", "Этот автор еще ничего не публиковал"

  # themes/true-blue-3/views/articles/_article.html.erb
  l.store "Published on", "Опубликовано"

  # themes/true-blue-3/views/articles/_comment_form.html.erb
  l.store "Email address", "Электронная почта"
  l.store "Your website", "Веб-сайт"
end
