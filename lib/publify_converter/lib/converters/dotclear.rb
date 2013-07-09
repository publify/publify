require 'converters/dotclear/post'
require 'converters/dotclear/comment'
require 'converters/dotclear/category'
require 'converters/dotclear/user'

class DotclearConverter < BaseConverter
  def self.convert(options = {})
    converter = new(options)
    converter.import_users do |dc_user|
      ::User.new \
        :email => dc_user.user_email || "#{dc_user.user_id}@notfound.com",
        :login => dc_user.user_id,
        :password => new_user_password,
        :password_confirmation => new_user_password
    end

    converter.import_articles do |dc_article|
      unless dc_article.post_content.blank? && dc_article.post_chapo.blank? || dc_article.post_titre.blank?
        user = dc_article.user_id.nil? ? nil : converter.users[Dotclear::User.find(dc_article.user_id.to_i).user_id]

        body = !dc_article.post_chapo.blank? ?
          dc_article.post_chapo + '<br /> ' + dc_article.post_content :
          dc_article.post_content


        a = ::Article.new \
          :title        => CGI::unescapeHTML(dc_article.post_titre),
          :body         => body,
          :created_at   => dc_article.post_creadt,
          :published_at => dc_article.post_creadt,
          :updated_at   => dc_article.post_upddt,
          :author       => user
        [a, converter.find_or_create_categories(dc_article)]
      end
    end

    converter.import_comments do |dc_comment|
      ::Comment.new \
        :body         => dc_comment.comment_content,
        :created_at   => dc_comment.comment_dt,
        :updated_at   => dc_comment.comment_upddt,
        :published_at => dc_comment.comment_dt,
        :author       => dc_comment.comment_auteur,
        :url          => dc_comment.comment_site,
        :email        => dc_comment.comment_email,
        :ip           => dc_comment.comment_ip
    end
  end

  def old_articles
    if @options.has_key?(:categories)
      @old_article ||= Dotclear::Post.find(:all,
                                           :include => :categorie,
                                           :conditions => ["post_pub = 1 AND cat_libelle IN (?)", @options[:categories]])
    else
      @old_article ||= Dotclear::Post.find_all_by_post_pub true
    end
    @old_article
  end

  def old_users
    @old_users ||= Dotclear::User.find(:all).index_by &:user_id
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
    dc_comment.comment_auteur = author
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
    create_categories(cat.cat_libelle) if categories[cat.cat_libelle].nil?
    categories[cat.cat_libelle]
  end
end
