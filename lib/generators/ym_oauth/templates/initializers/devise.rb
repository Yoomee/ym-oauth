Devise.setup do |config|
  
  if Rails.env.development?
    config.omniauth :facebook, "137557166307145", "4f39d3e37e194f4113f49a68e2f6af91", :scope => "email"
    # config.omniauth :twitter, "NIWYejijuj6icfVsJx92A", "KJxlaKvr6M4qrkdnO6XodQQsmhU24kFrQ3qzxgII"
  else
    # config.omniauth :facebook, "", "", :scope => "email"
    # config.omniauth :twitter, "", ""
  end
  
  # config.omniauth :linkedin, "hia8gc8cujoc", "3Z1rbdunvVUKMEKg", :client_options => {:request_token_path => '/uas/oauth/requestToken?scope=r_emailaddress'}, fields: ['id', 'first-name', 'last-name', 'headline', 'industry', 'picture-url', 'public-profile-url', 'email-address']
  
end