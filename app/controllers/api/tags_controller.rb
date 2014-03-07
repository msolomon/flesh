class Api::TagsController < Api::ApiController
  before_filter :authenticate_user_from_token!

  def create
    params.require(:tag).permit(:human_code)
    human_code = params[:tag][:human_code]

    if !human_code
      return respond_with_error_string "Missing human code"
    end

    taggee = Player.where(human_code: human_code.to_param).first

    if !taggee
      return respond_with_error_string "Invalid human code"
    end

    if !taggee.game.running?
      return respond_with_error_string "Cannot tag in closed games (#{taggee.game.running_error_string})"
    end

    if !taggee.canBeTagged?
      return respond_with_error_string "That player cannot be tagged because they are #{taggee.true_status}"
    end

    tagger = Player.where(user: current_user, game: taggee.game).first

    if !tagger # tried to tag user in another game
      return respond_with_error_string "Invalid human code"
    end

    if !tagger.canTag?
      return respond_with_error_string "You cannot tag because you are #{tagger.true_status}"
    end

    @tag = Tag.new(tagger: tagger, taggee: taggee, claimed: Time.now)

    if @tag.save
      respond_with(:api, @tag, status: :created)
    else
      return respond_with_error_document(@tag)
    end

  end

end
