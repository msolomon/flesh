class Api::GamesController < Api::ApiController

  def index
    respond_with(ids_or_all Game.includes(:players))
  end

  def show
    respond_with(Game.includes(:players).find params[:id])
  end

  def emails
    email_info = Game
      .where(id: params[:game_id])
      .joins(:players)
      .joins(:users)
      .distinct()
      .pluck(:first_name, :last_name, :email)
    respond_with(email_info.map { |u| "#{u[0]} #{u[1]} <#{u[2]}>" })
  end

end
