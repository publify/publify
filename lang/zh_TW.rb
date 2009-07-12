Localization.define('zh_TW') do |l|
  # General
  l.store "your blog", "你的部落格"
  l.store "Typo admin", "Typo管理員"
  l.store "Publish", "公開"
  l.store "Manage", "管理"
  l.store "Feedback", "回應"
  l.store "Design", "設計"
  l.store "Users", "使用者"
  l.store "Settings", "設定"
  l.store "Things you can do", "你可以做的事"
  l.store "with %s Famfamfam iconset %s", "%s 個Famfamfam iconset %s"

  #admin/login.rhtml
  l.store "Username", "名稱"
  l.store "Password", "密碼"
  l.store "Login", "登入"
  l.store "Back to the blog", "回到部落格"

  # admin/logout.rhtml
  l.store "You are now logged out of the system", "您已經登出系統"
  l.store "Do you want to go to your blog?", "進入您的部落格？"
  l.store "Logoff", "退出系統"

  # admin/signup.rhtml
  l.store "Signup", "註冊"
  l.store "Desired login", "登入名稱"
  l.store "Display name", "暱稱"
  l.store "Email", "Email"
  l.store "Choose password", "密碼"
  l.store "Confirm password", "密碼確認"

  # admin/dashboard/index.rhtml
  l.store "What can you do ?", "你可以做什麼？"
  l.store "Write Post", "寫部落格"
  l.store "Write Page", "撰寫頁面"
  l.store "Update your profile or change your password", "請更新您的個人資料或者修改密碼"
  l.store "Change you blog presentation", "修改外觀"
  l.store "Enable plugins", "Enable plugins"
  l.store "Last Comments", "最新評論"
  l.store "Last posts", "最新文章"
  l.store "Most popular", "人氣文章"
  l.store "Typo documentation", "Typo文件"
  l.store "No comments yet", "沒有任何評論"
  
  # app/views/admin/dashboard/_comments.html.erb
  l.store "Latest Comments", "最近評論"
  l.store "No comments yet", "沒有任何評論"
  l.store "by %s on %s", "由%s在%s"

  # app/views/admin/dashboard/_inbound.html.erb
  l.store "Inbound links", "導入連結"
  l.store "No one made a link to you yet", "目前沒有人連結到你"
  l.store " made a link to you saying ", "連結到你，並且說"
  l.store "You have no internet connection", "你沒有連結到網路"

  # app/views/admin/dashboard/_overview.html.erb
  l.store "This place gives you a quick overview of what happens on your Typo blog and what you can do. Maybe will you want to %s, %s or %s.", "這個地方給你一個快速的綜覽，讓你知道你的部落格發生甚麼事情了。也許你想要%s， %s或%s"
  l.store "update your profile or change your password", "更新資料或者修改密碼"
  l.store "You can also do a bit of design, %s or %s.", "你也可以作一些設計, %s或%s."
  l.store "change your blog presentation", "修改你的部落格外觀"
  l.store "enable plugins", "啟動plugins"
  l.store "write a post", "寫一篇文章"
  l.store "write a page", "寫一個頁面"

  # app/views/admin/dashboard/_popular.html.erb
  l.store "Most popular", "最受歡迎"
  l.store "Nothing to show yet", "還沒有東西"

  # app/views/admin/dashboard/_posts.html.erb
  l.store "Latest posts", "最近發文"
  l.store "No posts yet, why don't you start and write one", "你還沒有發文"

  # app/views/admin/dashboard/_sysinfo.html.erb
  l.store "System information", "系統資訊"
  l.store "You're running Typo %s", "你現在是使用Typo %s"
  l.store "Statistics", "統計資訊"
  l.store "Total posts : %d", "發文總計：%d"
  l.store "Your posts : %d", "你的發文：%d"
  l.store "Total comments : %d", "評論總計：%d"
  l.store "Spam comments : %d", "垃圾評論：%d"

  # app/views/admin/dashboard/_typo_dev.html.erb
  l.store "Latest news from the Typo development blog", "Typo開發部落格的最新消息"
  l.store "Oh no, nothing new", "沒有新訊息"
  
  # admin/dashboard/_overview.html.erb
  l.store "Welcome back, %s!", "歡迎回來， %s！"

  #admin/base/recent_comments.rhtml
  l.store "Recent comments", "最近評論"

  #admin/base/recent_trackbacks.rhtml
  l.store "Recent trackbacks", "最近引用"

  #admin/blacklist/_blacklis_patterns.rhtml
  l.store "Pattern", "樣式"
  l.store "Type", "型態"
  l.store "Edit", "修改"
  l.store "Delete", "刪除"

  #admin/blacklist/_form.rhtml
  l.store "String", "字串"
  l.store "Regex", "正規表示法"

  #admin/blacklist/_quick_post.rhtml
  l.store "Add pattern", "新增樣式"
  l.store "Cancel", "取消"
  l.store "or", "或"

  #admin/blacklist/destroy.rhtml
  l.store "Blacklist Patterns", "黑名單樣式"
  l.store "Show this pattern", "秀出樣式"
  l.store "Are you sure you want to delete this item?", "確認刪除？"

  #admin/blacklist/edit.rhtml
  l.store "Editing pattern", "修改樣式"

  #admin/blacklist/list.rhtml
  l.store "Create new Blacklist", "建立黑名單"

  #admin/cache/list.rhtml
  l.store "Cache", "Cache"
  l.store "There are %d entries in the page cache", "有%d個項目在Cache中"

  #admin/categories/_categories.rhtml
  l.store "Category title", "分類標題"
  l.store "Articles", "文章"

  #admin/categories/_form.rhtml
  l.store "Name", "名字"

  #admin/categories/_quick_post.rhtml
  l.store "Title", "標題"
  l.store "Add category", "新增分類"

  #admin/categorie/destroy.rhtml
  l.store "Categories", "分類"
  l.store "Show this category", "秀出分類"
  l.store "Delete this category", "刪除分類"
  l.store "Are you sure you want to delete the category ", "確認刪除此分類？ "

  #admin/category/list.html.erb
  l.store "add new", "新增"

  #admin/category/edit.rhtml
  l.store "Editing category", "修改分類"

  #admin/category/list.rhtml
  l.store "Manage Categories", "分類管理"
  l.store "Create new category", "增加新的分類"
  l.store "Reorder", "重新排序"
  l.store "Sort alphabetically", "依字母順序排序"
  l.store "Manage Articles", "管理文章"
  l.store "Manage Pages", "管理頁面"
  l.store "Manage Resources", "管理資源"

  #admin/category/reorder.rhtml
  l.store "(Done)", "(完成)"

  #admin/category/show
  l.store "Edit this category", "類目編輯"
  l.store "Articles in", "記事"

  #admin/comments/_form.rhtml
  l.store "Author", "作者" 
  l.store "Url", "Url"
  l.store "Body", "本文主體" 

  #admin/comments/comments.rhtml
  l.store "on", "の"

  #admin/comments/destroy.rhtml
  l.store "Comments for", "做出評論" 

  #admin/comments/edit.rhtml
  l.store "Show this comment", "秀出評論" 
  l.store "View comment on your blog", " 查看評論"
  l.store "Editing comment", "修改評論" 

  #admin/comments/list.rhtml
  l.store "IP", "IP"
  l.store "Posted date", "貼上日期" 

  #admin/comments/new.rhtml
  l.store "Creating comment", "設計評論" 

  #admin/content/_articles.rhtml
  l.store "Posts", "貼出 "
  l.store "Uploads", "上載" 
  l.store "Post title", "貼上標題" 
  l.store "Posted at", "上傳"  
  l.store "Comments", "評論" 
  l.store "Trackbacks", "引用" 
  l.store "View", "查看" 
  l.store "Status", "身分" 
  l.store "Offline", "下線" 
  l.store "Online", "上線" 
  l.store "no trackbacks", "沒有引用" 
  l.store "no comments", "沒有評論" 

  #admin/content/_attachment.rhtml
  l.store "Remove", "移除"
  l.store "Really delete attachment", "確定刪除附件？" 
  l.store "Add Another Attachment", "新增其他附件" 

  #admin/content/_form.rhtml
  l.store "Article Body", "文章主體"
  l.store "Post", "Post"
  l.store "Optional extended content", "選擇擴增內容" 
  l.store "Optional Extended Content", "選擇延續內容" 
  l.store "Article Content", " 文章內容"
  l.store "Extended Content", "擴增內容" 
  l.store "Tags", "標籤" 
  l.store "Save", "存檔" 
  l.store "Article Attachments", "文章附件" 
  l.store "Article Options","文章選項"
  l.store "Permalink", "固定連接" 
  l.store "Allow comments", "允許評論" 
  l.store "Allow trackbacks", "允許引用" 
  l.store "Published", "已公開的" 
  l.store "Publish at", "公開" 
  l.store "Textfilter", "文章篩選" 
  l.store "Toggle Extended Content", "切換擴增內容" 

  #admin/content/_pages.rhtml
  l.store "Previous page", "前一頁"
  l.store "Next page", "下一頁" 

  #admin/content/_show_categories.rhtml
  l.store "Currently this article is listed in following categories", "將本篇文章列在以下分類中"
  l.store "You can add it to the following categories", "你可以新增至以下分類中"

  #admin/content/_show_ressources.rhtml
  l.store "Currently this article has the following ", "將本篇文章接在下列"
  l.store "You can associate the following resources", "你可以連結下列資源"

  #admin/content/destroy.rhtml
  l.store "Show this article", "秀出文章"
  l.store "Are you sure you want to delete this article", "確定刪除本篇文章？"
  l.store "Delete this article", "刪除本篇文章"

  #admin/content/edit.rhtml
  l.store "Edit Article", "修改文章"
  l.store "View article on your blog", "在你的部落格查看文章"

  #admin/content/new.rhtml
  l.store "Write a Page", "編寫本頁"
  l.store "Write an Article", "編寫文章"

  #admin/content/preview.rhtml
  l.store "Posted by", "貼上"

  #admin/content/show.rhtml
  l.store "Preview Article", "先前文章"
  l.store "Edit this article", "修改本篇文章"
  l.store "Last updated", "上一次更新"
  l.store "Attachments", "附件"

  #admin/feedback/list.rhtml
  l.store "Limit to spam", "限制垃圾郵件"
  l.store "Limit to unconfirmed", "限制未許可的"
  l.store "Limit to unconfirmed spam", "限制未許可的垃圾郵件"
  l.store "Blacklist", "列入黑名單"
  l.store "Feedback Search", "信息反饋搜尋"
  l.store "Comments and Trackbacks for", "作為評論和引用"

  #admin/general/task
  l.store "Basic settings", "基本設定"
  l.store "Advanced settings", "進階設定"
  l.store "Blog advanced settings", "部落格進階設定"

  #admin/general/index.rhtml
  l.store "Blog settings", "部落格設定"
  l.store "Which settings group would you like to edit", "你要修改哪一個設定群組？"
  l.store "General settings", "一般設定"
  l.store "General Settings", "一般設定"
  l.store "Read", "讀取"
  l.store "Write", "寫入"
  l.store "Discuss", "詳述"
  l.store "Notification", "回報通知"
  l.store "Spam Protection", "垃圾郵件防護"
  l.store "Resource Settings", "資源設定"
  l.store "Cache", "儲存"
  l.store "Blog name", "部落格名稱"
  l.store "Blog subtitle", "副標題"
  l.store "Language", "言語"
  l.store "This option let you choose between the simple admin interface or the complete one, displaying much more options and therefore more complicated to use. For advanced users only.", "只讓進階使用者選擇簡單或完整的界面，顯示更多更複雜的選項"
  l.store "Blog URL", "部落格URL"
  l.store "Latitude, Longitude", "緯度,經度"
  l.store "Display", "顯示"
  l.store "your lattitude and longitude", "你的緯度、經度"
  l.store "exemple", "舉例"
  l.store "Search Engine Optimisation", "SEO"
  l.store "Show blog name", "顯示部落格名稱"
  l.store "At the beginning of page title", "頁首標題"
  l.store "At the end of page title", "頁末標題"
  l.store "Don't show blog name in page title", "頁面標題不要秀出部落格名稱"
  l.store "Save Settings", "儲存設定"
  l.store "articles on my homepage by default", "預設的首頁文章"
  l.store "articles in my news feed by default", "預設的feed文章"
  l.store "Show full article on feed", "顯示全部feed文章"
  l.store "Article filter", "篩選文章"
  l.store "Comments filter", "篩選評論"
  l.store "When publishing articles, Typo can send trackbacks to websites that you link to. This should be disabled for private blogs as it will leak non-public information to sites that you're discussing. For public blogs, there's no real point in disabling this.", "當公開的文章或引用會洩漏你私人的資訊時，對於不公開的部落格typo會終止連結。在公開的部落格並無此選項"
  l.store "Send trackbacks", "引用發送"
  l.store "URLs to ping automatically", "URL自動地Ping"
  l.store "This setting allows you to disable trackbacks for every article in your blog.  It won't remove existing trackbacks, but it will prevent any further attempt to add a trackback anywhere on your blog.", "此設定可以讓你部落格裡的文章停止引用，這個舉動並不會刪除存在的引用，但是會阻止將來你要試圖增加的引用"
  l.store "Disable trackbacks site-wide" ,"喪失網點範圍的引用"
  l.store "Enable Trackbacks by default", "預設為可以引用"
  l.store "You can enable site wide feeback moderation. If you do so, no comment or trackback will appear on your blog unless you validate it", "你可以設定網點範圍有限度的反饋。這麼做將不會有任何評論引用出現在你的部落格，除非你使之生效"
  l.store "Enable feedback moderation", "適度可以反饋"
  l.store "Enable comments by default", "預設為可以回應"
  l.store "Show your email address", "秀出你的email位址"
  l.store "Enable gravatars", "可以顯示留言大頭貼"
  l.store "You can optionally disable non-Ajax comments. Typo will always use Ajax for comment submission if Javascript is enabled, so non-Ajax comments are either from spammers or users without Javascript.", "你可以隨意地讓non-Ajax評論無效。如果Javascript是有效的，對於提交評論typo會使用ajax，所以non-Ajax的評論是因為使用者或spammper沒有使用Javascript。"
  l.store "Allow non-ajax comments", "允許non-ajax評論"
  l.store "Disable comments after", "在失效的評論之後"
  l.store "Set to 0 to never disable comments", "設定0為絕不失效的評論"
  l.store "Typo will automatically reject comments and trackbacks which contain over a certain amount of links in them", "Typo會自動回絕評論和引用，包含某些可靠的連結總數"
  l.store "Max Links", "最大的連結值"
  l.store "Set to 0 to never reject comments", "設定0回絕不回絕的評論"
  l.store "Typo can notify you when new articles or comments are posted", "當新的文章或評論被貼上時typo會通知你"
  l.store "Source Email", "原始email"
  l.store "Email address used by Typo to send notifications", "email位址使用typo發出通知"
  l.store "Jabber account", "Jabber帳目"
  l.store "Jabber account to use when sending Jabber notifications", "當發出jabber通知時使用jabber帳目"
  l.store "Jabber password", "Jabber密碼"
  l.store "Spam protection", "防止垃圾郵件"
  l.store "Enabling spam protection will make typo compare the IP address of posters as well as the contents of their posts against local and remote blacklists. Good defense against spam bots", "typo會根據張貼者IP的位址內容還有黑名單來有效防止垃圾郵件。好的防禦可以抑制垃圾郵寄"
  l.store "Enable spam protection", "有效防止垃圾郵件"
  l.store "Typo can (optionally) use the %s spam-filtering service.  You need to register with Akismet and receive an API key before you can use their service.  If you have an Akismet key, enter it here", "Typo隨意的使用 %s 篩選垃圾郵件服務。"
  l.store "Akismet Key", "Akismet鍵"
  l.store "The below settings act as defaults when you choose to publish an enclosure with iTunes metadata", "當你決定藉iTunes metadata來發佈一個附件，以下行為會被當成預設的"
  l.store "Subtitle", "副標題"
  l.store "Summary", "概要"
  l.store "Setting for channel", "設定頻道"
  l.store "Optional Name", "隨意的命名"
  l.store "Not published by Apple", "非經由Apple所發布"
  l.store "Copyright Information", "著作權資訊"
  l.store "Explicit", "Explicit"
  l.store "Empty Fragment Cache", "清空零碎儲存體"
  l.store "Rebuild cached HTML", "重建HTML儲存體"
  l.store "There are %d entries in the cache", "儲存體裡有全部的%d"
  l.store "days", "日期"

  #admin/general/update_database
  l.store "Database migration", "資料庫移動"
  l.store "Information", "資訊"
  l.store "Current database version", "當前的資料庫版本"
  l.store "New database version", "新資料庫版本"
  l.store "Your database supports migrations", "你的資料庫支援移動"
  l.store "yes", "確認"
  l.store "no", "取消"
  l.store "Needed migrations", "必要的移動"
  l.store "You are up to date!", "你現在是最新的狀態"
  l.store "Update database now", "現在更新資料庫"
  l.store "may take a moment", "需要稍等一下"
  l.store "config updated.", "更新設定"

  #admin/pages/_form.rhtml
  l.store "Page Body", "頁面本文"
  l.store "Page Content", "頁面內容"
  l.store "Location", "位置"
  l.store "Page Options", "頁面選擇"

  #admin/pages/_pages.rhtml
