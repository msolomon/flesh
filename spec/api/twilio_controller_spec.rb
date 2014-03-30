require 'spec_helper'
require 'nokogiri'

describe Api::TwilioController do

  TWILIO_PATH = "/api/twilio/sms"
  
  UNKNOWN_NUMBER = '+12081111111'

  KNOWN_NUMBER = '+12089912447'

  def parse_twiml(response)
    Nokogiri::XML(response.body).text
  end

  def sms(body,from)
    post(TWILIO_PATH, { 
      :From => from, 
      :Body => body
    })
  end

  def sms_from_known_number(body)
    sms(body, KNOWN_NUMBER)
  end

  def sms_from_unknown_number(body)
    sms(body, UNKNOWN_NUMBER)
  end

  context "registered number" do
    it 'responds with error to unrecognized command' do
      game  = FactoryGirl.create(:game)
      user  = FactoryGirl.create(:user, { 
        email: "z@z.com", 
        screen_name: "zombocom",
        phone:  KNOWN_NUMBER
      })
      sms_from_known_number("how does this work")
      expect(parse_twiml(response)).to eq(subject.template(:unrecognized_command))
    end
  
    it 'can get stats' do
      game = FactoryGirl.create(:game, {
        id: '1',
        registration_start: Time.now()
      })
      player  = FactoryGirl.create(:player, {
        game: game,
      })
      user  = FactoryGirl.create(:user, { 
        email: "z@z.com", 
        screen_name: "zombocom",
        phone:  KNOWN_NUMBER,
        players: [player]
      })
      sms_from_known_number("stats")
      expect(parse_twiml(response)).to eq(subject.template(:stats, StatsHelper.totals(game)))
    end

    it 'can tag' do
      code = "zcode"
      game  = FactoryGirl.create(:game)

      #the taggee is looked up by human code
      taggee = FactoryGirl.create(:player, 
        game: game, 
        human_code: code, 
        user: FactoryGirl.create(:user, { 
          email: 'x@y.z',
          screen_name: "mike",
        })
      )
      #the tagger is looked up by phone number
      tagger = FactoryGirl.create(:player, 
        game: game, 
        user: FactoryGirl.create(:user, { 
          email: 'a@b.c',
          phone:  KNOWN_NUMBER
        })
      )

      #The tag that makes our tagger zombie
      FactoryGirl.create(:tag, {taggee: tagger})

      #zombie tagger tags a human taggee
      sms_from_known_number("tag " + code)
      expected = subject.template(:tag_success, {taggee_screen_name: "mike"})
      expect(parse_twiml(response)).to eq(expected)
    end

    it 'cannot tag if no human code provided' do
      game  = FactoryGirl.create(:game)
      user  = FactoryGirl.create(:user, { 
        email: "z@z.com", 
        screen_name: "zombocom",
        phone:  KNOWN_NUMBER
      })
      sms_from_known_number("tag")
      expect(parse_twiml(response)).to eq("Missing human code")
    end
    
    it 'cannot tag if the human code is invalid' do
      game  = FactoryGirl.create(:game)
      user  = FactoryGirl.create(:user, { 
        email: "z@z.com", 
        screen_name: "zombocom",
        phone:  KNOWN_NUMBER
      })
      sms_from_known_number("tag zzzzz")
      expect(parse_twiml(response)).to eq("Invalid human code")
    end
    
    it 'cannot tag if the human code is invalid' do
      code = "zcode"
      game  = FactoryGirl.create(:game)

      #the taggee is looked up by human code
      taggee = FactoryGirl.create(:player, 
        game: game, 
        human_code: code, 
        user: FactoryGirl.create(:user, { 
          email: 'x@y.z',
          screen_name: "mike",
        })
      )
      #the tagger is looked up by phone number
      tagger = FactoryGirl.create(:player, 
        game: game, 
        user: FactoryGirl.create(:user, { 
          email: 'a@b.c',
          phone:  KNOWN_NUMBER
        })
      )

      #no tag to make our tagger a zombie

      #zombie tagger tags a human taggee
      sms_from_known_number("tag " + code)
      expect(parse_twiml(response)).to eq("You cannot tag because you are human")
    end
  end

  context "unknown number" do
    it 'responds with error to unrecognized command' do
      sms_from_unknown_number("I'm a random creeper")
      expect(parse_twiml(response)).to eq(subject.template(:unrecognized_number))
    end
  
    it 'cant request stats' do
      sms_from_unknown_number("stats")
      expect(parse_twiml(response)).to eq(subject.template(:unrecognized_number))
    end

    it 'cannot tag' do
      sms_from_unknown_number("tag")
      expect(parse_twiml(response)).to eq(subject.template(:unrecognized_number))

      sms_from_unknown_number("tag something")
      expect(parse_twiml(response)).to eq(subject.template(:unrecognized_number))
    end
  end
end
