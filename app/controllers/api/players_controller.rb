class Api::PlayersController < Api::ApiController

  def index
    if !params[:ids] then
      return respond_with(string_to_error_document('Player requests must specify player ids'))
    end

    respond_with(Player.includes(:user).find params[:ids])
  end

  def show
    respond_with(Player.includes(:user).find params[:id])
  end

end
