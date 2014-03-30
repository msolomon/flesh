module TagsHelper
  def self.create(tagger_user, human_code, source)

    if !human_code
      return Try.error("Missing human code")
    end

    taggee = Player.where(human_code: human_code.to_param).first

    if !taggee
      return Try.error("Invalid human code")
    end

    if !taggee.game.running?
      return Try.error("Cannot tag in closed games (#{taggee.game.running_error_string})")
    end

    if !taggee.canBeTagged?
      return Try.error("That player cannot be tagged because they are #{taggee.true_status}")
    end

    tagger = Player.where(user: tagger_user, game: taggee.game).first

    if !tagger # tried to tag user in another game
      return Try.error("Invalid human code")
    end

    if !tagger.canTag?
      return Try.error("You cannot tag because you are #{tagger.true_status}")
    end

    return Try.success(Tag.new(tagger: tagger, taggee: taggee, claimed: Time.now, source: source))
  end
end
