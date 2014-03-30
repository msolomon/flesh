require 'twilio-ruby'

class Api::TwilioController < Api::ApiController
  include Webhookable

  skip_before_filter :authenticate_user_from_token_soft

  after_filter :set_header

  COPY = { 
      unrecognized_number:       "this number is not in our system. To use sms commands vist your profile and add a phone number",
      unrecognized_command:      "unrecognized command. For a full list of sms commands see bitly",
      stats:                     "humans: %{human_count} \n zombies: %{zombie_count} \n starved: %{starved_count} \n days remaining: %{days_remaining}",
      tag_success:               "%{taggee_screen_name} was successfully tagged",
      something_went_wrong:      "something went wrong : / \n if the problem persist, try tagging from the website"
  }

  # Handle an sms request from Twilio
  def sms    

    if !params[:From]
      # Bogus request, respond with HTTP error not sms error
      respond_with_error_string "sms requests must contain a From parameter"
    end

    command, argument = params[:Body].split(' ', 2)
    
    user = User.where(phone: params[:From])

    if user.empty?
      response = response_for_unknown_number(command)
    else
      response = response_for_known_number(command, argument, user)
    end

    twiml = Twilio::TwiML::Response.new do |r|
      r.Message response
    end

    # Render a response back to Twilio
    # in TwiML format. The TwiML instructs 
    # Twilio to respond back to the user, so
    # we don't have fire off a seperate request
    # to respond
    render_twiml twiml
  end

  # handle all responses for a number that's connected to a user
  def response_for_known_number(command, argument, user)
    if command == "stats"
      template(:stats, stats_data)
    elsif command == "tag"
      try = TagsHelper.create(user, argument)
      if try.error?
        try.error
      else
        tag = try.success
        if tag.save
          template(:tag_success, {taggee_screen_name: tag.taggee.user.screen_name})
        else
          template(:something_went_wrong)
        end
      end
    else 
      template(:unrecognized_command)
    end
  end

  # handle all responses for a number that isn't connected to a user
  def response_for_unknown_number(command)  
    # For now, we only have one game, so texting stats from
    # An unknown number will return the stats, in the future
    # this won't work. You will either have to be a registered
    # number so we can look up your game or text "stats " + game_slug
    if command == "stats"
      template(:stats, stats_data )
    else 
      template(:unrecognized_number)
    end
  end

  def stats_data
    { 
      human_count: 1,
      zombie_count: 1,
      starved_count: 1,
      days_remaining: 1 
    } 
  end

  # cool ruby string substitution trick
  # template = "Price of the %{product} is Rs. %{price}." 
  # template % {product:"apple", price:70.00}
  # > Price of the apple is Rs. 70.0.
  def template(key, data = {})
    COPY[key] % data
  end

  def get_twilio_client
    secrets = Rails.application.secets
    @client = Twilio::REST::Client.new(ENV[‘TWILIO_ACCOUNT_SID’], ENV[‘TWILIO_AUTH_TOKEN’])  
  end
end