l.store "Action", "開始行動"
  l.store "Pages","頁數"
  l.store "Show this page", "秀出此頁"
  l.store "Are you sure you want to delete the page", "你確定要刪除此頁？"
  l.store "Delete this page", "刪除此頁"

  #admin/pages/edit.rhtml
  l.store "Create new page", "設計新的一頁"
  l.store "View page on your blog", "在你的部落格查看頁面"
  l.store "Editing page", "修改頁面中"
  l.store "Manage Text Filters", "管理文字過濾"

  #admin/pages/show.rhtml
  l.store "Edit this page", "修改此頁"
  l.store "by", "by"

  #admin/ressources/_metadata_add.rhtml
  l.store "Resource MetaData", "MetaData資源"
  l.store "Set iTunes metadata for this enclosure", "設定附件的iTunes metadata"
  l.store "Duration", "持續時間"
  l.store "Key Words", "輸入"
  l.store "seperate with spaces", "空間區分"
  l.store "Category", "分類"

  #admin/resources/_metadata_edit.rhtml
  l.store "Remove iTunes Metadata", "移除iTunes Metadata"
  l.store "Content Type", "內容類型"

  #admin/resources/_resources.rhtml
  l.store "Filename", "檔案名稱"
  l.store "right-click for link", "右鍵連結"
  l.store "MetaData", "MetaData"
  l.store "File Size", "檔案大小"
  l.store "Uploaded", "上載"
  l.store "Edit MetaData", "修改MetaData"
  l.store "Add MetaData", "新增MetaData"

  #admin/resources/destroy.rhtml
  l.store "File Uploads", "檔案上載"
  l.store "Upload a new File", "上載一個新檔案"
  l.store "Are you sure you want to delete this file", "你確定要刪除此檔案？"
  l.store "Delete this file from the webserver?", "從網路伺服器刪除此檔案？"

  #admin/resources/new.rhtml
  l.store "Upload a File to your Site", "上傳一個檔案到你的網點"
  l.store "Upload", "上傳"
  l.store "Upload a new Resource", "上傳一個新的資源"
  l.store "File", "檔案"

  #admin/sidebar/_avaliables.rhtml
  l.store "You have no plugins installed", "你沒有plugins可以安置"

  #admin/sidebar/_publish.rhtml
  l.store "Changes published", "公開變更"

  #admin/sidebar/_target.rhtml
  l.store "Drag some plugins here to fill your sidebar", "拖曳一些plugins填滿你的sidebar"

  #admin/sidebar/index.rhtml
  l.store "Choose a theme", "選擇一個主題"
  l.store "Drag and drop to change the sidebar items displayed on this blog.  To remove items from the sidebar just click remove  Changes are saved immediately, but not activated until you click the 'Publish' button", "在這個部落格顯示拖曳改變的sidebar選項。從sidebar選項移除會立即存檔，但是不會執行直到你輸入<公開>鍵"
  l.store "Publish changes", "公開變更"
  l.store "Available Items", "可用的項目"
  l.store "Active Sidebar items", "有效的側邊欄項目"

  #admin/textfilters/_form.rhtml
  l.store "Description", "説明"
  l.store "Markup type", "審定類型"
  l.store "Post-processing filters", "篩選上傳處理"
  l.store "Parameters", "參數"

  #admin/textfilters/_macros.rhtml
  l.store "Show Help", "顯示協助"

  #admin/textfilters/_textfilters.rhtml
  l.store "Markup", "審定"
  l.store "Filters", "篩選器"

  #admin/textfilters/destroy.rhtml
  l.store "Text Filters", "本文篩選器"
  l.store "Are you sure you want to delete this filter", "你確定要刪除此篩選器？"
  l.store "Delete this filter", "刪除此篩選器"

  #admin/textfilters/edit.rhtml
  l.store "Editing textfilter", "修改本文篩選器"

  #admin/textfilters/list.rhtml
  l.store "Create new text filter", "設計新的本文篩選器"
  l.store "Customize Sidebar", "定製側邊欄"
  l.store "Macros", "巨集"

  #admin/textfilters/macro_help.rhtml
  l.store "Macro Filter Help", "巨集篩選器協助"
  l.store "Creating text filter", "建立本文篩選器"

  #admin/textfilters/show.rhtml
  l.store "Text Filter Details", "本文篩選器細節"
  l.store "Edit this filter", "修改此篩選器"
  l.store "See help text for this filter", "查看協助針對此篩選器"

  #admin/themes/index.rhtml
  l.store "Choose a theme", "選擇主題"
  l.store "Activate", "執行中"
  l.store "Active theme", "執行中主題"

  #admin/trackbacks/edit.rhtml
  l.store "Trackbacks for", "作為引用"
  l.store "Editing trackback", "修改引用"

  #admin/trackbacks/new.rhtml
  l.store "Creating trackback", "設計引用中"
  l.store "Edit this trackback", "修改此引用"

  #admin/users/_form.rhtml
  l.store "Jabber", "Jabber"
  l.store "Password Confirmation", "密碼確認"
  l.store "Send notification messages via email", "經由email發出通知訊息"
  l.store "Send notification messages when new articles are posted", "新的文章貼上時發出通知訊息"
  l.store "Send notification messages when comments are posted", "新的評錀貼上時發出通知訊息"

  #admin/user/_user.rhtml
  l.store "Number of Articles", "文章編號"
  l.store "Number of Comments", "評論編號"
  l.store "Notified", "通知"
  l.store "via email", "經由email"

  #admin/user/destroy.rhtml
  l.store "Show this user", "顯示使用者"
  l.store "Really delete user", "確定刪除使用者"

  #admin/user/edit.rhtml
  l.store "Edit User", "修改使用者"
  l.store "Editing User", "修改使用者中中"
  l.store "New User", "新的使用者"
  l.store "Add new user", "新增使用者"

  #admin/user/new.rhtml
  l.store "Creating user", "設定使用者"

  #admin/user/show.rhtml
  l.store "User's articles", "使用者文章"
  l.store "Notify via email", "經由email通知"
  l.store "Notify on new articles", "新文章通知"
  l.store "Notify on new comments", "新評論通知"

  #articles/_comment.rhtml
  l.store "said", "發言"
  l.store "This comment has been flagged for moderator approval.  It won't appear on this blog until the author approves it", "這篇評論被標示為版主所允許的。他不會在部落格顯示直到版主承認他。"

  #articles/_comment_box.rhtml
  l.store "Your name", "你的名稱"
  l.store "Your blog", "你的部落格"
  l.store "Your email", "你的email"
  l.store "Your message", "你的訊息"
  l.store "Comment Markup Help", "評論顯示協助"
  l.store "Preview comment", "預覽評論"

  #articles/_trackback.rhtml
  l.store "From", "From"

  #articles/archives.rhtml
  l.store "No articles found", "沒有找到任何文章"

  #articles/comment_preview.rhtml
  l.store "is about to say", "這是關於~~"

  #articles/groupings.rhtml
  l.store "There are", "有"

  #articles/index.rhtml
  l.store "Read more", "閱讀更多"
  l.store "Older posts", "從前貼上的"

  #articles/read.rhtml
  l.store "Leave a response", "離開一個回應"
  l.store "Use the following link to trackback from your own site", "從你所屬的網點用隨後的連結去引用"
  l.store "RSS feed for this post", "為本篇提供RSS"
  l.store "trackback uri", "引用URL"
  l.store "Comments are disabled", "評論停用"

  l.store "Pictures from", "圖像顯示從~"

  #vendor/plugins/aimpresence_sidebar/aimpresence_sidebar.rb
  l.store "AIM Presence", "AIM存在"

  #vendor/plugins/aimpresence_sidebar/views/content.rb
  l.store "AIM Status", "AIM身分"

  #vendor/plugins/xml_sidebar/xml_sidebar.rb
  l.store "XML Syndication", "XML簡易整合"

  #vendor/plugins/xml_sidebar/xml_sidebar.rb
  l.store "Syndicate", "整合發表"

  #vendor/plugins/archives_sidebar/views/content.rb
  l.store "Archives", "歸檔"

  #vendor/plugins/tags_sidebar/views/content.rb
  l.store "Tags", "標示標籤"

  #app/helpers/admin/base_helper.rb
  l.store "Back to overview", "回到概覽"
  l.store "log out", "登出"

  #app/controller/admin/cache_controller.rb
  l.store "Cache was cleared", "cache已清除"
  l.store "HTML was cleared", "HTML已清除"

  #app/controller/admin/categories_controller.rb
  l.store "Category was successfully created.", "分類已成功設定"
  l.store "Category could not be created.", "分類不能被設定"
  l.store "Category was successfully updated.", "分類已成功更新"

  #app/models/article.rb
  l.store "New post", "新的上傳"
  l.store "A new message was posted to ", "一個新的訊息已被貼上"

  #app/helper/application_helper.rb
  l.store "no ", "no "

  #app/controller/admin/resource_controller.rb
  l.store "File uploaded: ", "檔案上傳: "
  l.store "Unable to upload", "不能被上傳"
  l.store "Metadata was successfully removed.", "Metadata已成功被移除"
  l.store "Metadata was successfully updated.", "Metadata已成功更新"
  l.store "Not all metadata was defined correctly.", "並非所有Metadata已被正確定義"
  l.store "Content Type was successfully updated.", "內容類型已被成功更新"
  l.store "Error occurred while updating Content Type.", "當更新內容類型時發生錯誤"
  l.store "complete", "完成"
end
