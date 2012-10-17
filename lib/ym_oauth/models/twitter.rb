module YmOauth::Twitter

  def self.included(base)
    base.validate :twitter_uid, :uniqueness => true
    base.boolean_accessor :just_connected_twitter
    base.extend ClassMethods
  end
  
  module ClassMethods
    
    def find_by_twitter_oauth(auth)
      find_by_twitter_uid(auth.uid)
    end
    
    def find_or_initialize_by_twitter_oauth(auth)
      if user = User.find_by_twitter_uid(auth.uid)
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
    if full_name.blank?
      self.full_name = auth.extra.raw_info.name
    end
    self.twitter_screen_name = auth.extra.raw_info.screen_name
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
      self.just_connected_twitter = true
      if image.nil?
        self.image_url = "https://api.twitter.com/1/users/profile_image?screen_name=#{twitter_screen_name}&size=original"
      end
    end
  end
  
  class ConnectedWithDifferentAccountError < StandardError; end
  class AccountAlreadyUsedError < StandardError; end
  
end