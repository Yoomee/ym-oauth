module YmOauth
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include YmCore::Generators::Migration
      include YmCore::Generators::Ability

      source_root File.expand_path("../templates", __FILE__)
      desc "Installs YmOauth."

      def manifest
        copy_file "initializers/devise.rb", "config/initializers/devise.rb"
        copy_file "controllers/registrations_controller.rb", "app/controllers/registrations_controller.rb"
        insert_into_file "app/models/user.rb", "  include YmOauth::FacebookOauth\n", :after => "include YmUsers::User\n"
        insert_into_file "app/models/user.rb", "  include YmOauth::TwitterOauth\n", :after => "include YmOauth::FacebookOauth\n"
        try_migration_template "migrations/add_oauth_fields_to_users.rb", "db/migrate/add_oauth_fields_to_users"
      end

    end
  end
end