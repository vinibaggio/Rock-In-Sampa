#encoding: utf-8

require 'spec_helper'

describe Scraper::Piupiu::EventDetailPage do
  describe "#event_detail" do
    before(:each) do
      @event_detail_page = Scraper::Piupiu::EventDetailPage.new(load_fixture('piupiu_detalhe.html'))
    end

    it "retuns details for the event, such as band description and price" do
      event_detail = @event_detail_page.parse

      event_detail[:date].must_equal Date.new(2011, 11, 1)
      event_detail[:price].must_equal 18.00
      event_detail[:time].must_equal '23:30'
      event_detail[:band_description].must_equal "\
Rockstock - Formada por João Kurk (voz, guitarra, violão e gaita), \
Giba San (voz, guitarra e violão), Douglas Coronel (vocais e teclados), \
Rodrigo Grecco (voz e contrabaixo) e Armando Pires (vocais e bateria), \
a banda leva a sério o compromisso com os arranjos originais e a \
alegria do rock and roll."

    end
  end
end
