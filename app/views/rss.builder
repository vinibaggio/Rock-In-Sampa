# encoding: utf-8

xml.instruct! :xml, :version => '1.0', :encoding => 'utf-8'
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Rock in Sampa"
    xml.description "O Rock in Sampa é o jeito mais fácil para descobrir o que está rolando nos bares de Rock mais tradicionais da noite paulistana."
    xml.link "http://www.rockinsampa.com"

    @events.each do |event|
      xml.item do
        xml.title "#{Date.today.strftime("%d/%m")}: #{event.band_name} — #{event.place.name}"
        xml.link "http://www.rockinsampa.com/eventos/#{event.id}"
        xml.description do |b|
          b.strong("Banda:")
          b.text! event.band_name
          b.br

          b.strong("Local:")
          b.a event.place.name, :href => event.place.url
          b.text! " — #{event.place.address}"
          b.br
          b.strong "Google Maps: "
          b.a "http://maps.google.com/maps?q=" + Rack::Utils.escape(event.place.address), :href => "http://maps.google.com/maps?q=" + Rack::Utils.escape(event.place.address)
          b.br

          b.strong("Hora:")
          b.text! event.hour
          b.br

          b.strong("Preço:")
          if event.separate_prices?
            b.text! "$%.0f masculino e $%.0f feminino" % [event.price_masc, event.price_fem]
          elsif event.same_prices?
            b.text! "$%.0f" % event.price_masc
          else
            b.text! "Não especificado, consulte o site da casa"
          end
        end

        xml.pubDate Date.today.to_time.rfc822()
      end
    end
  end
end
