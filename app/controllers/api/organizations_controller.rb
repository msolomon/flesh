class Api::OrganizationsController < ApplicationController
  def index
    @organizations = ids_or_all(Organization.includes :games, :users).map &inflate
    respond_with(@organizations)
  end

  def show
    @organization = inflate.call Organization.includes(:games, :users).find params[:id]
    respond_with(@organization)
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
