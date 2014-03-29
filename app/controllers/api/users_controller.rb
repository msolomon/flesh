class Api::UsersController < Api::ApiController
  before_filter :authenticate_user_from_token!, only: :update

  def index
    respond_with(ids_or_all(User.all))
  end

  def show
    respond_with(User.find params[:id])
  end

  def create
    @user = User.new(signup_params)

    begin
      @user.save!
    rescue ActiveRecord::RecordInvalid, Exception => e
      @user.errors[:base] << e.message
      return respond_with_error_document @user
    end

    sign_in(:user, @user, store: false)

    UserMailer.welcome_email(@user).deliver

    respond_with(:api, @user, status: :created)

  end

  def update
    if params[:id].to_i != current_user.id
      return render json: string_to_error_document("Unauthorized. User id or authentication_token incorrect"), status: 401
    end

    @user = User.find(params[:id])

    begin
      @user.update! update_params
    rescue ActiveRecord::RecordInvalid, Exception => e
      @user.errors[:base] << e.message
      return respond_with_error_document @user
    end

    render json: @user
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

  def update_params
    user_params = params.require(:user)
    user_params.permit(:email, :password, :first_name, :last_name, :screen_name, :phone)
  end

end
