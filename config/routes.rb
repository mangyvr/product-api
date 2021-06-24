Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      get 'products/most_viewed' => 'products#most_viewed'
      resources :products, only: [:create, :show, :destroy]
    end
  end

end
