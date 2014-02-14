class Api::TagsController < Api::ApiController
  before_filter :authenticate_user_from_token!

  def create

    human_code = params.permit(:human_code)[:human_code]

    if !human_code
      return respond_with_errors "Missing human code"
    end

    taggee = Player.where(human_code: human_code.to_param).first

    if !taggee
      return respond_with_errors "Invalid human code"
    end

    if !taggee.canBeTagged?
      return respond_with_errors "That player cannot be tagged"
    end

    tagger = Player.where(user: current_user, game: taggee.game)

    if !tagger || !tagger.canTag?
      return respond_with_errors "You cannot tag"
    end

    @tag = Tag.new(current_user.id, taggee.id, Time.now)

    if @tag.save
      respond_with(:api, @tag, status: :created)
    else
      render json: {errors: @tag.errors, status: 422}
    end

  end

private
  def respond_with_errors(errors)
      render json: string_to_error_document(errors), status: 422
  end

end
