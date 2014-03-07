require 'twilio-ruby'

class Api::TwilioController < Api::ApiController
  include Webhookable

  skip_before_filter :authenticate_user_from_token_soft

  after_filter :set_header

  def sms
    response = Twilio::TwiML::Response.new do |r|
      r.Message 'This is a test message'
    end

    render_twiml response
  end

private

  def get_twilio_client
    secrets = Rails.application.secets
    @client = Twilio::REST::Client.new(secrets.twilio_sid, secets.twilio_auth_token)  
  end
end
