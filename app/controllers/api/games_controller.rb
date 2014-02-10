class Api::GamesController < Api::ApiController
  
  def index
    respond_with(ids_or_all Game.includes(:players))
  end

  def show
    respond_with(Game.includes(:players).find params[:id])
  end

end