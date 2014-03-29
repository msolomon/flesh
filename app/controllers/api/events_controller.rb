class Api::EventsController < Api::ApiController

  before_filter :preprocess_params

  DEFAULT_LIMIT = 20
  DEFAULT_OFFSET = 0

  EVENTABLE_MAP = {
    game: Game,
    user: User,
    player: Player,
    organization: Organization
  }

  def events
    respond_with_events(EVENTABLE_MAP[params[:resource]])
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
    params[:resource] = params[:resource].to_sym
  end

end
