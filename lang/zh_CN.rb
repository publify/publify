# coding: utf-8
Localization.define("zh_CN") do |l|

  # app/controllers/accounts_controller.rb
  l.store "Login successful", "登录成功"
  l.store "Login unsuccessful", "登录不成功"
  l.store "An email has been successfully sent to your address with your new password", "你的新密码已经发送到你的email邮箱当中"
  l.store "Oops, something wrong just happened", "噢，发生了一些错误"
  l.store "Successfully logged out", "成功登出"
  l.store "login", "登录"
  l.store "signup", "注册"
  l.store "Recover your password", ""

  # app/controllers/admin/categories_controller.rb
  l.store "Category was successfully saved.", "成功保存分类"
  l.store "Category could not be saved.", "无法保存分类"

  # app/controllers/admin/content_controller.rb
  l.store "Error, you are not allowed to perform this action", "错误，不允许进行此操作"
  l.store "Preview", "预览"
  l.store "Article was successfully created", "文章创建成功"
  l.store "Article was successfully updated.", "文章更新成功"

  # app/controllers/admin/feedback_controller.rb
  l.store "Deleted", "删除"
  l.store "Not found", "不存在"
  l.store "Deleted %d item(s)", "删除%d项"
  l.store "Marked %d item(s) as Ham", ""
  l.store "Marked %d item(s) as Spam", "标记%d项为垃圾信息"
  l.store "Confirmed classification of %s item(s)", ""
  l.store "Not implemented", "未实现"
  l.store "All spam have been deleted", "所有垃圾信息已经呗删除"
  l.store "Comment was successfully created.", "评论创建成功"
  l.store "Comment was successfully updated.", "评论更新成功"

  # app/controllers/admin/pages_controller.rb
  l.store "Page was successfully created.", "页面创建成功"
  l.store "Page was successfully updated.", "页面更新成功"

  # app/controllers/admin/profiles_controller.rb
  l.store "User was successfully updated.", "用户创建成功"

  # app/controllers/admin/resources_controller.rb
  l.store "Error occurred while updating Content Type.", "当更新内容类型时发生错误"
  l.store "complete", "完成"
  l.store "File uploaded: ", "文件上传: "
  l.store "Unable to upload", "不能被上传"
  l.store "Metadata was successfully updated.", "Metadata已成功更新"
  l.store "Not all metadata was defined correctly.", "并非所有Metadata已被正确定义"
  l.store "Content Type was successfully updated.", "內容类型已被成功更新"

  # app/controllers/admin/settings_controller.rb
  l.store "Please review and save the settings before continuing", "在继续前请确认和保存配置"
  l.store "config updated.", "更新配置"

  # app/controllers/admin/sidebar_controller.rb
  l.store "It seems something went wrong. Maybe some of your sidebars are actually missing and you should either reinstall them or remove them manually", "有错误发生，可能是一些侧边栏丢失，请尝试重新安装或者手动卸载。"

  # app/controllers/admin/tags_controller.rb
  l.store "Tag was successfully updated.", "Tag已经更新"

  # app/controllers/admin/themes_controller.rb
  l.store "Theme changed successfully", "主题切换成功"
  l.store "You are not authorized to open this file", "你没有权限打开这个文件"
  l.store "File saved successfully", "文件保存成功"
  l.store "Unable to write file", "无法写入文件"

  # app/controllers/admin/users_controller.rb
  l.store "User was successfully created.", "用户创建成功"

  # app/controllers/application_controller.rb
  l.store "Localization.rtl", ""

  # app/controllers/articles_controller.rb
  l.store "No posts found...", "没有文章"
  l.store "Archives for", "归档为"
  l.store "Archives for ", "归档为"
  l.store ", Articles for ", ""

  # app/controllers/grouping_controller.rb
  l.store "page", "页面"
  l.store "everything about", ""

  # app/helpers/admin/base_helper.rb
  l.store "Cancel", "取消"
  l.store "Store", "保存"
  l.store "Delete", "删除"
  l.store "delete", "删除"
  l.store "Delete content", "删除内容"
  l.store "Are you sure?", "你确认？"
  l.store "Please select", "请选择"
  l.store "All categories", "所有类别"
  l.store "All authors", "所有作家"
  l.store "All published dates", "所有日期"
  l.store "There are no %s yet. Why don't you start and create one?", "这儿并不存在%s。让我们开始创建它。"
  l.store "or", "或"
  l.store "Save", "保存"
  l.store "Edit", "修改"
  l.store "Show", "显示"
  l.store "Published", "已发表"
  l.store "Unpublished", "未发表"
  l.store "Show help on Typo macros", "显示Typo宏的帮助"
  l.store "Back to overview", "回到概览"
  l.store "Name", "名字"
  l.store "Description", "说明"
  l.store "Tag", ""

  # app/helpers/admin/categories_helper.rb
  l.store "no articles", "没有文章"
  l.store "1 article", "一篇文章"
  l.store "%d articles", "%d篇文章"

  # app/helpers/admin/content_helper.rb
  l.store "Destroy this draft", "删除草稿"

  # app/helpers/admin/feedback_helper.rb
  l.store "Show conversation", "显示对话"
  l.store "Flag as %s", "标记为%s"

  # app/helpers/application_helper.rb
  l.store "%%a, %%d %%b %%Y %%H:%%M:%%S GMT", ""
  l.store "%%d. %%b", ""
  l.store "%d comments", "%d条评论"
  l.store "no comments", "没有评论"
  l.store "1 comment", "一条评论"
  l.store "no trackbacks", "没有引用"
  l.store "1 trackback", "一条引用"
  l.store "%d trackbacks", "%d条引用"

  # app/helpers/content_helper.rb
  l.store "Posted in", "发表在"
  l.store "Tags", "标签"
  l.store "no posts", "没有文章"
  l.store "1 post", "一篇文章"
  l.store "%d posts", "%d篇文章"

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
  l.store "I've lost my password", "忘记密码"
  l.store "Login", "登录"
  l.store "Password", "密码"
  l.store "password", "密码"
  l.store "Remember me", "记住用户"
  l.store "Submit", "提交"
  l.store "Back to ", "返回"

  # app/views/accounts/recover_password.html.erb
  l.store "Back to login", ""
  l.store "Username or email", "用户名或邮箱"

  # app/views/accounts/signup.html.erb
  l.store "Create an account", "创建帐号"
  l.store "Username", "用户名"
  l.store "Email", "Email"
  l.store "Signup", "注册"

  # app/views/admin/categories/_categories.html.erb
  l.store "Title", "标题"
  l.store "Reorder", "重新排序"
  l.store "Sort alphabetically", "依字母顺序排序"

  # app/views/admin/categories/_form.html.erb
  l.store "Keywords", "关键词"

  # app/views/admin/categories/destroy.html.erb
  l.store "Are you sure you want to delete the category ", "确认删除此分类？"
  l.store "Delete this category", "删除分类"
  l.store "Categories", "分类"

  # app/views/admin/categories/index.html.erb
  l.store "New Category", "创建分类"

  # app/views/admin/categories/new.html.erb
  l.store "%s Category", "分类%s"

  # app/views/admin/categories/reorder.html.erb
  l.store "(Done)", "(完成)"

  # app/views/admin/content/_attachment.html.erb
  l.store "Remove", "移除"
  l.store "Currently this article has the following resources", "此文章附带了以下资源"
  l.store "You can associate the following resources", "你可以联结下列资源"
  l.store "Really delete attachment", "确定删除附件？"
  l.store "Add another attachment", "新增其他附件"

  # app/views/admin/content/_drafts.html.erb
  l.store "Drafts", "草稿"

  # app/views/admin/content/_form.html.erb
  l.store "Publish settings", "发布设定"
  l.store "Allow comments", "允许评论"
  l.store "Allow trackbacks", "允许引用"
  l.store "Password:", "密码"
  l.store "Publish", "发布"
  l.store "Tags", ""
  l.store "Separate tags with commas. Use double quotes (&quot;) around multi-word tags, e.g. &quot;opera house&quot;.", ""
  l.store "Excerpt", "摘要"
  l.store "Excerpts are post summaries that show only on your blog homepage and won’t appear on the post itself", "摘要对文章的总结，只会显示在首页，不会出现在文章正文。"
  l.store "Uploads", "上传"
  l.store "Post settings", "发布设定"
  l.store "Publish at", "公开"
  l.store "Permalink", "固定链接"
  l.store "Article filter", ""
  l.store "Save as draft", "保存为草稿"
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
  l.store "Are you sure you want to delete this article", "确定删除本篇文章？"
  l.store "Delete this article", "删除本篇文章"
  l.store "Articles", "文章"

  # app/views/admin/content/index.html.erb
  l.store "New Article", "新文章"
  l.store "Search articles that contain ...", "搜索包含内容的文章 ..."
  l.store "Search", "搜索"
  l.store "Author", "作者"
  l.store "Date", "日期"
  l.store "Feedback", "回应"
  l.store "Filter", "筛选"
  l.store "Manage articles", "文章管理"
  l.store "All articles", "所有文章"
  l.store "All Articles", "所有文章"
  l.store "Drafts", "草稿"
  l.store "Select a category", ""
  l.store "Select an author", ""
  l.store "Publication date", ""

  # app/views/admin/dashboard/_comments.html.erb
  l.store "Error: can't generate secret token. Security is at risk. Please, change %s content", ""
  l.store "For security reasons, you should restart your Typo application. Enjoy your blogging experience.", ""
  l.store "Latest Comments", "最近评论"
  l.store "No comments yet", "没有任何评论"
  l.store "By %s on %s", "%s在%s"

  # app/views/admin/dashboard/_inbound.html.erb
  l.store "Inbound links", "导入链接"
  l.store "No one made a link to you yet", "目前没有人链接到你"
  l.store " made a link to you saying ", "连接到你，并且说"
  l.store "You have no internet connection", "你没有连接到网络"

  # app/views/admin/dashboard/_overview.html.erb
  l.store "This place gives you a quick overview of what happens on your Typo blog and what you can do. Maybe will you want to %s, %s or %s.", "这里給你一個快速的概览，让你知道你的博客发生什么事情了。也许你想要%s， %s, %s"
  l.store "update your profile or change your password", "更新资料或者修改密码"
  l.store "You can also do a bit of design, %s or %s.", "你也可以做一些设计, %s或%s."
  l.store "change your blog presentation", "修改你的博客外观"
  l.store "If you need help, %s. You can also %s to customize your Typo blog.", "如果需要帮助，%s. 也可以%s来订制你的Typo博客。"
  l.store "enable plugins", "启动插件"
  l.store "write a post", "写一篇文章"
  l.store "write a page", "写一个页面"
  l.store "read our documentation", "阅读我们的文档"
  l.store "download some plugins", "下载插件"

  # app/views/admin/dashboard/_popular.html.erb
  l.store "Most popular", "最受欢迎"
  l.store "Nothing to show yet", "还没有东西"

  # app/views/admin/dashboard/_posts.html.erb
  l.store "Latest Posts", "最近发表"
  l.store "No posts yet, why don't you start and write one", "你还没有发表文章"

  # app/views/admin/dashboard/_typo_dev.html.erb
  l.store "Latest news from the Typo development blog", "Typo开发博客的最新消息"
  l.store "Oh no, nothing new", "没有新消息"

  # app/views/admin/dashboard/_welcome.html.erb
  l.store "Welcome back, %s!", "欢迎回來， %s！"
  l.store "%d articles and %d comments were posted since your last connexion", "在你上次离开后，新增%d篇文章和%d个评价"
  l.store "You're running Typo %s", "你正在使用的是Typo %s"
  l.store "Total posts : %d", "博文总计：%d"
  l.store "Your posts : %d", "你的文章：%d"
  l.store "Total comments : %d", "评论总计：%d"
  l.store "Spam comments : %d", "垃圾评论：%d"

  # app/views/admin/feedback/_button.html.erb
  l.store "Select action", ""
  l.store "Delete Checked Items", ""
  l.store "Delete all spam", ""
  l.store "Mark Checked Items as Spam", ""
  l.store "Mark Checked Items as Ham", ""
  l.store "All comments", ""
  l.store "Limit to ham", ""
  l.store "Unapproved comments", ""
  l.store "Limit to spam", "限制垃圾郵件"

  # app/views/admin/feedback/_form.html.erb
  l.store "Add a comment", ""
  l.store "Url", "Url"

  # app/views/admin/feedback/_spam.html.erb
  l.store "This comment by <strong>%s</strong> was flagged as spam, %s?", ""

  # app/views/admin/feedback/article.html.erb
  l.store "Comments for %s", ""
  l.store "Status", "状态"
  l.store "Comment Author", ""
  l.store "Comment", ""

  # app/views/admin/feedback/edit.html.erb
  l.store "Comments for", "做出评论"

  # app/views/admin/feedback/index.html.erb
  l.store "Search Comments and Trackbacks that contain", ""
  l.store "Article", ""

  # app/views/admin/pages/_form.html.erb
  l.store "Online", "上線"
  l.store "Page settings", ""
  l.store "Permanent link", ""

  # app/views/admin/pages/destroy.html.erb
  l.store "Pages","页数"
  l.store "Are you sure you want to delete the page", "你確定要刪除此頁？"
  l.store "Delete this page", "刪除此頁"

  # app/views/admin/pages/index.html.erb
  l.store "New Page", "新页面"
  l.store "Manage pages", "管理页面"

  # app/views/admin/profiles/index.html.erb
  l.store "Your profile", ""

  # app/views/admin/resources/_mime_edit.html.erb
  l.store "Content Type", "內容類型"

  # app/views/admin/resources/_pages.html.erb
  l.store "Previous page", "前一頁"
  l.store "Next page", "下一頁"

  # app/views/admin/resources/_upload.html.erb
  l.store "Upload a File to your Site", "上傳一個檔案到你的網點"
  l.store "File", "檔案"
  l.store "Upload", "上傳"

  # app/views/admin/resources/destroy.html.erb
  l.store "Are you sure you want to delete this file", "你確定要刪除此檔案？"
  l.store "Delete this file from the webserver?", "從網路伺服器刪除此檔案？"
  l.store "File Uploads", "檔案上載"

  # app/views/admin/resources/images.html.erb
  l.store "Thumbnail", ""
  l.store "File Size", "檔案大小"
  l.store "Images", ""
  l.store "right-click for link", "右鍵連結"

  # app/views/admin/resources/index.html.erb
  l.store "Filename", "檔案名稱"
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
  l.store "Enable comments by default", "預設為可以回應"
  l.store "Enable Trackbacks by default", "預設為可以引用"
  l.store "Enable feedback moderation", "適度可以反饋"
  l.store "You can enable site wide feedback moderation. If you do so, no comment or trackback will appear on your blog unless you validate it.", "你可以設定網點範圍有限度的反饋。這麼做將不會有任何评论引用出現在你的博客，除非你使之生效"
  l.store "Comments filter", "篩選评论"
  l.store "Enable gravatars", "可以顯示留言大頭貼"
  l.store "Show your email address", "秀出你的email位址"
  l.store "Notifications", ""
  l.store "Typo can notify you when new articles or comments are posted", "當新的文章或评论被貼上時typo會通知你"
  l.store "Source Email", "原始email"
  l.store "Email address used by Typo to send notifications", "email位址使用typo發出通知"
  l.store "Enabling spam protection will make Typo compare the IP address of posters as well as the contents of their posts against local and remote blacklists. Good defense against spam bots", "typo會根據張貼者IP的位址內容還有黑名單來有效防止垃圾郵件。好的防禦可以抑制垃圾郵寄"
  l.store "Enable spam protection", "有效防止垃圾郵件"
  l.store "Akismet Key", "Akismet鍵"
  l.store "Typo can (optionally) use the %s spam-filtering service.  You need to register with Akismet and receive an API key before you can use their service.  If you have an Akismet key, enter it here", "Typo隨意的使用 %s 篩選垃圾郵件服務。"
  l.store "Disable trackbacks site-wide", ""
  l.store "This setting allows you to disable trackbacks for every article in your blog.  It won't remove existing trackbacks, but it will prevent any further attempt to add a trackback anywhere on your blog.", "此設定可以讓你博客裡的文章停止引用，這個舉動並不會刪除存在的引用，但是會阻止將來你要試圖增加的引用"
  l.store "Disable comments after", "在失效的评论之後"
  l.store "days", "日期"
  l.store "Set to 0 to never disable comments", "設定0為絕不失效的评论"
  l.store "Max Links", "最大的連結值"
  l.store "Typo will automatically reject comments and trackbacks which contain over a certain amount of links in them", "Typo會自動回絕评论和引用，包含某些可靠的連結總數"
  l.store "Set to 0 to never reject comments", "設定0回絕不回絕的评论"
  l.store "Feedback settings", ""

  # app/views/admin/settings/index.html.erb
  l.store "Your blog", "你的博客"
  l.store "Blog name", "博客名稱"
  l.store "Blog subtitle", "副標題"
  l.store "Blog URL", "博客URL"
  l.store "Language", "言語"
  l.store "Allow users to register", ""
  l.store "You can allow users to register to your blog. By default, they will register as contributors, an unpriviledged account level which grant them no rights but own a profile on the site. If you don't want users to register, you can thus add them by yourself in the users part of this admin.", ""
  l.store "Items to display in admin lists", ""
  l.store "Publishing options", ""
  l.store "Display", "顯示"
  l.store "articles on my homepage by default", "預設的首頁文章"
  l.store "articles in my news feed by default", "預設的feed文章"
  l.store "Show full article on feed", "顯示全部feed文章"
  l.store "Feedburner ID", ""
  l.store "General settings", "一般設定"
  l.store "You can use your Google Feedburner account instead of Typo feed URL. To enable this, fill this form with your Feedburner ID.", ""

  # app/views/admin/settings/seo.html.erb
  l.store "Search Engine Optimisation", "SEO"
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
  l.store "Information", "資訊"
  l.store "Current database version", "當前的資料庫版本"
  l.store "New database version", "新資料庫版本"
  l.store "Your database supports migrations", "你的資料庫支援移動"
  l.store "Needed migrations", "必要的移動"
  l.store "You are up to date!", "你現在是最新的狀態"
  l.store "Update database now", "現在更新資料庫"
  l.store "may take a moment", "需要稍等一下"
  l.store "Database migration", "資料庫移動"
  l.store "yes", "确认"
  l.store "no", "取消"

  # app/views/admin/settings/write.html.erb
  l.store "Send trackbacks", "引用發送"
  l.store "When publishing articles, Typo can send trackbacks to websites that you link to. This should be disabled for private blogs as it will leak non-public information to sites that you're discussing. For public blogs, there's no real point in disabling this.", "當公開的文章或引用會洩漏你私人的資訊時，對於不公開的博客typo會終止連結。在公開的博客並無此選項"
  l.store "URLs to ping automatically", "URL自動地Ping"
  l.store "Latitude, Longitude", "緯度,經度"
  l.store "your latitude and longitude", "你的緯度、經度"
  l.store "example", "舉例"
  l.store "Write", "寫入"

  # app/views/admin/sidebar/_availables.html.erb
  l.store "You have no plugins installed", "你没有plugins可以安置"

  # app/views/admin/sidebar/_publish.html.erb
  l.store "Changes published", "公開變更"

  # app/views/admin/sidebar/_target.html.erb
  l.store "Drag some plugins here to fill your sidebar", "拖曳一些plugins填滿你的sidebar"

  # app/views/admin/sidebar/index.html.erb
  l.store "Drag and drop to change the sidebar items displayed on this blog. To remove items from the sidebar just click 'remove'. Changes are saved immediately, but not activated until you click the 'Publish changes' button", "在這個博客顯示拖曳改變的sidebar選項。從sidebar選項移除會立即存檔，但是不會執行直到你輸入<公開>鍵"
  l.store "Available Items", "可用的項目"
  l.store "Active Sidebar items", "有效的側邊欄項目"
  l.store "Get more plugins", ""
  l.store "Sidebar", ""
  l.store "Publish changes", "公開變更"
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
  l.store "Display name", "暱稱"

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
  l.store "Active theme", "執行中主題"
  l.store "Choose a theme", "選擇主題"
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
  l.store "Send notification messages via email", "經由email發出通知訊息"
  l.store "Send notification messages when new articles are posted", "新的文章貼上時發出通知訊息"
  l.store "Send notification messages when comments are posted", "新的評錀貼上時發出通知訊息"
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
  l.store "Really delete user", "確定刪除使用者"
  l.store "Yes", ""
  l.store "Users", "使用者"

  # app/views/admin/users/edit.html.erb
  l.store "Edit User", "修改使用者"

  # app/views/admin/users/index.html.erb
  l.store "New User", "新的使用者"
  l.store "Comments", "评论"
  l.store "State", ""
  l.store "%s user", ""
  l.store "Manage users", ""

  # app/views/admin/users/new.html.erb
  l.store "Add User", ""

  # app/views/articles/_article.html.erb
  l.store "Posted by", "貼上"
  l.store "Continue reading", ""

  # app/views/articles/_comment.html.erb
  l.store "said", "發言"
  l.store "This comment has been flagged for moderator approval.  It won't appear on this blog until the author approves it", "這篇评论被標示為版主所允許的。他不會在博客顯示直到版主承認他。"

  # app/views/articles/_comment_box.html.erb
  l.store "Your name", "你的名稱"
  l.store "Your email", "你的email"
  l.store "Your message", "你的訊息"
  l.store "Comment Markup Help", "评论顯示協助"
  l.store "Preview comment", "預覽评论"
  l.store "leave url/email", ""

  # app/views/articles/_comment_failed.html.erb
  l.store "Oops, something wrong happened, the comment could not be saved", ""

  # app/views/articles/_trackback.html.erb
  l.store "From", "From"

  # app/views/articles/archives.html.erb
  l.store "No articles found", "没有找到任何文章"
  l.store "posted in", "发表在"

  # app/views/articles/comment_preview.html.erb
  l.store "is about to say", "这是关于~~"

  # app/views/articles/groupings.html.erb
  l.store "There are", "有"

  # app/views/articles/read.html.erb
  l.store "Leave a response", "離開一個回應"
  l.store "Trackbacks", "引用"
  l.store "Use the following link to trackback from your own site", "從你所屬的網點用隨後的連結去引用"
  l.store "RSS feed for this post", "為本篇提供RSS"
  l.store "trackback uri", "引用URL"
  l.store "Comments are disabled", "评论停用"
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
  l.store "Help", ""
  l.store "Documentation", ""
  l.store "Report a bug", ""
  l.store "In page plugins", ""
  l.store "Sidebar plugins", ""
  l.store "is proudly powered by", ""
  l.store "Dashboard", "管理面板"

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
  l.store "Home", "首页"
  l.store "About", "关于"
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
  l.store "Trackbacks for", "作為引用"

  # themes/true-blue-3/views/articles/search.html.erb
  l.store "Search results for:", ""

  # themes/true-blue-3/views/categories/index.html.erb
  l.store "Read all articles in %s", ""

  # themes/true-blue-3/views/categories/show.html.erb
  l.store "Previous", ""
  l.store "Next", ""

  # vendor/plugins/archives_sidebar/views/content.rhtml
  l.store "Archives", "归档"

  # vendor/plugins/authors_sidebar/views/content.rhtml
  l.store "Authors", ""

  # vendor/plugins/xml_sidebar/views/content.rhtml
  l.store "Syndicate", "整合發表"
  l.store "Category %s", ""
  l.store "Tag %s", ""

  # Obsolete translations
  l.store "A new message was posted to ", "一個新的訊息已被貼上"
  l.store "AIM Presence", "AIM存在"
  l.store "AIM Status", "AIM身分"
  l.store "Action", "開始行動"
  l.store "Activate", "執行中"
  l.store "Add MetaData", "新增MetaData"
  l.store "Add category", "新增分类"
  l.store "Add new user", "新增使用者"
  l.store "Add pattern", "新增樣式"
  l.store "Advanced settings", "進階設定"
  l.store "Allow non-ajax comments", "允許non-ajax评论"
  l.store "Are you sure you want to delete this filter", "你確定要刪除此篩選器？"
  l.store "Are you sure you want to delete this item?", "确认刪除？"
  l.store "Article Attachments", "文章附件"
  l.store "Article Body", "文章主體"
  l.store "Article Content", " 文章內容"
  l.store "Article Options","文章選項"
  l.store "Articles in", "記事"
  l.store "Attachments", "附件"
  l.store "Back to the blog", "回到博客"
  l.store "Basic settings", "基本設定"
  l.store "Blacklist", "列入黑名單"
  l.store "Blacklist Patterns", "黑名單樣式"
  l.store "Blog advanced settings", "博客進階設定"
  l.store "Blog settings", "博客設定"
  l.store "Body", "本文主體"
  l.store "Cache", "儲存"
  l.store "Cache was cleared", "cache已清除"
  l.store "Category", "分类"
  l.store "Category could not be created.", "分类不能被設定"
  l.store "Category title", "分类標題"
  l.store "Category was successfully created.", "分类已成功設定"
  l.store "Category was successfully updated.", "分类已成功更新"
  l.store "Change you blog presentation", "修改外觀"
  l.store "Choose password", "密码"
  l.store "Comments and Trackbacks for", "作為评论和引用"
  l.store "Confirm password", "密码确认"
  l.store "Copyright Information", "著作權資訊"
  l.store "Create new Blacklist", "建立黑名單"
  l.store "Create new category", "增加新的分类"
  l.store "Create new page", "設計新的一頁"
  l.store "Create new text filter", "設計新的本文篩選器"
  l.store "Creating comment", "設計评论"
  l.store "Creating text filter", "建立本文篩選器"
  l.store "Creating trackback", "設計引用中"
  l.store "Creating user", "設定使用者"
  l.store "Currently this article has the following ", "將本篇文章接在下列"
  l.store "Currently this article is listed in following categories", "將本篇文章列在以下分类中"
  l.store "Customize Sidebar", "定製側邊欄"
  l.store "Delete this filter", "刪除此篩選器"
  l.store "Design", "設計"
  l.store "Desired login", "登入名稱"
  l.store "Discuss", "詳述"
  l.store "Do you want to go to your blog?", "進入您的博客？"
  l.store "Duration", "持續時間"
  l.store "Edit Article", "修改文章"
  l.store "Edit MetaData", "修改MetaData"
  l.store "Edit this article", "修改本篇文章"
  l.store "Edit this category", "類目編輯"
  l.store "Edit this filter", "修改此篩選器"
  l.store "Edit this page", "修改此頁"
  l.store "Edit this trackback", "修改此引用"
  l.store "Editing User", "修改使用者中中"
  l.store "Editing category", "修改分类"
  l.store "Editing comment", "修改评论"
  l.store "Editing page", "修改頁面中"
  l.store "Editing pattern", "修改樣式"
  l.store "Editing textfilter", "修改本文篩選器"
  l.store "Editing trackback", "修改引用"
  l.store "Empty Fragment Cache", "清空零碎儲存體"
  l.store "Enable plugins", "Enable plugins"
  l.store "Explicit", "Explicit"
  l.store "Extended Content", "擴增內容"
  l.store "Feedback Search", "信息反饋搜尋"
  l.store "Filters", "篩選器"
  l.store "General Settings", "一般設定"
  l.store "HTML was cleared", "HTML已清除"
  l.store "IP", "IP"
  l.store "Jabber", "Jabber"
  l.store "Jabber account", "Jabber帳目"
  l.store "Jabber account to use when sending Jabber notifications", "當發出jabber通知時使用jabber帳目"
  l.store "Jabber password", "Jabber密码"
  l.store "Key Words", "輸入"
  l.store "Last Comments", "最新评论"
  l.store "Last posts", "最新文章"
  l.store "Last updated", "上一次更新"
  l.store "Latest posts", "最近發文"
  l.store "Limit to unconfirmed", "限制未許可的"
  l.store "Limit to unconfirmed spam", "限制未許可的垃圾郵件"
  l.store "Location", "位置"
  l.store "Logoff", "退出系統"
  l.store "Macro Filter Help", "巨集篩選器協助"
  l.store "Macros", "巨集"
  l.store "Manage", "管理"
  l.store "Manage Articles", "管理文章"
  l.store "Manage Categories", "分类管理"
  l.store "Manage Pages", "管理頁面"
  l.store "Manage Resources", "管理資源"
  l.store "Manage Text Filters", "管理文字過濾"
  l.store "Markup", "審定"
  l.store "Markup type", "審定類型"
  l.store "MetaData", "MetaData"
  l.store "Metadata was successfully removed.", "Metadata已成功被移除"
  l.store "New post", "新的上傳"
  l.store "Not published by Apple", "非經由Apple所發布"
  l.store "Notification", "回報通知"
  l.store "Notified", "通知"
  l.store "Notify on new articles", "新文章通知"
  l.store "Notify on new comments", "新评论通知"
  l.store "Notify via email", "經由email通知"
  l.store "Number of Articles", "文章編號"
  l.store "Number of Comments", "评论編號"
  l.store "Offline", "下線"
  l.store "Older posts", "從前貼上的"
  l.store "Optional Extended Content", "選擇延續內容"
  l.store "Optional Name", "隨意的命名"
  l.store "Optional extended content", "選擇擴增內容"
  l.store "Page Body", "頁面本文"
  l.store "Page Content", "頁面內容"
  l.store "Page Options", "頁面選擇"
  l.store "Parameters", "參數"
  l.store "Password Confirmation", "密码确认"
  l.store "Pattern", "樣式"
  l.store "Pictures from", "圖像顯示從~"
  l.store "Post", "Post"
  l.store "Post title", "貼上標題"
  l.store "Post-processing filters", "篩選上傳處理"
  l.store "Posted at", "上傳"
  l.store "Posted date", "貼上日期"
  l.store "Posts", "貼出 "
  l.store "Preview Article", "先前文章"
  l.store "Read", "讀取"
  l.store "Read more", "閱讀更多"
  l.store "Rebuild cached HTML", "重建HTML儲存體"
  l.store "Recent comments", "最近评论"
  l.store "Recent trackbacks", "最近引用"
  l.store "Regex", "正規表示法"
  l.store "Remove iTunes Metadata", "移除iTunes Metadata"
  l.store "Resource MetaData", "MetaData資源"
  l.store "Resource Settings", "資源設定"
  l.store "Save Settings", "儲存設定"
  l.store "See help text for this filter", "查看協助針對此篩選器"
  l.store "Set iTunes metadata for this enclosure", "設定附件的iTunes metadata"
  l.store "Setting for channel", "設定頻道"
  l.store "Settings", "設定"
  l.store "Show Help", "顯示協助"
  l.store "Show this article", "秀出文章"
  l.store "Show this category", "秀出分类"
  l.store "Show this comment", "秀出评论"
  l.store "Show this page", "秀出此頁"
  l.store "Show this pattern", "秀出樣式"
  l.store "Show this user", "顯示使用者"
  l.store "Spam Protection", "垃圾郵件防護"
  l.store "Spam protection", "防止垃圾郵件"
  l.store "Statistics", "統計資訊"
  l.store "String", "字串"
  l.store "Subtitle", "副標題"
  l.store "Summary", "概要"
  l.store "System information", "系統資訊"
  l.store "Text Filter Details", "本文篩選器細節"
  l.store "Text Filters", "本文篩選器"
  l.store "Textfilter", "文章篩選"
  l.store "The below settings act as defaults when you choose to publish an enclosure with iTunes metadata", "當你決定藉iTunes metadata來發佈一個附件，以下行為會被當成預設的"
  l.store "There are %d entries in the cache", "儲存體裡有全部的%d"
  l.store "There are %d entries in the page cache", "有%d個項目在Cache中"
  l.store "Things you can do", "你可以做的事"
  l.store "This option let you choose between the simple admin interface or the complete one, displaying much more options and therefore more complicated to use. For advanced users only.", "只讓進階使用者選擇簡單或完整的界面，顯示更多更複雜的選項"
  l.store "Toggle Extended Content", "切換擴增內容"
  l.store "Type", "型態"
  l.store "Typo admin", "Typo管理員"
  l.store "Typo documentation", "Typo文件"
  l.store "Update your profile or change your password", "請更新您的個人資料或者修改密码"
  l.store "Upload a new File", "上載一個新檔案"
  l.store "Upload a new Resource", "上傳一個新的資源"
  l.store "Uploaded", "上載"
  l.store "User's articles", "使用者文章"
  l.store "View", "查看"
  l.store "View article on your blog", "在你的博客查看文章"
  l.store "View comment on your blog", " 查看评论"
  l.store "View page on your blog", "在你的博客查看頁面"
  l.store "What can you do ?", "你可以做什麼？"
  l.store "Which settings group would you like to edit", "你要修改哪一個設定群組？"
  l.store "Write Page", "撰寫頁面"
  l.store "Write Post", "寫博客"
  l.store "Write a Page", "編寫本頁"
  l.store "Write an Article", "編寫文章"
  l.store "XML Syndication", "XML簡易整合"
  l.store "You are now logged out of the system", "您已經登出系統"
  l.store "You can add it to the following categories", "你可以新增至以下分类中"
  l.store "You can optionally disable non-Ajax comments. Typo will always use Ajax for comment submission if Javascript is enabled, so non-Ajax comments are either from spammers or users without Javascript.", "你可以隨意地讓non-Ajax评论無效。如果Javascript是有效的，對於提交评论typo會使用ajax，所以non-Ajax的评论是因為使用者或spammper没有使用Javascript。"
  l.store "add new", "新增"
  l.store "by", "by"
  l.store "by %s on %s", "由%s在%s"
  l.store "log out", "登出"
  l.store "no ", "no "
  l.store "on", "の"
  l.store "seperate with spaces", "空間區分"
  l.store "via email", "經由email"
  l.store "with %s Famfamfam iconset %s", "%s 個Famfamfam iconset %s"
  l.store "your blog", "你的博客"
end
