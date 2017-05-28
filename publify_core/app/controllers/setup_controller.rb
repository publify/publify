class SetupController < BaseController
  before_action :check_config, only: 'index'
  layout 'accounts'

  def index
    return unless request.post?

    this_blog.blog_name = params[:setting][:blog_name]
    this_blog.base_url = blog_base_url

    @user = User.new(login: 'admin',
                     email: params[:setting][:email],
                     nickname: 'Publify Admin')
    @user.generate_password!
    @user.name = @user.login

    unless this_blog.valid? && @user.valid?
      redirect_to setup_url
      return
    end

    return unless this_blog.save

    session[:tmppass] = @user.password

    return unless @user.save

    sign_in @user

    if User.count == 1
      create_first_post @user
      create_first_page @user
    end

    redirect_to confirm_accounts_url
  end

  private

  def create_first_post(user)
    this_blog.articles.create(title: I18n.t('setup.article.title'),
                              author: user.login,
                              body: I18n.t('setup.article.body'),
                              allow_comments: 1,
                              allow_pings: 1,
                              published: 1,
                              user: user)
  end

  def create_first_page(user)
    this_blog.pages.create(name: 'about',
                           published: true,
                           title: I18n.t('setup.page.about'),
                           user: user,
                           body: I18n.t('setup.page.body'))
  end

  def check_config
    return unless this_blog.configured?
    redirect_to controller: 'articles', action: 'index'
  end
end
