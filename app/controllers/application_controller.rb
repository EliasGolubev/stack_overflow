require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery with: :exception

  before_action :configure_permitted_paramters, if: :devise_controller?
  before_action :gon_user, unless: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  check_authorization

  protected

  def configure_permitted_paramters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end

  def gon_user
    gon.user_id = current_user.id if current_user
  end
end
