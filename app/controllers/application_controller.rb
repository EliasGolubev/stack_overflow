require 'application_responder'

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery with: :exception

  before_action :configure_permitted_paramters, if: :devise_controller?
  before_action :gon_user, unless: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to root_url, alert: exception.message }
      format.json { render json: { error: exception.message.to_s }, status: :forbidden }
      format.js { head :forbidden }
    end
  end

  check_authorization unless: :devise_controller?

  protected

  def configure_permitted_paramters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end

  def gon_user
    gon.user_id = current_user.id if current_user
  end
end
