module YmOauth::OauthHelper
  
  def facebook_login_link(options={})
    oauth_login_link(:facebook, options)
  end
    
  def twitter_login_link(options={})
    oauth_login_link(:twitter, options)
  end
  
  def oauth_login_link(provider, options={})
    text=""
    options[:class] = "btn oauth-login-link #{provider}-login-link #{options[:class]}".strip
    url_options = options.delete(:url_options) || {}
    if (icon = options.delete(:icon)) != false
      icon = provider.to_s unless icon.is_a?(String)
      text << content_tag(:icon, nil, :class => "icon-#{icon}")
      text << " "
    end
    text << (options.delete(:text) || "Login with #{provider.to_s.humanize}")
    link_to text.html_safe, user_omniauth_authorize_path(provider, url_options), options
  end
  
end