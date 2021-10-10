# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations" }

  # TODO: use only in archive sidebar. See how made other system
  get ":year/:month", to: "articles#index", year: /\d{4}/, month: /\d{1,2}/,
                      as: "articles_by_month", format: false
  get ":year/:month/page/:page", to: "articles#index", year: /\d{4}/, month: /\d{1,2}/,
                                 as: "articles_by_month_page", format: false
  get ":year", to: "articles#index", year: /\d{4}/, as: "articles_by_year", format: false
  get ":year/page/:page", to: "articles#index", year: /\d{4}/,
                          as: "articles_by_year_page", format: false

  get "articles.:format", to: "articles#index", format: /rss|atom/, as: "articles_feed"

  get "sitemap.xml", to: "xml#sitemap", format: "googlesitemap"

  # CommentsController
  resources :comments, only: [:create] do
    collection do
      post :preview
    end
  end

  resources :feedback, only: :index

  # ArticlesController
  get "/live_search/", to: "articles#live_search", as: :live_search_articles, format: false
  get "/search/:q(.:format)/page/:page", to: "articles#search",
                                         as: "search", defaults: { page: 1 }
  get "/search(/:q(.:format))", to: "articles#search"
  get "/search/", to: "articles#search", as: "search_base", format: false
  get "/archives/", to: "articles#archives", format: false
  get "/page/:page", to: "articles#index", page: /\d+/, format: false
  get "/pages/*name", to: "articles#view_page", format: false
  get "previews(/:id)", to: "articles#preview", format: false
  get "previews_pages(/:id)", to: "articles#preview_page", format: false
  get "check_password", to: "articles#check_password", format: false
  get "articles/markup_help/:id", to: "articles#markup_help", format: false
  get "articles/tag", to: "articles#tag", format: false

  # SetupController
  get "/setup", to: "setup#index", format: false
  post "/setup", to: "setup#create", format: false

  # TagsController (imitate inflected_resource)
  resources :tags, only: [:index, :create, :new]
  resources :tags, path: "tag", only: [:show, :edit, :update, :destroy]
  get "/tag/:id/page/:page", to: "tags#show", format: false
  get "/tags/page/:page", to: "tags#index", format: false

  resources :authors, path: "author", only: :show

  # ThemeController
  scope controller: "theme", filename: /.*/ do
    get "stylesheets/theme/:filename", action: "stylesheets", format: false
    get "javascripts/theme/:filename", action: "javascripts", format: false
    get "images/theme/:filename", action: "images", format: false
    get "fonts/theme/:filename", action: "fonts", format: false
  end

  # For the tests
  get "theme/static_view_test", format: false

  # For the statuses
  get "/notes", to: "notes#index", format: false
  get "/notes/page/:page", to: "notes#index", format: false
  get "/note/:permalink", to: "notes#show", format: false

  get "/robots", to: "text#robots", format: "txt"

  # TODO: Remove if possible
  resources :accounts, only: [], format: false do
    collection do
      get "confirm"
    end
  end

  namespace :admin do
    root "dashboard#index", as: "dashboard"

    resources :content, only: [:index, :new, :edit, :create, :update, :destroy],
                        format: false do
      collection do
        get "auto_complete_for_article_keywords"
        post "autosave"
        put "autosave"
      end
    end

    resources :feedback, only: [:index, :edit, :create, :update, :destroy], format: false do
      collection do
        post "bulkops"
      end
      member do
        get "article"
        post "change_state"
      end
    end

    resources :notes, only: [:index, :show, :edit, :create, :update, :destroy],
                      format: false

    resources :pages, only: [:index, :new, :edit, :create, :update, :destroy],
                      format: false

    resources :post_types, only: [:index, :edit, :create, :update, :destroy],
                           format: false

    resources :profiles, only: [:index, :update], format: false

    resources :redirects, only: [:index, :edit, :create, :update, :destroy], format: false

    resources :resources, only: [:index, :destroy], format: false do
      collection do
        post "upload"
      end
    end

    resource :seo, controller: "seo", only: [:show, :update], format: false

    # TODO: This should be a singular resource
    resource :settings, only: [], format: false do
      collection do
        get "index"
        get "display"
        get "feedback"
        get "write"
        post "migrate"
        post "update"
      end
    end

    # TODO: This should have a plural resource name
    resources :sidebar, only: [:index, :update, :destroy] do
      collection do
        put :publish
        post :sortable
      end
    end

    resources :tags, only: [:index, :edit, :create, :update, :destroy], format: false

    resources :themes, only: [:index], format: false do
      collection do
        get "preview"
        get "switchto"
      end
    end

    resources :users, only: [:index, :new, :edit, :create, :update, :destroy], format: false
  end

  root "articles#index"

  get "*from", to: "articles#redirect", format: false
end
