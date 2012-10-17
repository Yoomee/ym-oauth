require 'ym_core'
require "omniauth-facebook"
require "omniauth-twitter"
require "ym_oauth/engine"

module YmOauth
end

require "ym_oauth/models/facebook"
require "ym_oauth/models/twitter"
require "ym_oauth/controllers/registrations_controller"
