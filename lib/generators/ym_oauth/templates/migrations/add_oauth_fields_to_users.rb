class AddOauthFieldsToUsers < ActiveRecord::Migration
  
  def change
    add_column :users, :facebook_uid, :string
    add_column :users, :linkedin_uid, :string
    add_column :users, :twitter_uid, :string
    add_column :users, :twitter_screen_name, :string
    
    add_index :users, :facebook_uid
    add_index :users, :linkedin_uid
    add_index :users, :twitter_uid
  end
  
end