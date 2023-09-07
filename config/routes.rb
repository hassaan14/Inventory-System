Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

    authenticated :user do
      root "products#index", as: :authenticated_root
      resources :products do 
        resources :transactions
    end
  end
    root "users#index"
    # root "user/sessions#new"
end
