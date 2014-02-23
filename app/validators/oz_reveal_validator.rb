class OzRevealValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless record.game_start <= value
      record.errors[attribute] << (options[:message] || "must be after the game begins")
    end
    unless value <= record.game_end
      record.errors[attribute] << (options[:message] || "must be before the game ends")
    end
  end
end
