InhouseEvents::Engine.routes.draw do
  resources :events, only: [:create], constraints: { format: 'json' }
end
