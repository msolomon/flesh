class Api::GamesController < InheritedResources::Base
  def index
    @games = ids_or_all(Game.includes :players)
    respond_with(@games.map &inflate)
  end

  def show
    @game = Game.includes(:players).find params[:id]
    respond_with(inflate.call @game)
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
