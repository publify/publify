class SetupController < ApplicationController
  before_filter :check_config, :only => 'index'
  layout 'accounts'

  def index
    return if not request.post?

    this_blog.blog_name = params[:setting][:blog_name]
    this_blog.base_url = blog_base_url

    @user = User.new(:login => 'admin', :email => params[:setting][:email], :nickname => "Typo Admin")
    @user.generate_password!
    @user.name = @user.login

    unless this_blog.valid? and @user.valid?
      redirect_to :action => 'index'
      return
    end

    return unless this_blog.save

    session[:tmppass] = @user.password

    return unless @user.save

    self.current_user = @user
    session[:user_id] = @user.id

    # FIXME: Crappy hack : by default, the auto generated post is user_id less and it makes Typo crash
    if User.count == 1
      update_or_create_first_post_with_user @user
      create_first_page @user
    end
    
    redirect_to :action => 'confirm'
  end

  private

  # FIXME: Move to a setup concern that coordinates first blog, user, and post
  def update_or_create_first_post_with_user user
    art = Article.find(:first)
    if art
      art.user = user
      art.save
    else
      Article.create(title: 'Hello World!',
                     author: user.login,
                     body: 'Welcome to Typo. This is your first article. Edit or delete it, then start blogging!',
                     allow_comments: 1,
                     allow_pings: 1,
                     published: 1,
                     permalink: 'hello-world',
                     categories: [Category.find(:first)],
                     user: user)
    end
  end
    
  def create_first_page user
    Page.create(name: "about",
      title: "about",
      user: user,
      body: "This is an example of a Typo page. You can edit this to write information about yourself or your site so readers know who you are. You can create as many pages as this one as you like and manage all of your content inside Typo.")
    
  end

  def check_config
    return unless this_blog.configured?
    redirect_to :controller => 'articles', :action => 'index'
  end
end
