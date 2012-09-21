class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    begin
      @user = User.find_or_create_by_facebook_oauth(request.env["omniauth.auth"], current_user)
    rescue YmOauth::Facebook::ConnectedWithDifferentAccountError => e
      flash[:error] = "You have already connected with a different Facebook account"
      redirect_to root_path
    rescue YmOauth::Facebook::AccountAlreadyUsedError => e
      flash[:error] = "Someone else has already connected with this Facebook account"
      redirect_to root_path
    else
      if @user.just_connected_facebook? || @user.last_sign_in_at.nil?
        flash[:notice] = "Successfully connected with your Facebook account."
      end
      sign_in_and_redirect @user, :event => :authentication
    end
  end

  def linkedin
    begin
      @user = User.find_or_create_by_linkedin_oauth(request.env["omniauth.auth"], current_user)
    rescue User::LinkedinAuth::ConnectedWithDifferentAccountError => e
      flash[:error] = "You have already connected with a different LinkedIn account"
      redirect_to root_path
    rescue User::LinkedinAuth::AccountAlreadyUsedError => e
      flash[:error] = "Someone else has already connected with this LinkedIn account"
      redirect_to root_path
    else
      if @user.just_connected_linkedin? || @user.last_sign_in_at.nil?
        flash[:notice] = "Successfully connected with your LinkedIn account."
      end
      sign_in_and_redirect @user, :event => :authentication
    end
  end

  def twitter
    oauth = request.env["omniauth.auth"]
    if @user = current_user
      begin
        @user.connect_to_twitter_auth(oauth)
        @user.save
        flash[:notice] = "Successfully connected with your Twitter account." if @user.just_connected_twitter?
        sign_in_and_redirect @user, :event => :authentication
      rescue User::TwitterAuth::ConnectedWithDifferentAccountError => e
        flash[:error] = "You have already connected with a different Twitter account"
        redirect_to root_path
      rescue User::TwitterAuth::AccountAlreadyUsedError => e
        flash[:error] = "Someone else has already connected with this Twitter account"
        redirect_to root_path
      end
    else
      @user = User.find_or_initialize_by_twitter_oauth(oauth)
      if @user.new_record?
        render :template => "registrations/twitter"
      else
        sign_in_and_redirect @user, :event => :authentication
      end
    end

  end

end
