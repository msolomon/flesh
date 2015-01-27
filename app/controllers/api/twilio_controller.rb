require 'twilio-ruby'

class Api::TwilioController < Api::ApiController
  include Webhookable

  skip_before_filter :authenticate_user_from_token_soft

  after_filter :set_header

  COPY = {
      unrecognized_number:       "This number is not in our system. To use SMS commands, vist your profile at flesh.io and add a phone number",
      unrecognized_command:      "Unrecognized command.",
      stats:                     "Humans: %{human} \nZombies: %{zombie} \nStarved: %{starved}",
      tag_success:               "You have fed upon %{taggee_screen_name}!",
      something_went_wrong:      "Something went wrong. \nIf the problem persists, try tagging from the website.",
      not_part_of_game:          "Please join a game at flesh.io before requesting stats!"
  }

  # Handle an sms request from Twilio
  def sms
    if !params[:From]
      # Bogus request, respond with HTTP error not sms error
      respond_with_error_string "SMS requests must contain a From parameter"
    end

    command, argument = params[:Body].downcase.gsub(/[^a-z0-9 ]/, '').split(' ', 2)
    user = User.find_by(phone: params[:From])

    if user.nil?
      response = template(:unrecognized_number)
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
      active_game = user.active_player.game rescue nil
      if active_game.nil?
        template(:not_part_of_game)
      else
        template(:stats, StatsHelper.totals(active_game))
      end
    elsif command == "tag"
      try = TagsHelper.create(user, argument, :sms)
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
