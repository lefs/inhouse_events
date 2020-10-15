Rails.application.routes.draw do
  mount InhouseEvents::Engine, at: "/inhouse_events"

  root to: "home#index"
  get 'ignored_pageview', to: "home#ignored_pageview"
end
