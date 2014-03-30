class Api::EventsController < Api::ApiController

  before_filter :preprocess_params

  DEFAULT_LIMIT = 20
  DEFAULT_OFFSET = 0

  def events
    # TODO: write tests for this, I only did quick ad-hoc tests
    case params[:resource]
    when :organization
      respond_with_events Organization.find(params[:id]).events
    when :game
      respond_with_events Game.find(params[:id]).events
    when :user
      secret_events = User.find(params[:id]).players.flat_map {|player| get_secret_events_for_player player}.to_set
      respond_with_events player.events.where.not(secret_events)
    when :player
      secret_events = get_secret_events_for_player(Player.find(params[:id]))
      respond_with_events player.events.where.not(secret_events)
  end
  
private

  def respond_with_events events
    respond_with(events.limit(params[:limit]).offset(params[:offset]))
  end

  def get_secret_events_for_player player
    if player.is_stealthed?
      secret_events = Event.where(event_type: Event.event_types[:tag]).where("data -> 'tag_id' = ANY('{?}')", player.tags.pluck(:id))
    else
      Event.none
    end
  end

  def preprocess_params
    params.permit(:id, :limit, :offset)
    params[:id].to_i
    params[:limit] ||= DEFAULT_LIMIT
    params[:offset] ||= DEFAULT_OFFSET
    params[:resource] = params[:resource].to_sym
  end

end
