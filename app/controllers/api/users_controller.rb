class Api::UsersController < ApplicationController

  respond_to :json

  def index
    respond_with(ids_or_all(User.all))
  end

  def show
    respond_with(User.find params[:id])
  end

  def create
    @user = User.new(params.require(:user).permit(:email, :password, :first_name, :last_name, :phone))

    if @user.save
      respond_with(:api, @user, status: :created)
    else
      render json: {errors: @user.errors, status: 422}
    end

  end

  def update
    @user = User.find(params[:id])

    if @user.update(params[:user].permit(:email, :password, :first_name, :last_name, :phone))
      respond_with(@user)
    else
      render json: {errors: @user.errors, status: 422}
    end
  end

end
