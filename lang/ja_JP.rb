# coding: utf-8
Localization.define("ja_JP") do |l|

  # app/controllers/accounts_controller.rb
  l.store "Login successful", "ログインしました"
  l.store "Login unsuccessful", "ログインに失敗しました"
  l.store "An email has been successfully sent to your address with your new password", ""
  l.store "Oops, something wrong just happened", ""
  l.store "Successfully logged out", "ログアウトしました"
  l.store "login", "ログイン"
  l.store "signup", "サインアップ"
  l.store "Recover your password", ""

  # app/controllers/admin/categories_controller.rb
  l.store "Category was successfully saved.", ""
  l.store "Category could not be saved.", ""

  # app/controllers/admin/content_controller.rb
  l.store "Error, you are not allowed to perform this action", "あなたのアカウントではこの操作は許可されていません"
  l.store "Preview", ""
  l.store "Article was successfully created", "記事を作成しました"
  l.store "Article was successfully updated.", "記事が更新されました"

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
  l.store "Page was successfully created.", "ページが作成されました"
  l.store "Page was successfully updated.", "ページが更新されました"

  # app/controllers/admin/profiles_controller.rb
  l.store "User was successfully updated.", "プロフィールが更新されました"

  # app/controllers/admin/resources_controller.rb
  l.store "Error occurred while updating Content Type.", "コンテントタイプを更新中にエラーが発生しました"
  l.store "complete", "完了"
  l.store "File uploaded: ", "アップロードするファイル: "
  l.store "Unable to upload", "アップロードできません"
  l.store "Metadata was successfully updated.", "メタデータは正常に更新されました"
  l.store "Not all metadata was defined correctly.", "いくつかのメタデータが正しく反映されませんでした"
  l.store "Content Type was successfully updated.", "コンテントタイプは正常に更新されました"

  # app/controllers/admin/settings_controller.rb
  l.store "Please review and save the settings before continuing", ""
  l.store "config updated.", "設定は更新されました"

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
  l.store "Cancel", "キャンセル"
  l.store "Store", ""
  l.store "Delete", "削除"
  l.store "delete", "削除"
  l.store "Delete content", ""
  l.store "Are you sure?", ""
  l.store "Please select", "選択してください"
  l.store "There are no %s yet. Why don't you start and create one?", ""
  l.store "or", "または"
  l.store "Save", "保存"
  l.store "Edit", "編集"
  l.store "Show", ""
  l.store "Published", "公開済み"
  l.store "Unpublished", ""
  l.store "Show help on Typo macros", "Typoマクロのヘルプを表示"
  l.store "Back to overview", "オーバービューに戻る"
  l.store "Name", "名前"
  l.store "Description", "説明"
  l.store "Tag", ""

  # app/helpers/admin/categories_helper.rb
  l.store "no articles", ""
  l.store "1 article", "1記事"
  l.store "%d articles", "%d記事"

  # app/helpers/admin/content_helper.rb
  l.store "Destroy this draft", ""

  # app/helpers/admin/feedback_helper.rb
  l.store "Show conversation", ""
  l.store "Flag as %s", ""

  # app/helpers/application_helper.rb
  l.store "%%a, %%d %%b %%Y %%H:%%M:%%S GMT", Proc.new { |date| sprintf(date.strftime("%Y-%m-%d %H:%M:%S GMT")) }
  l.store "%%d. %%b", Proc.new { |date| sprintf(date.strftime("%m/%d")) }
  l.store "%d comments", ""
  l.store "no comments", "コメントなし"
  l.store "1 comment", ""
  l.store "no trackbacks", "トラックバックなし"
  l.store "1 trackback", ""
  l.store "%d trackbacks", ""

  # app/helpers/content_helper.rb
  l.store "Posted in", "カテゴリ"
  l.store "Tags", "タグ"
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
  l.store "Unclassified", "未分類"
  l.store "Just Presumed Ham", "承認と推定"
  l.store "Ham?", "承認?"
  l.store "Just Marked As Ham", "承認マーク"
  l.store "Ham", "承認"
  l.store "Spam?", "スパム?"
  l.store "Just Marked As Spam", "スパムマーク"
  l.store "Spam", "スパム"

  # app/views/accounts/login.html.erb
  l.store "I've lost my password", ""
  l.store "Login", "ログイン"
  l.store "Password", "パスワード"
  l.store "Remember me", "ログイン状態を持続"
  l.store "Submit", ""
  l.store "Back to ", ""

  # app/views/accounts/recover_password.html.erb
  l.store "Username or email", ""

  # app/views/accounts/signup.html.erb
  l.store "Create an account", ""
  l.store "Username", "ユーザー名"
  l.store "Email", "メールアドレス"
  l.store "Signup", "サインアップ"

  # app/views/admin/categories/_categories.html.erb
  l.store "Title", "タイトル"
  l.store "Reorder", "並べ替え"
  l.store "Sort alphabetically", "アルファベット順に並べ替え"

  # app/views/admin/categories/_form.html.erb
  l.store "Keywords", ""

  # app/views/admin/categories/destroy.html.erb
  l.store "Are you sure you want to delete the category ", "このカテゴリを削除してもよろしいですか？ "
  l.store "Delete this category", "このカテゴリを削除"
  l.store "Categories", "カテゴリ"

  # app/views/admin/categories/index.html.erb
  l.store "New Category", ""

  # app/views/admin/categories/new.html.erb
  l.store "%s Category", ""

  # app/views/admin/categories/reorder.html.erb
  l.store "(Done)", "(完了)"

  # app/views/admin/content/_attachment.html.erb
  l.store "Remove", "削除"
  l.store "Currently this article has the following resources", "現在この記事には以下のリソースが含まれています"
  l.store "You can associate the following resources", "以下のリソースを整理することができます"
  l.store "Really delete attachment", "本当に添付ファイルを削除してもよろしいですか？"
  l.store "Add Another Attachment", "添付ファイルを追加"

  # app/views/admin/content/_drafts.html.erb
  l.store "Drafts", ""

  # app/views/admin/content/_form.html.erb
  l.store "Publish settings", ""
  l.store "Allow comments", "コメントを許可"
  l.store "Allow trackbacks", "トラックバックを許可"
  l.store "Password:", ""
  l.store "Publish", "公開"
  l.store "Excerpt", "要約"
  l.store "Excerpts are posts summaries that are shown on your blog homepage only but won’t appear on the post itself", ""
  l.store "Uploads", "アップロード"
  l.store "Post settings", "投稿設定"
  l.store "Publish at", "公開日"
  l.store "Permalink", "パーマリンク"
  l.store "Article filter", "記事フィルター"
  l.store "Save as draft", "下書きとして保存"

  # app/views/admin/content/destroy.html.erb
  l.store "Are you sure you want to delete this article", "本当にこの記事を削除してよろしいですか？"
  l.store "Delete this article", "この記事を削除"
  l.store "Articles", "記事"

  # app/views/admin/content/index.html.erb
  l.store "New Article", ""
  l.store "Search articles that contain ...", "以下の語句を含む記事を検索"
  l.store "Search", "検索"
  l.store "Author", "投稿者"
  l.store "Date", "日付"
  l.store "Feedback", "フィードバック"
  l.store "Filter", "フィルター"
  l.store "Manage articles", "記事の管理"

  # app/views/admin/dashboard/_comments.html.erb
  l.store "Latest Comments", ""
  l.store "No comments yet", "まだコメントはありません"
  l.store "By %s on %s", ""

  # app/views/admin/dashboard/_inbound.html.erb
  l.store "Inbound links", "外部からのリンク"
  l.store "No one made a link to you yet", "まだどこからもリンクされていません"
  l.store " made a link to you saying ", " からこのようにリンクされています "
  l.store "You have no internet connection", "インターネットに接続できません"

  # app/views/admin/dashboard/_overview.html.erb
  l.store "This place gives you a quick overview of what happens on your Typo blog and what you can do. Maybe will you want to %s, %s or %s.", "ここはこのTypoブログの全体が概観できるページです。ここから%sこと、%sこと、そして%sことができます。"
  l.store "update your profile or change your password", "プロフィールを編集したりパスワードを変更する"
  l.store "You can also do a bit of design, %s or %s.", ""
  l.store "change your blog presentation", ""
  l.store "enable plugins", ""
  l.store "write a post", "記事を投稿する"
  l.store "write a page", "ページを作成する"

  # app/views/admin/dashboard/_popular.html.erb
  l.store "Most popular", "人気記事"
  l.store "Nothing to show yet", ""

  # app/views/admin/dashboard/_posts.html.erb
  l.store "Latest Posts", ""
  l.store "No posts yet, why don't you start and write one", ""

  # app/views/admin/dashboard/_typo_dev.html.erb
  l.store "Latest news from the Typo development blog", ""
  l.store "Oh no, nothing new", ""

  # app/views/admin/dashboard/_welcome.html.erb
  l.store "Welcome back, %s!", "お帰りなさいませ、%s 様"
  l.store "%d articles and %d comments were posted since your last connexion", ""
  l.store "You're running Typo %s", "Typo バージョン%s が稼働中です"
  l.store "Total posts : %d", "総投稿数"
  l.store "Your posts : %d", "あなたの投稿数"
  l.store "Total comments : %d", "総コメント数"
  l.store "Spam comments : %d", "スパムコメント数"

  # app/views/admin/feedback/_button.html.erb
  l.store "Select action", ""
  l.store "Delete Checked Items", "チェックした行を削除"
  l.store "Delete all spam", "全てのスパムを削除する"
  l.store "Mark Checked Items as Spam", "チェックした行をスパムにする"
  l.store "Mark Checked Items as Ham", "チェックした行を承認する"
  l.store "All comments", "全てのコメント"
  l.store "Limit to ham", "有効コメント"
  l.store "Unapproved comments", "未承認コメント"
  l.store "Limit to spam", "スパムコメント"

  # app/views/admin/feedback/_form.html.erb
  l.store "Add a comment", ""
  l.store "Url", ""

  # app/views/admin/feedback/_spam.html.erb
  l.store "This comment by <strong>%s</strong> was flagged as spam, %s?", ""

  # app/views/admin/feedback/article.html.erb
  l.store "Comments for %s", ""
  l.store "Status", "ステータス"
  l.store "Comment Author", ""
  l.store "Comment", ""

  # app/views/admin/feedback/edit.html.erb
  l.store "Comments for", "〜へコメント"

  # app/views/admin/feedback/index.html.erb
  l.store "Search Comments and Trackbacks that contain", "以下の語句を含むコメントおよびトラックバックを検索"
  l.store "Article", "記事"

  # app/views/admin/pages/_form.html.erb
  l.store "Online", "オンライン"
  l.store "Page settings", "ページ設定"
  l.store "Permanent link", ""

  # app/views/admin/pages/destroy.html.erb
  l.store "Pages","ページ"
  l.store "Are you sure you want to delete the page", "本当にこのページを削除してよろしいですか？"
  l.store "Delete this page", "このページを削除"

  # app/views/admin/pages/index.html.erb
  l.store "New Page", ""
  l.store "Manage pages", "ページの管理"

  # app/views/admin/profiles/index.html.erb
  l.store "Your profile", "あなたのプロフィール"

  # app/views/admin/resources/_mime_edit.html.erb
  l.store "Content Type", "コンテンツタイプ"

  # app/views/admin/resources/_pages.html.erb
  l.store "Previous page", "前のページ"
  l.store "Next page", "次のページ"

  # app/views/admin/resources/_upload.html.erb
  l.store "Upload a File to your Site", "サイトにファイルをアップロード"
  l.store "File", "ファイル"
  l.store "Upload", "アップロード"

  # app/views/admin/resources/destroy.html.erb
  l.store "Are you sure you want to delete this file", "本当にこのファイルを削除してよろしいですか？"
  l.store "Delete this file from the webserver?", "webサーバーからこのファイルを削除しますか？"
  l.store "File Uploads", "ファイルアップロード"

  # app/views/admin/resources/images.html.erb
  l.store "Thumbnail", ""
  l.store "File Size", "ファイルサイズ"
  l.store "Images", ""
  l.store "right-click for link", "右クリックでリンク"

  # app/views/admin/resources/index.html.erb
  l.store "Filename", "ファイル名"

  # app/views/admin/settings/_submit.html.erb
  l.store "Update settings", ""

  # app/views/admin/settings/feedback.html.erb
  l.store "Enable comments by default", "デフォルトでコメントを有効にする"
  l.store "Enable Trackbacks by default", "デフォルトでトラックバックを許可する"
  l.store "Enable feedback moderation", "フィードバック承認機能を有効にする"
  l.store "You can enable site wide feeback moderation. If you do so, no comment or trackback will appear on your blog unless you validate it", "サイト全体のフィードバック承認機能を有効にすることができます。有効にするとコメントやトラックバックは承認されるまで表示されません。"
  l.store "Comments filter", "コメントフィルター"
  l.store "Enable gravatars", "Gravatarを有効にする"
  l.store "Show your email address", "メールアドレスを表示"
  l.store "Notifications", ""
  l.store "Typo can notify you when new articles or comments are posted", "新しい記事やコメントが投稿された場合に通知を送ることができます"
  l.store "Source Email", "メールアドレス"
  l.store "Email address used by Typo to send notifications", "通知の送信先メールアドレス"
  l.store "Enabling spam protection will make typo compare the IP address of posters as well as the contents of their posts against local and remote blacklists. Good defense against spam bots", "スパムプロテクションを有効にすると、投稿者のIPアドレスおよびその投稿内容をローカル、リモート両方のブラックリストと比較します"
  l.store "Enable spam protection", "スパムプロテクションを有効にする"
  l.store "Akismet Key", "Akismetキー"
  l.store "Typo can (optionally) use the %s spam-filtering service.  You need to register with Akismet and receive an API key before you can use their service.  If you have an Akismet key, enter it here", "Typoはオプションで%sスパムフィルタリングサービスを利用できます。これらのサービスを使用するにはAkismetに登録し、APIキーを取得する必要があります。すでにAkismetキーをお持ちであればここに入力してください"
  l.store "Disable trackbacks site-wide", ""
  l.store "This setting allows you to disable trackbacks for every article in your blog.  It won't remove existing trackbacks, but it will prevent any further attempt to add a trackback anywhere on your blog.", "この設定はすでにあるトラックバックを削除しませんが、新しく追加しようとするトラックバックを防ぐことができます。"
  l.store "Disable comments after", "右の期間以後のコメントを不許可にする"
  l.store "days", "日"
  l.store "Set to 0 to never disable comments", "コメントを不許可にしない場合は0を設定してください"
  l.store "Max Links", "最大のリンク数"
  l.store "Typo will automatically reject comments and trackbacks which contain over a certain amount of links in them", "Typoは指定された数のリンクが含まれているコメントやトラックバックを自動的に拒否します"
  l.store "Set to 0 to never reject comments", "コメントを拒否しない場合は0を設定してください"
  l.store "Feedback settings", ""

  # app/views/admin/settings/index.html.erb
  l.store "Your blog", "あなたのブログ"
  l.store "Blog name", "ブログ名"
  l.store "Blog subtitle", "ブログサブタイトル"
  l.store "Blog URL", "ブログURL"
  l.store "Language", "言語"
  l.store "Allow users to register", "ユーザーに登録させる"
  l.store "You can allow users to register to your blog. By default, they will register as contributors, an unpriviledged account level which grant them no rights but own a profile on the site. If you don't want users to register, you can thus add them by yourself in the users part of this admin.", "ユーザーがこのブログに登録するのを許可できます。デフォルトでユーザーは自分自身のプロフィールを編集する以外の権限を持たないcontributorとして登録されます。ユーザーに登録させたくない場合は、管理者であるあなた自らがユーザーを追加することができます。"
  l.store "Items to display in admin lists", "管理リストに表示する行数"
  l.store "Publishing options", ""
  l.store "Display", "表示"
  l.store "articles on my homepage by default", "ホームページのデフォルト記事数"
  l.store "articles in my news feed by default", "RSSフィードのデフォルト記事数"
  l.store "Show full article on feed", "記事の全文をフィードに表示"
  l.store "Feedburner ID", ""
  l.store "General settings", "一般設定"
  l.store "You can use your Google Feedburner account instead of Typo feed URL. To enable this, fill this form with your Feedburner ID.", ""

  # app/views/admin/settings/seo.html.erb
  l.store "Search Engine Optimisation", ""
  l.store "Format of permalink", "パーマリンクの書式"
  l.store "Google Analytics", ""
  l.store "Google verification link", ""
  l.store "Meta description", "METAタグDescription"
  l.store "Meta keywords", "METAタグKeywords"
  l.store "Use RSS description", "RSSにDescription表示をする"
  l.store "Index categories", "カテゴリのインデックス"
  l.store "Unchecking this box will add <code>noindex, follow</code> meta tags in every category page, removing them from search engines and preventing duplicate content issues", "このボックスのチェックを外すと、全てのカテゴリのページに<code>noindex, follow</code>のMETAタグを付与します。すると検索エンジンからそれらのページが削除され、コンテンツ重複の防止になります"
  l.store "Index tags", "タグのインデックス"
  l.store "Unchecking this box will add <code>noindex, follow</code> meta tags in every tags page, removing them from search engines and preventing duplicate content issues", "このボックスのチェックを外すと、全てのタグのページに<code>noindex, follow</code>のMETAタグを付与します。すると検索エンジンからそれらのページが削除され、コンテンツ重複の防止になります"
  l.store "Robots.txt", ""
  l.store "You robots.txt file is not writeable. Typo won't be able to write it", ""
  l.store "Search Engine Optimization", "検索エンジン最適化"
  l.store "This will display", ""
  l.store "at the bottom of each of your post in the RSS feed", ""

  # app/views/admin/settings/update_database.html.erb
  l.store "Information", "インフォメーション"
  l.store "Current database version", "現在のデータベースのバージョン"
  l.store "New database version", "新しいデータベースのバージョン"
  l.store "Your database supports migrations", "あなたのデータベースはマイグレーションをサポートしています"
  l.store "Needed migrations", "マイグレーションが必要です"
  l.store "You are up to date!", "最新です!"
  l.store "Update database now", "データベースを今すぐ更新"
  l.store "may take a moment", "少しお待ちください"
  l.store "Database migration", "データベースマイグレーション"
  l.store "yes", "はい"
  l.store "no", "いいえ"

  # app/views/admin/settings/write.html.erb
  l.store "Send trackbacks", "トラックバックを送信"
  l.store "When publishing articles, Typo can send trackbacks to websites that you link to. This should be disabled for private blogs as it will leak non-public information to sites that you're discussing. For public blogs, there's no real point in disabling this.", "記事が公開されると、Typoはリンクしたページへトラックバックを送信します。非公開ブログの場合は公開されたブログへ情報が漏れないようにこのチェックボックスを非選択にしてください。公開ブログの場合は非選択にする必要はありません。"
  l.store "URLs to ping automatically", "自動的にPingを送信するURL"
  l.store "Latitude, Longitude", "緯度、経度"
  l.store "your lattitude and longitude", "あなたの緯度、経度"
  l.store "exemple", "例"
  l.store "Write", "新規作成"

  # app/views/admin/sidebar/_availables.html.erb
  l.store "You have no plugins installed", "プラグインがインストールされていません"

  # app/views/admin/sidebar/_publish.html.erb
  l.store "Changes published", "変更して公開"

  # app/views/admin/sidebar/_target.html.erb
  l.store "Drag some plugins here to fill your sidebar", "サイドバーで利用するプラグインをドラッグしてください"

  # app/views/admin/sidebar/index.html.erb
  l.store "Drag and drop to change the sidebar items displayed on this blog.  To remove items from the sidebar just click remove  Changes are saved immediately, but not activated until you click the 'Publish' button", "ブログに表示するサイドバー項目をドラッグ＆ドロップで変更してください。サイドバーから項目を削除した場合はすぐに変更が保存されますが、「公開」ボタンを押すまでは有効になりません。"
  l.store "Available Items", "利用可能な項目"
  l.store "Active Sidebar items", "有効なサイドバー項目"
  l.store "Get more plugins", "他のプラグインの入手"
  l.store "Sidebar", "サイドバー"
  l.store "Publish changes", "変更を公開"

  # app/views/admin/tags/_form.html.erb
  l.store "Display name", "表示名"

  # app/views/admin/tags/destroy.html.erb
  l.store "Are you sure you want to delete the tag", ""
  l.store "Delete this tag", ""

  # app/views/admin/tags/edit.html.erb
  l.store "Editing ", ""
  l.store "Back to tags list", ""

  # app/views/admin/tags/index.html.erb
  l.store "Display Name", "表示名"
  l.store "Manage tags", "タグの管理"

  # app/views/admin/themes/catalogue.html.erb
  l.store "Sorry the theme catalogue is not available", ""
  l.store "Theme catalogue", "テーマカタログ"

  # app/views/admin/themes/editor.html.erb
  l.store "Theme editor", "テーマエディタ"

  # app/views/admin/themes/index.html.erb
  l.store "Active theme", "現在のテーマ"
  l.store "Get more themes", "他のテーマの入手"
  l.store "You can download third party themes from officially supported %s ", "公式サイト%sからサードパーティのテーマをダウンロードできます。"
  l.store "Typogarden", ""
  l.store "To install a theme you  just need to upload the theme folder into your themes directory. Once a theme is uploaded, you should see it on this page.", "テーマをインストールするには、アプリケーションのthemes/ディレクトリに任意のテーマのフォルダをアップロードしてください。そうすればそのテーマをこのページで閲覧することができます。"
  l.store "Choose a theme", "テーマの選択"

  # app/views/admin/users/_form.html.erb
  l.store "Account settings", ""
  l.store "Password confirmation", "パスワード（確認用）"
  l.store "Profile", "プロフィール"
  l.store "User's status", ""
  l.store "Active", "有効"
  l.store "Inactive", "無効"
  l.store "Profile Settings", ""
  l.store "Firstname", "姓"
  l.store "Lastname", "名"
  l.store "Nickname", "ニックネーム"
  l.store "Editor", "エディタ"
  l.store "Use simple editor", "プレーンなエディタを使う"
  l.store "Use visual rich editor", "WYSIWYGエディタを使う"
  l.store "Send notification messages via email", "メールで通知を送信"
  l.store "Send notification messages when new articles are posted", "新しい記事が投稿された際に通知メッセージを送る"
  l.store "Send notification messages when comments are posted", "コメントが投稿された際に通知メッセージを送る"
  l.store "Contact Options", ""
  l.store "Your site", "あなたのホームページ"
  l.store "display url on public profile", "公開プロフィールにURLを表示"
  l.store "Your MSN", "あなたのMSN ID"
  l.store "display MSN ID on public profile", "公開プロフィールにMSN IDを表示"
  l.store "Your Yahoo ID", "あなたのYahoo ID"
  l.store "display Yahoo! ID on public profile", "公開プロフィールにYahoo! IDを表示"
  l.store "Your Jabber ID", "あなたのJabber ID"
  l.store "display Jabber ID on public profile", "公開プロフィールにJabber IDを表示"
  l.store "Your AIM id", "あなたのAIM ID"
  l.store "display AIM ID on public profile", "公開プロフィールにAIM IDを表示"
  l.store "Your Twitter username", "あなたのTwitter ID"
  l.store "display twitter on public profile", "公開プロフィールにTwitter IDを表示"
  l.store "Tell us more about you", "補足事項"

  # app/views/admin/users/destroy.html.erb
  l.store "Really delete user", "本当にユーザーを削除"
  l.store "Yes", "はい"
  l.store "Users", "ユーザー"

  # app/views/admin/users/edit.html.erb
  l.store "Edit User", "ユーザー編集"

  # app/views/admin/users/index.html.erb
  l.store "New User", "新規ユーザー"
  l.store "Comments", "コメント"
  l.store "State", "状態"
  l.store "%s user", "%s"

  # app/views/admin/users/new.html.erb
  l.store "Add User", "ユーザーの追加"

  # app/views/articles/_article.html.erb
  l.store "Posted by", "投稿者"
  l.store "Continue reading", ""

  # app/views/articles/_comment.html.erb
  l.store "said", "発言"
  l.store "This comment has been flagged for moderator approval.  It won't appear on this blog until the author approves it", "このコメントはモデレーターの確認が必要です。モデレーターが確認後にコメントが表示されます。"

  # app/views/articles/_comment_box.html.erb
  l.store "Your name", "あなたの名前"
  l.store "Your email", "あなたのemail"
  l.store "Your message", "メッセージ"
  l.store "Comment Markup Help", "コメントのマークアップヘルプ"
  l.store "Preview comment", "前のコメント"
  l.store "leave url/email", ""

  # app/views/articles/_comment_failed.html.erb
  l.store "Oops, something wrong happened, the comment could not be saved", ""

  # app/views/articles/_trackback.html.erb
  l.store "From", "From"

  # app/views/articles/archives.html.erb
  l.store "No articles found", "記事が見つかりませんでした"
  l.store "posted in", ""

  # app/views/articles/comment_preview.html.erb
  l.store "is about to say", "〜について言う"

  # app/views/articles/groupings.html.erb
  l.store "There are", "ここに"

  # app/views/articles/read.html.erb
  l.store "Leave a response", "コメントを書く"
  l.store "Trackbacks", "トラックバック"
  l.store "Use the following link to trackback from your own site", "トラックバックリンク"
  l.store "RSS feed for this post", "この記事のRSSフィード"
  l.store "trackback uri", "トラックバックURL"
  l.store "Comments are disabled", "コメントは許可されていません"

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
  l.store "Dashboard", "ダッシュボード"

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
  l.store "Continue reading...", "続きを読む‥"
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
  l.store "Trackbacks for", "〜へのトラックバック"

  # themes/true-blue-3/views/articles/search.html.erb
  l.store "Search results for:", ""

  # themes/true-blue-3/views/categories/index.html.erb
  l.store "Read all articles in %s", ""

  # themes/true-blue-3/views/categories/show.html.erb
  l.store "Previous", ""
  l.store "Next", ""

  # vendor/plugins/archives_sidebar/views/content.rhtml
  l.store "Archives", "アーカイブ"

  # vendor/plugins/authors_sidebar/views/content.rhtml
  l.store "Authors", "作者"

  # vendor/plugins/xml_sidebar/views/content.rhtml
  l.store "Syndicate", "シンジゲート"
  l.store "Category %s", ""
  l.store "Tag %s", ""

  # Obsolete translations
  l.store "A new message was posted to ", "〜へ新しいメッセージを投稿しました"
  l.store "Action", "アクション"
  l.store "Activate", "有効にする"
  l.store "Add MetaData", "メタデータ追加"
  l.store "Add category", "カテゴリ追加"
  l.store "Add new user", "新しいユーザーを追加"
  l.store "Add pattern", "パターン追加"
  l.store "Allow non-ajax comments", "Ajaxでないコメントを許可する"
  l.store "Apr", "4月"
  l.store "April",     "4月"
  l.store "Are you sure you want to delete this filter", "このフィルターを削除してもよろしいですか？"
  l.store "Are you sure you want to delete this item?", "この項目を削除してもよろしいですか？"
  l.store "Articles in", "記事"
  l.store "Attachments", "添付"
  l.store "Aug", "8月"
  l.store "August",    "8月"
  l.store "Blacklist", "ブラックリスト"
  l.store "Blacklist Patterns", "ブラックリストパターン"
  l.store "Blog settings", "ブログ設定"
  l.store "Cache", "キャッシュ"
  l.store "Cache was cleared", "キャッシュはクリアされました"
  l.store "Category", "カテゴリ"
  l.store "Category could not be created.", "カテゴリは追加できませんでした"
  l.store "Category was successfully created.", "カテゴリは正常に作成されました"
  l.store "Category was successfully updated.", "カテゴリは正常に更新されました。"
  l.store "Change you blog presentation", "プログの説明を変更してください。"
  l.store "Choose password", "パスワード"
  l.store "Comment Excerpt", "コメント抜粋"
  l.store "Confirm Classification of Checked Items", "チェックした行の分類を認める"
  l.store "Confirm password", "パスワード再入力"
  l.store "Contact options", "連絡オプション"
  l.store "Content", "コンテンツ"
  l.store "Copyright Information", "著作権情報"
  l.store "Create new Blacklist", "新しいブラックリスト作成"
  l.store "Create new category", "新規カテゴリ追加"
  l.store "Create new page", "新しいページを作成"
  l.store "Create new text filter", "新しいテキストフィルターを作成"
  l.store "Creating comment", "コメント作成"
  l.store "Creating text filter", "テキストフィルター作成"
  l.store "Creating trackback", "トラックバックを作成"
  l.store "Creating user", "ユーザー作成"
  l.store "Currently this article is listed in following categories", "現在この記事は以下のカテゴリに追加されています"
  l.store "Customize Sidebar", "サイドバーのカスタマイズ"
  l.store "Dec", "12月"
  l.store "December",  "12月"
  l.store "Delete this filter", "このフィルターを削除"
  l.store "Desired login", "ログイン名"
  l.store "Do you want to go to your blog?", "ブログに移動しますか？"
  l.store "Drafts:", "下書き:"
  l.store "Duration", "継続時間"
  l.store "Edit Article", "記事を編集"
  l.store "Edit MetaData", "メタデータ編集"
  l.store "Edit this article", "この記事を編集"
  l.store "Edit this category", "このカテゴリを編集"
  l.store "Edit this filter", "このフィルターを編集"
  l.store "Edit this page", "このページを編集"
  l.store "Edit this trackback", "このトラックバックを編集"
  l.store "Editing User", "ユーザー編集中"
  l.store "Editing category", "カテゴリ編集中"
  l.store "Editing comment", "コメント編集中"
  l.store "Editing page", "ページを編集中"
  l.store "Editing pattern", "パターン編集中"
  l.store "Editing textfilter", "テキストフィルターを編集中"
  l.store "Editing trackback", "トラックバックを編集"
  l.store "Enable plugins", "プラグイン有効化"
  l.store "Explicit", "明示的コンテンツ"
  l.store "Feb", "2月"
  l.store "February",  "2月"
  l.store "Feedback for", "フィードバック: "
  l.store "Filters", "フィルター"
  l.store "Fri", "金"
  l.store "Friday",    "金曜日"
  l.store "HTML was cleared", "HTMLはクリアされました"
  l.store "IP", "IPアドレス"
  l.store "Jan", "1月"
  l.store "January",   "1月"
  l.store "Jul", "7月"
  l.store "July",      "7月"
  l.store "Jun", "6月"
  l.store "June",      "6月"
  l.store "Key Words", "キーワード"
  l.store "Last Comments", "最新のコメント"
  l.store "Last posts", "最新の記事"
  l.store "Last updated", "最終更新日"
  l.store "Logoff", "ログアウト"
  l.store "Macro Filter Help", "マクロフィルターヘルプ"
  l.store "Macros", "マクロ"
  l.store "Manage Articles", "記事管理"
  l.store "Manage Categories", "カテゴリ管理"
  l.store "Manage Pages", "ページ管理"
  l.store "Manage Resources", "リソース管理"
  l.store "Manage Text Filters", "テキストフィルターの管理"
  l.store "Mandatory", "必須"
  l.store "Mar", "3月"
  l.store "March",     "3月"
  l.store "Markup", "マークアップ"
  l.store "Markup type", "マークアップタイプ"
  l.store "May",       "5月"
  l.store "MetaData", "メタデータ"
  l.store "Metadata was successfully removed.", "メタデータは正常に削除されました"
  l.store "Mon", "月"
  l.store "Monday",    "月曜日"
  l.store "New post", "新規記事"
  l.store "No", "いいえ"
  l.store "Not published by Apple", "Appleに公開しない"
  l.store "Notification", "通知"
  l.store "Notified", "通知"
  l.store "Notify on new articles", "新しい記事を通知"
  l.store "Notify on new comments", "新しいコメントを通知"
  l.store "Notify via email", "email経由で通知"
  l.store "Nov", "11月"
  l.store "November",  "11月"
  l.store "Number of Articles", "記事数"
  l.store "Number of Comments", "コメント数"
  l.store "Oct", "10月"
  l.store "October",   "10月"
  l.store "Older posts", "古い記事"
  l.store "Optional Name", "オプション名"
  l.store "Options", "オプション"
  l.store "Page", "ページ"
  l.store "Parameters", "パラメーター"
  l.store "Pattern", "パターン"
  l.store "Personal information", "個人情報"
  l.store "Pictures from", "〜からの画像"
  l.store "Podcasts", "ポッドキャスト"
  l.store "Post-processing filters", "投稿処理フィルター"
  l.store "Posted date", "投稿日"
  l.store "Posts", "投稿数"
  l.store "Preview Article", "前の記事"
  l.store "Read", "表示"
  l.store "Read more", "続きを読む"
  l.store "Recent comments", "最近のコメント"
  l.store "Recent trackbacks", "最近のトラックバック"
  l.store "Regex", "正規表現"
  l.store "Remove iTunes Metadata", "iTunesのメタデータを削除"
  l.store "Resource MetaData", "リソースメタデータ"
  l.store "Sat", "土"
  l.store "Saturday",  "土曜日"
  l.store "See help text for this filter", "このフィルターのヘルプを見る"
  l.store "Sep", "9月"
  l.store "September", "9月"
  l.store "Set iTunes metadata for this enclosure", "このリソースにiTunesのメタデータをセット"
  l.store "Setting for channel", "チャンネル設定"
  l.store "Show Help", "ヘルプを表示"
  l.store "Show this article", "この記事を表示"
  l.store "Show this category", "カテゴリ表示"
  l.store "Show this comment", "このコメントを表示"
  l.store "Show this page", "このページを表示"
  l.store "Show this pattern", "パターンを表示"
  l.store "Show this user", "このユーザーを表示"
  l.store "Statistics", "統計データ"
  l.store "String", "文字列"
  l.store "Subtitle", "サブタイトル"
  l.store "Summary", "サマリー"
  l.store "Sun", "日"
  l.store "Sunday",    "日曜日"
  l.store "Sweep cache", "キャッシュをクリア"
  l.store "System information", "システム情報"
  l.store "Text Filter Details", "テキストフィルター詳細"
  l.store "Text Filters", "テキストフィルター"
  l.store "The below settings act as defaults when you choose to publish an enclosure with iTunes metadata", "以下の項目は、公開を選択した場合にデフォルトのiTunesのメタデータとして設定されます"
  l.store "Themes", "テーマ"
  l.store "There are %d entries in the page cache", "ページキャッシュに%d個の記事があります"
  l.store "Thu", "木"
  l.store "Thursday",  "木曜日"
  l.store "Tue", "火"
  l.store "Tuesday",   "火曜日"
  l.store "Type", "タイプ"
  l.store "Typo documentation", "Typoドキュメント"
  l.store "Update your profile or change your password", "プロファイルを更新するか、パスワードを変更してください"
  l.store "Upload a new File", "新規ファイルをアップロード"
  l.store "Upload a new Resource", "新しいリソースをアップロード"
  l.store "Uploaded", "アップロード"
  l.store "User's articles", "ユーザーの記事"
  l.store "View article on your blog", "ブログで記事を確認"
  l.store "View comment on your blog", "ブログにコメントを表示"
  l.store "View page on your blog", "ブログでページを確認"
  l.store "Wed", "水"
  l.store "Wednesday", "水曜日"
  l.store "What can you do ?", "なにができますか？"
  l.store "Write Page", "ページを作成"
  l.store "Write Post", "記事を書く"
  l.store "Write a Page", "ページを書く"
  l.store "Write an Article", "記事を書く"
  l.store "You are now logged out of the system", "システムからログアウトしました"
  l.store "You can add it to the following categories", "以下のカテゴリへ追加することができます"
  l.store "You can optionally disable non-Ajax comments. Typo will always use Ajax for comment submission if Javascript is enabled, so non-Ajax comments are either from spammers or users without Javascript.", "オプションでAjaxでないコメントを不許可にすることができます。Javascriptが有効な場合、Typoは常にコメントの受け渡しにAjaxを使います。つまりAjaxでないコメントはJavascriptを有効にしていないユーザーのものか、スパマーのものかのどちらかでしょう。"
  l.store "add new", "新規追加"
  l.store "by", "by"
  l.store "log out", "ログアウト"
  l.store "no ", "no "
  l.store "on", "の"
  l.store "published", "公開済み"
  l.store "save", "保存"
  l.store "seperate with spaces", "スペースで分ける"
  l.store "unpublished", "未公開"
  l.store "via email", "email経由"
  l.store "your blog", "ブログ"
end
