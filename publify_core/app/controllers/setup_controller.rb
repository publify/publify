# frozen_string_literal: true

class SetupController < BaseController
  before_action :check_config
  layout 'accounts'

  def index; end

  def create
    this_blog.blog_name = params[:setting][:blog_name]
    this_blog.base_url = blog_base_url

    @user = User.new(login: 'admin',
                     email: params[:setting][:email],
                     password: params[:setting][:password],
                     nickname: 'Publify Admin')
    @user.name = @user.login

    unless this_blog.save && @user.save
      redirect_to setup_url
      return
    end

    sign_in @user

    if User.count == 1
      create_first_post @user
      create_first_page @user
    end

    EmailNotify.send_user_create_notification(@user)

    redirect_to confirm_accounts_url
  end

  private

  def create_first_post(user)
    this_blog.articles.build(title: I18n.t('setup.article.title'),
                             author: user.login,
                             body: I18n.t('setup.article.body'),
                             allow_comments: 1,
                             allow_pings: 1,
                             user: user).publish!
  end

  def create_first_page(user)
    this_blog.pages.create(name: 'about',
                           state: 'published',
                           title: I18n.t('setup.page.about'),
                           user: user,
                           body: I18n.t('setup.page.body'))
  end

  def check_config
    return unless this_blog.configured?

    redirect_to controller: 'articles', action: 'index'
  end
end
