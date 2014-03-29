class Api::EventsController < Api::ApiController

  before_filter :preprocess_params

  DEFAULT_LIMIT = 20
  DEFAULT_OFFSET = 0

  def events
    respond_with_events({
      game: Game,
      user: User,
      player: Player,
      organization: Organization
    }[params[:resource]])
  end
  
private

  def respond_with_events model
    respond_with(model.find(params[:id]).events.limit(params[:limit]).offset(params[:offset]))
  end

  def preprocess_params
    params.permit(:id, :limit, :offset)
    params[:id].to_i
    params[:limit] ||= DEFAULT_LIMIT
    params[:offset] ||= DEFAULT_OFFSET
  end

end
