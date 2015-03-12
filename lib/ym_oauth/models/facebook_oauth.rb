module YmOauth::FacebookOauth

  def self.included(base)
    base.devise :omniauthable
    base.validates :facebook_uid, :uniqueness => true, :allow_nil => true
    base.boolean_accessor :just_connected_facebook
    base.extend ClassMethods
  end
  
  module ClassMethods
    
    def find_or_create_by_facebook_oauth(auth, current_user = nil, options = {})
      if current_user
        user = current_user
        if current_user.facebook_uid.present?
          if current_user.facebook_uid != auth.uid          
            raise ConnectedWithDifferentAccountError
          end
        elsif User.exists?(:facebook_uid => auth.uid)
          raise AccountAlreadyUsedError
        else
          set_facebook_uid(user, auth.uid) # connecting user for the first time while logged in
        end
      elsif user = User.find_by_facebook_uid(auth.uid)
        # found user
        return user
      elsif user = User.find_by_email(auth.extra.raw_info.email)
        set_facebook_uid(user, auth.uid) # connecting user for the first time while logged out
      else
        # creating account for first time
        user = User.new(auth.extra.raw_info.to_hash.slice('first_name', 'last_name', 'email').reverse_merge(options))
        user.password = Devise.friendly_token[0,20]
        set_facebook_uid(user, auth.uid)
      end
      user.save
      user
    end
    
    private
    def set_facebook_uid(user, auth_uid)
      user.just_connected_facebook = true
      user.facebook_uid = auth_uid
      user.image_url = "https://graph.facebook.com/#{auth_uid}/picture?type=large" if user.image.nil?
    end
    
  end
  
  def facebook_client
    @facebook_client ||= Mogli::Client.new(facebook_oauth_token)
  end
  
  class ConnectedWithDifferentAccountError < StandardError; end
  class AccountAlreadyUsedError < StandardError; end
  
end