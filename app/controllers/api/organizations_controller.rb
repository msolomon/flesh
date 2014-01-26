class Api::OrganizationsController < ApplicationController
  def index
    @organizations = Organization.includes(:games, :users).map { |organization|
      response = organization.attributes
      response[:games] = organization.games.collect(&:id)
      response[:users] = organization.users.collect(&:id)
      response
    }
    respond_with(@organizations)
  end
end
