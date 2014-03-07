class Api::UsersController < Api::ApiController

  def index
    respond_with(ids_or_all(User.all))
  end

  def show
    respond_with(User.find params[:id])
  end

  def create
    @user = User.new(signup_params)

    if @user.save
      sign_in(:user, @user, store: false)
      respond_with(:api, @user, status: :created)
    else
      respond_with_error_document @user
    end

  end

  def update
    @user = User.find(params[:id])

    if @user.update(params[:user].permit(signup_params))
      respond_with(@user)
    else
      respond_with_error_document @user
    end
  end

  def reset_password
    email = params.require(:user).require(:email)
    user = email && User.where(email: email).first

    if user
      user.send_reset_password_instructions
      render json: {message: "Your password reset information has been emailed to you"}, status: 200
    else
      respond_with_error_string "No user exists with that email"
    end
  end

private
  def signup_params
    user_params = params.require(:user)
    user_params.require(:email)
    user_params.require(:password)
    user_params.require(:first_name)
    user_params.require(:last_name)
    user_params.require(:screen_name)
    user_params.permit(:email, :password, :first_name, :last_name, :screen_name, :phone)
  end

end
