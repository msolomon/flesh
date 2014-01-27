class Api::PlayersController < ApplicationController

  def index
    if !params[:ids] then
      return respond_with({error: 'Player requests must specify player ids'}, status: :bad_request)
    end

    @players = Player.includes(:user).find params[:ids]
    respond_with(@players.map &inflate)
  end

  def show
    @player = Player.includes(:user).find params[:id]
    respond_with(inflate.call @player)
  end

private
  def inflate
    lambda { |player|
      response = player.attributes
      # TODO: attach last_fed and status
      response
    }
  end
end
