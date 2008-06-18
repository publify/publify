require 'converters/wp25/post'
require 'converters/wp25/comment'
require 'converters/wp25/term'
require 'converters/wp25/term_relationship'
require 'converters/wp25/term_taxonomy'
require 'converters/wp25/user'

class Wp25Converter < BaseConverter
  def self.convert(options = {})
    converter = new(options)
    
    unless (options[:prefix].nil?)
      WP25::Post.prefix = options[:prefix]
      WP25::Comment.prefix = options[:prefix]
      WP25::User.prefix = options[:prefix]
      WP25::Term.prefix = options[:prefix]
      WP25::TermRelationship.prefix = options[:prefix]
      WP25::TermTaxonomy.prefix = options[:prefix]
    end
    converter.import_users do |wp_user|
      ::User.new \
        :name => wp_user.display_name,
        :email => wp_user.user_email || "#{wp_user.user_login}@notfound.com",
        :login => wp_user.user_login,
        :password => new_user_password,
        :password_confirmation => new_user_password
    end

    converter.import_articles do |wp_article|
      unless wp_article.post_content.blank? || wp_article.post_title.blank?
        user = wp_article.post_author.nil? ? nil : converter.users[WP25::User.find(wp_article.post_author.to_i).ID]
        
        excerpt, body = !wp_article.post_excerpt.blank? ?
          [wp_article.post_excerpt, wp_article.post_content] :
          [nil, wp_article.post_content]

        
        a = ::Article.new \
          :title        => CGI::unescapeHTML(wp_article.post_title),
          :body         => body,
          :created_at   => wp_article.post_date,
          :published_at => wp_article.post_date,
          :updated_at   => wp_article.post_modified,
          :author       => user,
          :tags         => converter.find_or_create_tags(wp_article.tags)
        [a, converter.find_or_create_categories(wp_article)]
      end
    end
    
    converter.import_comments do |wp_comment|
      ::Comment.new \
        :body         => wp_comment.comment_content,
        :created_at   => wp_comment.comment_date,
        :updated_at   => wp_comment.comment_date,
        :published_at => wp_comment.comment_date,
        :author       => wp_comment.comment_author,
        :url          => wp_comment.comment_author_url,
        :email        => wp_comment.comment_author_email,
        :ip           => wp_comment.comment_author_IP
    end
  end

  def old_articles
    if @options.has_key?(:categories)
      #TODO: understand the categories configuration
      @old_article ||= WP25::Post.find(:all, 
                                           :include => :categorie, 
                                           :conditions => ["post_pub = ? AND cat_libelle IN (?)", true, @options[:categories]])
    else
      @old_article ||= WP25::Post.find_all_by_post_status 'publish'
    end
    @old_article
  end

  def old_users
    @old_users ||= WP25::User.find(:all).index_by &:ID
  end

  def get_login(wp_user)
    wp_user.user_login
  end

  def handle_bad_user_email(wp_user, email)
    wp_user.user_email = email
  end

  def handle_bad_comment_author_email(wp_comment, email)
    wp_comment.comment_author_email = email
  end
  
  def handle_bad_comment_author_url(wp_comment, url)
    wp_comment.comment_author_url = url
  end
  
  def handle_bad_comment_author(wp_comment, author)
    wp_comment.comment_author = author
  end
  
  def handle_bad_comment_content(wp_comment, content)
    wp_comment.comment_content = content
  end
 
  def create_sections(libelle)
    @sections[libelle] = site.sections.create!(:name => libelle, :path => libelle)
    @sections[libelle]
  end

  def find_or_create_categories(wp_article)
    wp_categories = wp_article.categories
    categories_post = []
    wp_categories.each { |wp_categorie|
      create_categories(wp_categorie) if categories[wp_categorie].nil?
      categories_post << categories[wp_categorie]
    }
    categories_post
  end

  # with the tags'libelle in params search or
  # create the Tag objet in Typo
  def find_or_create_tags(wp_tags)
    tags_post = []
    wp_tags.each { |tag|
      create_tag(tag) if tags[tag].nil?
      tags_post << tags[tag]
    }
    tags_post
  end
end
