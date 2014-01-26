class Api::OrganizationsController < ApplicationController
  def index
    @organizations = Organization.includes(:game).map { |organization_model|
      organization = organization_model.attributes
      organization[:games] = organization_model.game.collect(&:id)
      organization
    }
    respond_with(@organizations)
  end
end
