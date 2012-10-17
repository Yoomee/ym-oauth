module YmOauth::RegistrationsController
  
  def twitter
    begin
      if params[:user][:password].present?
        @user = User.find_by_email(params[:user][:email])
        @user.twitter_screen_name ||= params[:user][:twitter_screen_name]
        @user.twitter_uid ||= params[:user][:twitter_uid]
        if @user.valid_password?(params[:user][:password])
          @user.connect_to_twitter_uid(@user.twitter_uid)
          @user.save
          sign_in_and_redirect @user
        else
          @user.errors.add(:password, "is invalid")
          @show_password = true
        end
      else
        @user = User.new(params[:user].merge(:password => Devise.friendly_token[0,20]))
        @user.connect_to_twitter_uid(@user.twitter_uid)
        if @user.save
          sign_in_and_redirect @user, :event => :authentication
        elsif @user.errors.full_messages == ["Email has already been taken"]
          @user.errors.clear
          @show_password = true
        end
      end
    rescue User::TwitterAuth::ConnectedWithDifferentAccountError => e
      flash[:error] = "You have already connected with a different Twitter account"
      redirect_to root_path
    rescue User::TwitterAuth::AccountAlreadyUsedError => e
      flash[:error] = "Someone else has already connected with this Twitter account"
      redirect_to root_path
    end
    
  end
  
end