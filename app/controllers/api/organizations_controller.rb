class Api::OrganizationsController < ApplicationController
  def index
    @organizations = Organization.includes(:games, :users).map &inflate
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
      response[:games] = organization.games.collect(&:id)
      response[:users] = organization.users.collect(&:id)
      response
    }
  end
end
