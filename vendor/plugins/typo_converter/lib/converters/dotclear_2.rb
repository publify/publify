require 'converters/dotclear_2/post'
require 'converters/dotclear_2/comment'
require 'converters/dotclear_2/category'
require 'converters/dotclear_2/user'
require 'converters/dotclear_2/tag'

class Dotclear2Converter < BaseConverter
  def self.convert(options = {})
    converter = new(options)

    unless (options[:prefix].nil?)
      Dotclear2::Post.prefix = options[:prefix]
      Dotclear2::Comment.prefix = options[:prefix]
      Dotclear2::User.prefix = options[:prefix]
      Dotclear2::Tag.prefix = options[:prefix]
      Dotclear2::Category.prefix = options[:prefix]
    end

    converter.import_users do |dc_user|
      ::User.new \
        :name => dc_user.user_displayname,
        :email => dc_user.user_email || "#{dc_user.user_id}@notfound.com",
        :login => dc_user.user_id,
        :password => new_user_password,
        :password_confirmation => new_user_password
    end

    converter.import_articles do |dc_article|
      unless dc_article.post_content.blank? || dc_article.post_title.blank?
        user = dc_article.user_id.nil? ? nil : converter.users[Dotclear2::User.find(dc_article.user_id.to_i).user_id]

        excerpt, body = !dc_article.post_excerpt.blank? ?
          [dc_article.post_excerpt, dc_article.post_content]:
          [nil, dc_article.post_content]


        a = ::Article.new \
          :title        => CGI::unescapeHTML(dc_article.post_title),
          :body         => body,
          :created_at   => dc_article.post_creadt,
          :published_at => dc_article.post_creadt,
          :updated_at   => dc_article.post_upddt,
          :author       => user,
          :tags         => converter.find_or_create_tags(dc_article.tags)
        [a, converter.find_or_create_categories(dc_article)]
      end
    end

    converter.import_comments do |dc_comment|
      ::Comment.new \
        :body         => dc_comment.comment_content,
        :created_at   => dc_comment.comment_dt,
        :updated_at   => dc_comment.comment_upddt,
        :published_at => dc_comment.comment_dt,
        :author       => dc_comment.comment_author,
        :url          => dc_comment.comment_site,
        :email        => dc_comment.comment_email,
        :ip           => dc_comment.comment_ip
    end
  end

  def old_articles
    if @options.has_key?(:categories)
      @old_article ||= Dotclear2::Post.find(:all,
                                           :include => :categorie,
                                           :conditions => ["post_status = ? AND cat_title IN (?)", true, @options[:categories]])
    else
      @old_article ||= Dotclear2::Post.find_all_by_post_status true
    end
    @old_article
  end

  def old_users
    @old_users ||= Dotclear2::User.find(:all).index_by &:user_id
  end

  def get_login(dc_user)
    dc_user.user_id
  end

  def handle_bad_user_email(dc_user, email)
    dc_user.user_email = email
  end

  def handle_bad_comment_author_email(dc_comment, email)
    dc_comment.comment_email = email
  end

  def handle_bad_comment_author_url(dc_comment, url)
    dc_comment.comment_site = url
  end

  def handle_bad_comment_author(dc_comment, author)
    dc_comment.comment_author = author
  end

  def handle_bad_comment_content(dc_comment, content)
    dc_comment.comment_content = content
  end

  def create_sections(libelle)
    @sections[libelle] = site.sections.create!(:name => libelle, :path => libelle)
    @sections[libelle]
  end

  def find_or_create_categories(dc_article)
    cat = dc_article.categorie
    create_categories(cat.cat_title) if categories[cat.cat_title].nil?
    categories[cat.cat_title]
  end

  # with the tags'libelle in params search or
  # create the Tag objet in Typo
  def find_or_create_tags(dc_tags)
    tags_post = []
    dc_tags.each { |tag|
      create_tag(tag.meta_id) if tags[tag.meta_id].nil?
      tags_post << tags[tag.meta_id]
    }
    tags_post
  end
end
