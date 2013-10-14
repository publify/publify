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
  l.store "Delete", "Удалить"
  l.store "delete", "удалить"
  l.store "Are you sure?", "Вы уверены?"
  l.store "All categories", "Все категории"
  l.store "All authors", "Все авторы"
  l.store "Save", "Сохранить"
  l.store "Short url:", "Короткий URL:"
  l.store "Edit", "Редактировать"
  l.store "Unpublished", "Не опубликован"
  l.store "There are no %s yet. Why don't you start and create one?", "Ничего нет. Почему бы не начать и не добавить?" # XXX
  l.store "or", "или"
  l.store "Save", "Сохранить"
  l.store "Short url:", "Короткий URL:"
  l.store "Edit", "Редактировать"
  l.store "Show", "Показать"
  l.store "Unpublished", "Неопубликован"
  l.store "Show help on Publify macros", "Показать помощь по Publify-макросам"
  l.store "Update settings", "Обновить настройки"
  l.store "Back to list", "Назад к списку"
  l.store "Tag", "Тег"

  # app/helpers/admin/content_helper.rb
  l.store "Destroy this draft", "Удалить этот черновик"
  l.store "Are you sure you want to delete this %s?", "Вы уверены, что хотите удалить %s?"

  # app/models/article.rb
  l.store "Original article writen by", "Автор оригинальной статьи —"
  l.store "and published on", " — и она опубликована"
  l.store "direct link to this article", "прямая ссылка на эту статью"
  l.store "If you are reading this article elsewhere than", "Если вы увидите эту статью где-то еще кроме"
  l.store "it has been illegally reproduced and without proper authorization", " — это может быть незаконным воспроизведением без разрешения"


  # app/views/accounts/login.html.erb
  l.store "password", "пароль"
  l.store "Submit", "Войти"

  l.store "Sort alphabetically", "Сортировать по алфавиту"

  l.store "Are you sure you want to delete the category ", "Вы уверены, что хотите удалитьэту категорию?"
  l.store "Delete this category", "Удалить эту категорию"

  # app/views/admin/content/_form.html.erb
  l.store "Uploads", "Загрузки"
  l.store "Post settings", "Настройки поста"
  l.store "Publish at", "Опубликован"
  l.store "disabled", "выключены"
  l.store "Markdown with SmartyPants", "Markdown со SmartyPants"
  l.store "None", "Нет"
  l.store "SmartyPants", "SmartyPants"
  l.store "Visual", "Визуально"
  l.store "Edit article", "Редактировать пост"

  l.store "Author", "Автор"
  l.store "Date", "Дата"

  # app/views/admin/dashboard/_comments.html.erb
  l.store "For security reasons, you should restart your Publify application. Enjoy your blogging experience.", "По соображениям безопасности вам следует перезапустить ваше Publify-приложение. Приятного блогерства!"
  l.store "Latest Comments", "Последние комментарии"

  # app/views/admin/dashboard/_posts.html.erb
  l.store "Latest Posts", "Последние посты"
  l.store "No posts yet, why don't you start and write one", "Пока нет постов. Почему бы не начать и не написать один"

  # app/views/admin/dashboard/_welcome.html.erb
  l.store "Welcome back, %s!", "Добро пожаловать снова, %s!"
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
