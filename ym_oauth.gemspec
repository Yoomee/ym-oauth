$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "ym_oauth/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "ym_oauth"
  s.version     = YmOauth::VERSION
  s.authors     = ["Matt Atkins", "Edward Andrews", "Ian Mooney"]
  s.email       = ["matt@yoomee.com", "edward@yoomee.com", "ian@yoomee.com"]
  s.homepage    = ""
  s.summary     = "Summary of YmOauth."
  s.description = "Description of YmOauth."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.1.0"

  s.add_development_dependency "sqlite3"
  s.add_dependency 'ym_core', '~> 0.1'
  s.add_dependency 'ym_users'
  s.add_dependency 'omniauth-facebook', '=1.4.0'
  s.add_dependency 'mogli'
  s.add_dependency 'omniauth-twitter'
  s.add_dependency 'twitter'
  s.add_dependency 'multi_json', '> 1.2.0'
  

  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'geminabox'
  s.add_development_dependency 'ym_tools'
end