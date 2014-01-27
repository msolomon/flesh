class Api::UsersController < ApplicationController

  def index
    @users = ids_or_all(User)
    respond_with(@users.map &inflate)
  end

  def show
    @user = User.find params[:id]
    respond_with(inflate.call @user)
  end

private
  def inflate
    lambda { |organization|
      response = organization.attributes
      response
    }
  end

end
