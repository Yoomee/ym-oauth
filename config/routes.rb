Rails.application.routes.draw do
  #match ""
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  
  resources :registrations, :only => [] do
    collection do
      post 'twitter', :as => 'twitter'
    end
  end
  
end
