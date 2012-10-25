require 'ym_core'
require "omniauth-facebook"
require "omniauth-twitter"
require "ym_oauth/engine"

module YmOauth
end

require "ym_oauth/models/facebook_oauth"
require "ym_oauth/models/twitter_oauth"
require "ym_oauth/controllers/registrations_controller"
