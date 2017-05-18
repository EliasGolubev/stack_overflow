class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :omniauth_common

  def facebook; end

  def twitter; end

  private

  def omniauth_common
    auth = request.env['omniauth.auth'] || new_auth
    @user = User.find_for_oauth(auth)

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: auth.provider.capitalize) if is_navigational_format?
    elsif auth.provider
      session['provider'] = auth.provider
      session['uid'] = auth.uid
      session['name'] = auth.info.name
      render 'omniauth_callbacks/set_email'
    else
      flash[:notice] = 'Invalid provider'
    end
  end

  def new_auth
    OmniAuth::AuthHash.new(provider: session['provider'], uid: session['uid'], info: { name: session['name'], email: params[:email] })
  end
end
