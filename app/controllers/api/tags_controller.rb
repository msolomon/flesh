class Api::TagsController < Api::ApiController
  before_filter :authenticate_user_from_token!

  def create
    params.require(:tag).permit(:human_code)
    human_code = params[:tag][:human_code]
    try = TagsHelper.create(current_user, human_code)

    if try.error?
      respond_with_error_string(try.error)
    else
      tag = try.success
      if tag.save
        respond_with(:api, tag, status: :created)
      else
        respond_with_error_document(tag)
      end
    end
  end
end
