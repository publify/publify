Rails.application.routes.draw do

  scope controller: 'styleguide', path: 'styleguide', as: 'styleguide'  do
    get '/', action: 'index'
    get 'show', action: 'show'
    get 'article_page', action: 'article_page'
    get 'home_page', action: 'home_page'
  end

  # TODO: use only in archive sidebar. See how made other system
  get ':year/:month', to: 'articles#index', year: /\d{4}/, month: /\d{1,2}/, as: 'articles_by_month', format: false
  get ':year/:month/page/:page', to: 'articles#index', year: /\d{4}/, month: /\d{1,2}/, as: 'articles_by_month_page', format: false
  get ':year', to: 'articles#index', year: /\d{4}/, as: 'articles_by_year', format: false
  get ':year/page/:page', to: 'articles#index', year: /\d{4}/, as: 'articles_by_year_page', format: false

  get 'articles.:format', to: 'articles#index', constraints: { format: 'rss' }, as: 'rss'
  get 'articles.:format', to: 'articles#index', constraints: { format: 'atom' }, as: 'atom'

  scope controller: 'xml', path: 'xml' do
    get 'articlerss/:id/feed.xml', action: 'articlerss', format: false
    get 'commentrss/feed.xml', action: 'commentrss', format: false
    get 'trackbackrss/feed.xml', action: 'trackbackrss', format: false
  end

  get 'xml/:format', to: 'xml#feed', type: 'feed', constraints: { format: 'rss' }, as: 'xml'
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
  post 'trackbacks/:id/:day/:month/:year', to: 'trackbacks#create', format: false

  controller 'articles', format: false do
    get '/live_search/', action: 'live_search', as: :live_search_articles
    get '/search/:q(.:format)/page/:page', action: 'search', as: 'search', defaults: { page: 1 }
    get '/search(/:q(.:format))', action: 'search'
    get '/search/', action: 'search', as: 'search_base'
    get '/archives/', action: 'archives'
    get '/page/:page', action: 'index', page: /\d+/
    get '/pages/*name', action: 'view_page'
    get 'previews(/:id)', action: 'preview'
    get 'previews_pages(/:id)', action: 'preview_page'
    get 'check_password', action: 'check_password'
    get 'articles/markup_help/:id', action: 'markup_help'
    get 'articles/tag', action: 'tag'
  end

  # SetupController
  match '/setup', to: 'setup#index', via: [:get, :post], format: false

  # TagsController (imitate inflected_resource)
  resources :tags, except: [:show, :update, :destroy, :edit]
  resources :tags, path: 'tag', only: [:show]
  get '/tag/:id/page/:page', to: 'tags#show', format: false
  get '/tags/page/:page', to: 'tags#index', format: false

  resources :author, only: :show

  # For the statuses
  get '/notes', to: 'notes#index', format: false
  get '/notes/page/:page', to: 'notes#index', format: false
  get '/note/:permalink', to: 'notes#show', format: false

  get '/humans', to: 'text#humans', format: 'txt'
  get '/robots', to: 'text#robots', format: 'txt'

  namespace :admin do
    mount Ckeditor::Engine => '/ckeditor', as: 'ckeditor'

    get '/', to: 'dashboard#index', as: 'dashboard'
    resources :sidebar, only: [:index, :update, :destroy] do
      collection do
        put :sortable
      end
    end

    resources :notes, except: [:new]
    resource :cache, controller: 'cache', only: [:show, :destroy]
  end

  # Work around the Bad URI bug
  %w(accounts files sidebar).each do |i|
    get "#{i}", to: "#{i}#index", format: false
    match "#{i}(/:action)", to: i, format: false, via: [:get, :post, :put, :delete] # TODO: convert this magic catchers to resources item to close un-needed HTTP method
    match "#{i}(/:action(/:id))", to: i, id: nil, format: false, via: [:get, :post, :put, :delete] # TODO: convert this magic catchers to resources item to close un-needed HTTP method
  end

  # Admin/XController
  %w(content profiles pages feedback resources sidebar textfilters users settings redirects seo post_types).each do |i|
    match "/admin/#{i}", to: "admin/#{i}#index", format: false, via: [:get, :post, :put, :delete] # TODO: convert this magic catchers to resources item to close un-needed HTTP method
    match "/admin/#{i}(/:action(/:id))", to: "admin/#{i}", action: nil, id: nil, format: false, via: [:get, :post, :put, :delete] # TODO: convert this magic catchers to resources item to close un-needed HTTP method
  end

  root to: 'articles#index', format: false

  get '*from', to: 'articles#redirect', format: false
end
