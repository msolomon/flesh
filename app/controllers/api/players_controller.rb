class Api::PlayersController < Api::ApiController
  before_filter :authenticate_user_from_token!, only: :create

  OZ = "Original Zombie"

  def index
    if !params[:ids] then
      return respond_with_error_string "Player requests must specify player ids"
    end

    respond_with(Player.includes(:user).find params[:ids])
  end

  def show
    if params[:id].to_i == 0
      respond_with(Player.new(id: 0, oz_status: :confirmed, user: User.new(screen_name: OZ, first_name: OZ, last_name: OZ, email: "flesh.io@monumentmail.com")))
    else
      respond_with(Player.includes(:user).find params[:id])
    end
  end

  def create
    player_params = join_params

    game_to_join = Game.find(player_params[:game_id])

    if !game_to_join
      return respond_with_error_string "Game with that ID does not exist"
    end

    if !game_to_join.registration_open?
      return respond_with_error_string game_to_join.registration_open_error_string
    end

    wants_to_be_oz = player_params[:oz_pool]
    oz_status = wants_to_be_oz ? :interested : :uninterested

    @player = Player.create_with(oz_status: oz_status).find_or_create_by(user: current_user, game: game_to_join)

    if @player.save
      respond_with(:api, @player, status: :created)
    else
      respond_with_error_document @player
    end

  end

private
  def join_params
    player_params = params.require(:player)
    player_params.require(:game_id)
    player_params.permit(:oz_pool)
    player_params.permit(:game_id, :oz_pool)
  end

end
