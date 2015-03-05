Rails.application.routes.draw do
  # TODO: use only in archive sidebar. See how made other system
  get ':year/:month', to: 'articles#index', year: /\d{4}/, month: /\d{1,2}/, as: 'articles_by_month', format: false
  get ':year/:month/page/:page', to: 'articles#index', year: /\d{4}/, month: /\d{1,2}/, as: 'articles_by_month_page', format: false
  get ':year', to: 'articles#index', year: /\d{4}/, as: 'articles_by_year', format: false
  get ':year/page/:page', to: 'articles#index', year: /\d{4}/, as: 'articles_by_year_page', format: false

  get 'articles.:format', to: 'articles#index', constraints: {format: 'rss'}, as: 'rss'
  get 'articles.:format', to: 'articles#index', constraints: {format: 'atom'}, as: 'atom'

  scope controller: 'xml', path: 'xml' do
    get 'articlerss/:id/feed.xml', action: 'articlerss', format: false
    get 'commentrss/feed.xml', action: 'commentrss', format: false
    get 'trackbackrss/feed.xml', action: 'trackbackrss', format: false
  end

  get 'xml/:format', to: 'xml#feed', type: 'feed', constraints: {format: 'rss'}, as: 'xml'
  get 'sitemap.xml', to: 'xml#feed', format: 'googlesitemap', type: 'sitemap', as: 'sitemap_xml'

  scope controller: 'xml', path: 'xml', as: 'xml' do
    scope action: 'feed' do
      get ':format/feed.xml', type: 'feed'
      get ':format/:type/:id/feed.xml'
      get ':format/:type/feed.xml'
    end
  end

  get 'xml/rsd', to: 'xml#rsd', format: false
  get 'xml/feed', to: 'xml#feed'

  # CommentsController
  resources :comments, as: 'admin_comments' do
    collection do
      match :preview, via: [:get, :post, :put, :delete]
    end
  end

  resources :trackbacks

  # I thinks it's useless. More investigating
  post "trackbacks/:id/:day/:month/:year", to: 'trackbacks#create', format: false

  # ArticlesController
  get '/live_search/', to: 'articles#live_search', as: :live_search_articles, format: false
  get '/search/:q(.:format)/page/:page', to: 'articles#search', as: 'search', defaults: {page: 1}
  get '/search(/:q(.:format))', to: 'articles#search'
  get '/search/', to: 'articles#search', as: 'search_base', format: false
  get '/archives/', to: 'articles#archives', format: false
  get '/page/:page', to: 'articles#index', page: /\d+/, format: false
  get '/pages/*name', to: 'articles#view_page', format: false
  get 'previews(/:id)', to: 'articles#preview', format: false
  get 'previews_pages(/:id)', to: 'articles#preview_page', format: false
  get 'check_password', to: 'articles#check_password', format: false
  get 'articles/markup_help/:id', to: 'articles#markup_help', format: false
  get 'articles/tag', to: 'articles#tag', format: false

  # SetupController
  match '/setup', to: 'setup#index', via: [:get, :post], format: false

  # TagsController (imitate inflected_resource)
  resources :tags, except: [:show, :update, :destroy, :edit]
  resources :tags, path: 'tag', only: [:show, :edit, :update, :destroy]
  get '/tag/:id/page/:page', to: 'tags#show', format: false
  get '/tags/page/:page', to: 'tags#index', format: false

  resources :authors, path: 'author', only: :show

  # ThemeController
  scope controller: 'theme', filename: /.*/ do
    get 'stylesheets/theme/:filename', action: 'stylesheets', format: false
    get 'javascripts/theme/:filename', action: 'javascript', format: false
    get 'images/theme/:filename', action: 'images', format: false
  end

  # For the tests
  get 'theme/static_view_test', format: false

  # For the statuses
  get '/notes', to: 'notes#index', format: false
  get '/notes/page/:page', to: 'notes#index', format: false
  get '/note/:permalink', to: 'notes#show', format: false

  get '/humans', to: 'text#humans', format: 'txt'
  get '/robots', to: 'text#robots', format: 'txt'

  # TODO: Check which of these routes are not needed.
  resources :accounts, only: [:index], format: false do
    collection do
      get 'confirm'
      get 'login'
      post 'login'
      get 'signup'
      post 'signup'
      get 'recover_password'
      post 'recover_password'
      get 'logout'
      post 'logout'
    end
  end

  namespace :admin do
    get '/', to: 'dashboard#index', as: 'dashboard'

    get 'cache', to: 'cache#show'
    delete 'cache', to: 'cache#destroy'

    resources :content, only: [:index, :new, :edit, :create, :update, :destroy], format: false do
      collection do
        get 'auto_complete_for_article_keywords'
        post 'autosave'
      end
    end

    resources :notes, only: [:index, :show, :edit, :create, :update, :destroy], format: false

    resources :pages, only: [:index, :new, :edit, :create, :update, :destroy], format: false

    resources :post_types, only: [:index, :edit, :create, :update, :destroy], format: false

    resources :profiles, only: [:index, :update], format: false

    resources :redirects, only: [:index, :edit, :create, :update, :destroy], format: false

    resources :sidebar, only: [:index, :update, :destroy] do
      collection do
        put :sortable
      end
    end

    resources :tags, only: [:index, :edit, :create, :update, :destroy], format: false

    resources :users, only: [:index, :new, :edit, :create, :update, :destroy], format: false
  end

  # Admin/XController
  %w{feedback resources sidebar textfilters themes settings seo}.each do |i|
    match "/admin/#{i}", controller: "admin/#{i}", action: :index, format: false, via: [:get, :post, :put, :delete] # TODO: convert this magic catchers to resources item to close un-needed HTTP method
    match "/admin/#{i}(/:action(/:id))", controller: "admin/#{i}", action: nil, id: nil, format: false, via: [:get, :post, :put, :delete] # TODO: convert this magic catchers to resources item to close un-needed HTTP method
  end

  root 'articles#index'

  get '*from', to: 'articles#redirect', format: false
end
