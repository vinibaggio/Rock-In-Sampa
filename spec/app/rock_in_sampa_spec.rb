# encoding: utf-8
require 'spec_helper'
require 'rack/test'

require 'sinatra/base'
require_relative App.root('/app/rock_in_sampa')

describe RockInSampa do
  include Rack::Test::Methods

  after(:each) do
    Mail::TestMailer.deliveries = []
  end

  def app
    RockInSampa
  end

  describe "POST /contato" do
    describe "with session token and valid attributes" do
      it "allows request and shows success message" do
        post('/contato', {
            "authenticity_token" => "a",
            "contact" => {
              'title' => 'Suggestion',
              'name' => 'Arthur Dent',
              'email' => 'arthur@hitchhiker.com',
              'honey_pot' => 'Hello dear earthling.'
            },
          }, {
          'rack.session' => {:csrf => "a"}
        })

        Mail::TestMailer.deliveries.wont_be_empty
        last_response.must_be :ok?
        last_response.body.must_match(/Obrigado pelo seu contato! Se pertinente, responderemos em alguns dias\./)
      end
    end

    describe "with session token and invalid attributes" do
      it "allows request, but shows error" do
        post('/contato', {
            "authenticity_token" => "a",
            "contact" => {},
          }, {
          'rack.session' => {:csrf => "a"}
        })

        Mail::TestMailer.deliveries.must_be_empty
        last_response.must_be :ok?
        last_response.body.must_match(/Por favor preencha todos os campos adequadamente\./)
      end
    end
  end

  describe "GET /eventos/:id" do
    describe "with non-existing item" do
      it "returns 404" do
        Event.expects(:get).returns(nil)

        get '/eventos/42'

        last_response.must_be :not_found?
        last_response.body.must_match(/Página não encontrada/)
      end
    end

    describe "with existing item" do
      it "returns the page" do
        Event.expects(:get).returns(Event.new(:occurs_at => Date.today, :place => Place.new))

        get '/eventos/42'

        last_response.must_be :ok?
        last_response.body.wont_match(/Página não encontrada/)
      end
    end
  end
end
