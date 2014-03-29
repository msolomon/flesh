class Api::StatsController < Api::ApiController
  
  def game_timeline
    game = Game.find(params[:game_id])

    human_counts = Hash.new(0)
    zombie_counts = Hash.new(0)
    starved_counts = Hash.new(0)

    count_as_human = lambda { | game_active_time|
      human_counts[game_active_time] += 1
    }

    count_as_tagged_zombie = lambda { |game_active_time, player|
      became_zombie_time = player.tagged_tag.created_at.to_i

      count_as_human game_active_time
      human_counts[became_zombie_time] -= 1
      count_as_zombie became_zombie_time 
    }

    count_as_zombie = lambda { |became_zombie_time|
      zombie_counts[became_zombie_time] += 1
    }

    players = Player.where(game: game).includes(:tagged_tag)

    players.each { |player|
      game_active_time = [player.created_at, game.game_start].max.to_i

      case player.true_status
      when :oz
        count_as_zombie game_active_time
      when :human
        count_as_human game_active_time
      when :zombie
        count_as_tagged_zombie game_active_time, player
      when :starved
        # TODO: account for OZs confirmed after game start instead of assuming all OZs assigned at join/game start
        player.confirmedOZ? ? count_as_zombie(game_active_time) : count_as_tagged_zombie(game_active_time, player)

        starved_at = player.starve_time.to_i
        zombie_counts[starved_at] -= 1
        starved_counts[starved_at] += 1
      end
    }

    render json: {
      humans: human_counts.sort,
      zombies: zombie_counts.sort,
      starved: starved_counts.sort
    }

  end

end
