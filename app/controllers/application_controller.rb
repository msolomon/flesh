class ApplicationController < ActionController::Base
  include ApplicationHelper

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?


  def ids_or_all models
    params[:ids] ? models.find(params[:ids]) : models
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up).concat [:username, :last_name, :phone]
  end

  def access_denied(exception)
    redirect_to admin_organizations_path, alert: exception.message
  end

end
