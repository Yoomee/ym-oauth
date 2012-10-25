require 'twitter'
module YmOauth::TwitterOauth

  def self.included(base)
    base.validate :twitter_uid, :uniqueness => true
    base.extend ClassMethods
  end
  
  module ClassMethods
    
    def find_by_twitter_oauth(auth)
      find_by_twitter_uid(auth.uid)
    end
    
    def find_or_initialize_by_twitter_oauth(auth)
      if user = User.find_by_twitter_uid(auth.uid)
        user.connect_to_twitter_auth(auth)
        user.save
        return user
      else
        user = User.new
        user.connect_to_twitter_auth(auth)
        user.last_name ||= user.first_name
        user
      end
    end
    
  end
  
  def connect_to_twitter_auth(auth)
    self.full_name = auth.extra.raw_info.name if full_name.blank?
    self.twitter_screen_name = auth.extra.raw_info.screen_name
    if respond_to?(:twitter_oauth_token)
      if auth.extra.access_type == "write" || twitter_oauth_token.blank? || twitter_oauth_access_level == "read"
        overwrite_oauth_details = true
      else
        begin
          twitter_client.update("")
        rescue Twitter::Error => error
          overwrite_oauth_details = error.is_a?(Twitter::Error::Unauthorized)
        end
      end
      if overwrite_oauth_details
        self.twitter_oauth_token  = auth.credentials.token 
        self.twitter_oauth_secret = auth.credentials.secret
        self.twitter_oauth_access_level = auth.extra.access_type
      end
    end
    connect_to_twitter_uid(auth.uid)
  end
  
  def connect_to_twitter_uid(uid)
    return false unless uid.present?
    if twitter_uid.present? && twitter_uid != uid
      raise ConnectedWithDifferentAccountError
    elsif User.without(self).exists?(:twitter_uid => uid)
      raise AccountAlreadyUsedError
    else
      self.twitter_uid = uid
      if image.nil?
        self.image_url = "https://api.twitter.com/1/users/profile_image?screen_name=#{twitter_screen_name}&size=original"
      end
    end
  end
  
  def twitter_client
    @twitter_client ||= Twitter::Client.new(
      :consumer_key => Devise.omniauth_configs[:twitter].strategy.consumer_key,
      :consumer_secret => Devise.omniauth_configs[:twitter].strategy.consumer_secret,
      :oauth_token => twitter_oauth_token,
      :oauth_token_secret => twitter_oauth_secret
    )
  end
  
  class ConnectedWithDifferentAccountError < StandardError; end
  class AccountAlreadyUsedError < StandardError; end
  
end