# encoding: utf-8

require 'erubis'
require 'sinatra/base'
require 'r18n-core'
require 'builder'

require_relative '../config/boot'
require_relative '../config/email'
require_relative 'contact'

class RockInSampa < Sinatra::Base
  set :run, false
  set :env, App.env.to_sym
  set :default_locale, 'pt-br'
  set :public_folder, App.root('/public')

  enable :logging

  get '/' do
    @today_events = Event.public.today
    @tomorrow_events = Event.public.tomorrow
    erb :index
  end

  get '/rss.xml' do
    content_type 'application/rss+xml'

    @events = Event.public.today
    builder :rss
  end

  get '/feed' do
    redirect 'http://feeds.feedburner.com/RockInSampa', 301
  end

  get '/contato' do
    @contact = Contact.new {}
    erb :contact
  end

  post '/contato' do
    @contact = Contact.new(params[:contact] || {})

    if @contact.deliver
      erb :contact_success
    else
      session[:csrf] = random_string
      erb :contact
    end
  end

  get '/eventos/:id' do
    @event = Event.get(params[:id])
    return 404 if @event.nil?

    @title = "#{@event.band_name} &mdash; #{@event.place.name} &mdash; Rock in Sampa"

    erb :show
  end

  get '/aprovar/:id' do
    Event.approve_with_hash!(params[:id])
    redirect to('/')
  end

  get '/reprovar/:id' do
    Event.reject_with_hash!(params[:id])
    redirect to('/')
  end

  not_found do
    erb :'404'
  end

  error do
    error = env['sinatra.error'].message

    begin
      Mail.deliver do
        to App.settings['email_to']
        from 'admin@rockinsampa.com'
        subject "[Rock in Sampa] Notificação de erro"
        body error
      end
    rescue StandardError => e
    end

    erb :'500'
  end

  before do
    ::R18n.set do
      ::R18n::I18n.new('pt-br', [])
    end
  end

  helpers ::R18n::Helpers

  helpers do
    def prices(price_masc, price_fem)
      if price_masc && price_fem
        "<span id='preco_masc'>$#{"%.0f" % price_masc}</span>" +
          "<span id='preco_fem'>$#{"%.0f" % price_fem}</span>"
      elsif price_masc
        "<span id='preco_ambos'>$#{"%.0f" % price_masc}</span>"
      else
        "<span id='preco_nao_conhecido'>$??</span>"
      end
    end

    def random_string(secure = defined? SecureRandom)
      secure ? SecureRandom.hex(32) : "%032x" % rand(2**128-1)
    end
  end
end
