class Api::PlayersController < Api::ApiController
  before_filter :authenticate_user_from_token!, only: :create

  def index
    if !params[:ids] then
      return respond_with_error_string "Player requests must specify player ids"
    end

    respond_with(Player.includes(:user).find params[:ids])
  end

  def show
    respond_with(Player.includes(:user).find params[:id])
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

    @player = Player.new(user: current_user, game: game_to_join, oz_status: oz_status)

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
