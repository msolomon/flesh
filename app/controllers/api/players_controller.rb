class Api::PlayersController < ApplicationController

  respond_to :json

  def index
    if !params[:ids] then
      return respond_with({error: 'Player requests must specify player ids'}, status: :bad_request)
    end

    respond_with(Player.includes(:user).find params[:ids])
  end

  def show
    respond_with(Player.includes(:user).find params[:id])
  end

end
