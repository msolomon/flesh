class Api::OrganizationsController < ApplicationController
  def index
    respond_with(@organizations = Organization.all)
  end
end
