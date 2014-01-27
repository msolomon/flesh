class Api::UsersController < ApplicationController

  respond_to :json

  def index
    respond_with(ids_or_all(User.all))
  end

  def show
    respond_with(User.find params[:id])
  end

  def create
    @user = Create.new(params[:create].permit :email, :first_name, :last_name, :phone)

    if @user.save
      respond_with(@user)
    else
      respond_with({errors: @user.errors})
    end

  end

  def update
    @user = User.find(params[:id])

    if @user.update(params[:user].permit(:email, :first_name, :last_name, :phone))
      respond_with(@user)
    else
      respond_with({errors: @user.errors})
    end
  end

end
