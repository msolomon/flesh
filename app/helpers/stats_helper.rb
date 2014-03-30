module StatsHelper
  # The number of humans, zombies, starved in a given game
  def self.totals(game)
    totals = Player.where(game: game)
    .includes(:tagged_tag)
    .inject(Hash.new(0)) { |total, e| 
      total[e.true_status] += 1; total
    }
    [:oz, :humans, :zombies, :starved].each { |status| 
      totals[status] += 0
    }
    totals[:zombie] += totals[:oz]
    totals.delete :oz
    return totals
  end
end
