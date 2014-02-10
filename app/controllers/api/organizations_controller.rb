class Api::OrganizationsController < Api::ApiController
  
  def index
    respond_with(ids_or_all(Organization.includes :games, :users))
  end

  def show
    respond_with(Organization.includes(:games, :users).find params[:id])
  end

end
