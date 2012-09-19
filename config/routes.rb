Rails.application.routes.draw do
  #match ""
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
end
