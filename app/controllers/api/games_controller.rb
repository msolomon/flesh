class Api::GamesController < Api::ApiController

  def index
    respond_with(ids_or_all Game.includes(:players))
  end

  def show
    respond_with(Game.includes(:players).find params[:id])
  end

  def emails
    respond_with(Game.where(id: params[:game_id]).joins(:players).joins(:users).pluck(:email))
  end

end