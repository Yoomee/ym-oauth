Rails.application.routes.draw do

  devise_scope :user do
    resources :registrations, :only => [] do
      collection do
        post 'twitter', :as => 'twitter'
      end
    end
  end

end
