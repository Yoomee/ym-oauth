module YmOauth
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include YmCore::Generators::Migration
      include YmCore::Generators::Ability

      source_root File.expand_path("../templates", __FILE__)
      desc "Installs YmOauth."

      def manifest
        copy_file "initializers/devise.rb", "config/initializers/devise.rb"
        insert_into_file "app/models/user.rb", "  include YmOauth::Facebook\n", :after => "include YmUsers::User\n"
        try_migration_template "migrations/add_oauth_fields_to_users.rb", "db/migrate/add_oauth_fields_to_users"
      end

    end
  end
end