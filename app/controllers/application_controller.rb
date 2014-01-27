class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  def ids_or_all models
    params[:ids] ? models.find(params[:ids]) : models
  end
end
