class Api::OrganizationsController < ApplicationController
  def index
    @organizations = ids_or_all(Organization.includes :games, :users)
    respond_with(@organizations.map &inflate)
  end

  def show
    @organization = Organization.includes(:games, :users).find params[:id]
    respond_with(inflate.call @organization)
  end

private
  def inflate
    lambda { |organization|
      response = organization.attributes
      response[:game_ids] = organization.game_ids
      response[:user_ids] = organization.user_ids
      response
    }
  end
end
