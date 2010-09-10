class EmailNotifier < ActiveRecord::Observer
  observe Article, Page, Comment

  def after_save(content)
    true
  end
end

class WebNotifier < ActiveRecord::Observer
  observe Article

  def after_save(article)
  end
end

class BaseConverter
  @@new_user_password = 'typomigrator'
  cattr_accessor :new_user_password

  def initialize(options = {})
    @count   = {:users => 0, :articles => 0, :comments => 0, :pages => 0}
    @options = options
  end

  # Converts the source blog to typo.  Should resemble something like this:
  #
  #   converter = new(options)
  #   converter.import_users do |other_user|
  #     # build Typo User object from other user
  #     ::User.new ...
  #   end
  #
  #   convert.import_pages do |other_page|
  #     # build Typo Page object from other page
  #     ::Page.new ...
  #   end
  #
  #   convert.import_articles do |other_article|
  #     # build Typo Article object from other article
  #     ::Article.new ...
  #   end
  #
  #   convert.import_comments do |other_comment|
  #     # build Typo Comment object from other comment
  #     ::Comment.new ...
  #   end
  def self.convert(options = {})
    raise NotImplementedError
  end

  # override this to provide array of all posts to migrate.
  #
  #   @old_articles ||= Article.find(:all)
  def old_articles
    raise NotImplementedError
  end

  # override this to provide array of all pages to migrate.
  #
  #   @old_pages ||= Page.find(:all)
  def old_pages
    [] # don't raise an error; some sources won't have pages
  end

  # override this to find all users from the source database
  # save them to @old_users, indexed by :login
  #
  #   @old_users ||= User.find(:all).index_by(&:login)
  def old_users
    raise NotImplementedError
  end

  # override this to retrieve the login name from the source user model
  def get_login(other_user)
    other_user.login
  end

  # override this to retrieve all comments from the source article model
  def comments_for(other_article)
    other_article.comments
  end

  # Resets an invalid email for a new user
  def handle_bad_user_email(other_user, email)
    other_user.email = email
  end

  # Resets the author email for a bad comment from the source site.
  def handle_bad_comment_author_email(other_comment, email)
    other_comment.author_email = email
  end

  # Resets the author url for a bad comment from the source site.
  def handle_bad_comment_author_url(other_comment, url)
    other_comment.author_url = url
  end

  # Resets the author name for a bad comment from the source site.
  def handle_bad_comment_author(other_comment, author)
    other_comment.author = author
  end

  # Resets the content for a bad comment from the source site.
  def handle_bad_comment_content(other_comment, content)
    other_comment.content = content
  end

  # Returns the destination site for the migrated content.  Uses the :site => 5 option to specify a site by id.
  def blog
    @blog ||= ::Blog.find(@options[:blog] || 1)
  end

  # Return the Typo filter None
  def filter
    @filter ||= ::TextFilter.find 1
  end

  # Returns all the users from the current Typo site, in a hash indexed by login name.
  def users
    @users        = ::User.find(:all)
    @default_user = @users.first
    @users.index_by(&:login)
  end

  # Returns the default user for new articles if one is not set in the source site.
  def default_user
    users if @users.nil?
    @default_user
  end

  # Returns all Category, in a hash indexed by the category name.
  def categories
    @categories ||= ::Category.find(:all).index_by(&:name)
  end

  # Returns all Tag in a hash indexed by the tag name
  def tags
    @tags ||= ::Tag.find(:all).index_by(&:name)
  end

  def import_users(&block)
    puts "start migrating of user..."
    old_users.each do |login, other_user|
      import_user(other_user, &block)
    end
    print "\n"
    puts "migrated #{@count[:users]} user(s)..."
  end

  def import_user(other_user, &block)
    unless other_user && users[get_login(other_user)]
      ActiveRecord::Base.logger.info "Creating new user for #{get_login(other_user)}"
      new_user = block.call(other_user)
      new_user.save!
      print '.'
      @count[:users] += 1
      new_user
    end
  rescue ActiveRecord::RecordInvalid
    if $!.record.errors.on :email
      puts "  Retrying with new email"
      handle_bad_user_email other_user, "#{$!.record.login}@nodomain.com"
      retry
    else
      raise
    end
  end

  def create_article(other_article, &block)
    (article, *categories) = block.call(other_article)
    if article
      tags = Array.new(article.tags)
      article.allow_comments = true
      article.allow_pings    = false
      article.published      = true
      article.user           ||= default_user
      article.text_filter    ||= filter
      article.save!
      print '.'
      categories.each_with_index do |c, i|
        article.categories << c
      end
      tags.each { |tag|
        tag.articles << article
        tag.save!
      }
      @article_index[other_article] = article
      @count[:articles] += 1
    end
  rescue ActiveRecord::RecordInvalid
    puts "Invalid Article: %s " % $!.record.errors.full_messages.join(' ')
    puts $!.record.inspect
    raise
  end

  def create_page(other_page, &block)
    page = block.call(other_page)
    if page
      page.allow_comments = true
      page.allow_pings    = false
      page.published      = true
      page.user           ||= default_user
      page.text_filter    ||= filter
      page.save!
      print '.'
      @count[:pages] += 1
    end
  rescue ActiveRecord::RecordInvalid
    puts "Invalid Page: %s " % $!.record.errors.full_messages.join(' ')
    puts $!.record.inspect
    raise
  end

  def create_comment(article, other_comment, &block)
    ActiveRecord::Base.logger.info "adding comment"
    returning block.call(other_comment) do |comment|
      comment.article  = article
      comment.text_filter ||= filter
      comment.ip ||= '127.0.0.1'
      comment.save!
      print '.'
      @count[:comments] += 1
    end
  rescue ActiveRecord::RecordInvalid
    if $!.record.errors.on :author_email
      puts "  Retrying with new email"
      handle_bad_comment_author_email other_comment, "invalid@nodomain.com"
      retry
    elsif $!.record.errors.on :author_url
      puts "  Retrying with new URL"
      handle_bad_comment_author_url other_comment, "http://nowhere.com/"
      retry
    elsif $!.record.errors.on :author
      puts "  Retrying with new author name"
      handle_bad_comment_author other_comment, "unknown"
      retry
    elsif $!.record.errors.on :body
      puts "  Retrying with blank body"
      handle_bad_comment_content other_comment, "empty"
      retry
    end
    puts "Invalid Comment: %s " % $!.record.errors.full_messages.join(' ')
    puts $!.record.inspect
    raise
  end

  def create_categories(libelle)
    @categories[libelle] = Category.find_or_create_by_name libelle
  end

  # Create a tag with a libelle
  # Add the tag in Hash value in attribute of tags
  def create_tag(libelle)
    @tags[libelle] = Tag.get libelle
  end

  def import_articles(&block)
    puts "started articles migration..."
    @article_index = {}
    old_articles.each do |other_article|
      create_article other_article, &block
    end
    print "\n"
    puts "migrated #{@count[:articles]} article(s)..."
  end

  def import_pages(&block)
    puts "started pages migration..."
    old_pages.each do |other_page|
      create_page other_page, &block
    end
    print "\n"
    puts "migrated #{@count[:pages]} page(s)..."
  end

  def import_comments(&block)
    puts "started comment migration..."
    old_articles.each do |other_article|
      ActiveRecord::Base.logger.info "Creating article comments"
      comments_for(other_article).each do |other_comment|
        create_comment(@article_index[other_article], other_comment, &block)
      end
    end
    print "\n"
    puts "migrated #{@count[:comments]} comment(s)..."
  end
end

