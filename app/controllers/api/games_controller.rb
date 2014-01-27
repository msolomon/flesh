class Api::GamesController < InheritedResources::Base
  def index
    @games = ids_or_all(Game.includes :players).map &inflate
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
      response[:player_ids] = game.player_ids
      response
    }
  end
end
