class Api::GamesController < InheritedResources::Base
  def index
    @games = Game.includes(:players).map &inflate
    respond_with(@games)
  end

  def show
    @game = inflate.call Game.includes(:players).find params[:id]
    respond_with(@game)
  end

private
  def inflate
    lambda { |game|
      response = game.attributes
      response[:player_ids] = game.players.collect(&:id)
      response
    }
  end
end
