require 'sidekiq/web'

Spree::Core::Engine.routes.draw do
  mount Sidekiq::Web, at: '/sidekiq' if Rails.env.development?

  namespace :admin do
    resource 'import_promotions', only: [:create, :new]
  end
end
