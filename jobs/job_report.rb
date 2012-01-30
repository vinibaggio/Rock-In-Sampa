# encoding: utf-8

class JobReport
  attr_reader :successes, :failures, :skipped

  def initialize
    @successes = []
    @failures = []
    @skipped = []
  end

  def deliver
    message = build_message

    Mail.deliver do
      to App.settings['email_to']
      from 'admin@rockinsampa.com'
      subject 'Relatório Scraping'
      body message
    end
  end

  private

  def build_message
    msg = "Relatório de scraping:\n\n"
    msg << build_successes_message
    msg << "=-" * 20
    msg << "\n\n"
    msg << build_failures_message
    msg << "=-" * 20
    msg << "\n\n"
    msg << build_skipped_message

    msg
  end

  def build_successes_message
    msg = "#{@successes.count} evento(s) importado(s) com sucesso:\n\n"

    @successes.each do |success_event|
      msg << build_event_message(success_event)
      msg << "Aprovar: #{App.settings['url_aprovar']}/#{success_event.approval_hash}\n"
      msg << "Reprovar: #{App.settings['url_reprovar']}/#{success_event.approval_hash}\n"
      msg << "\n\n"
    end

    msg
  end

  def build_skipped_message
    msg = "#{@skipped.count} evento(s) não foi(ram) importado(s):\n\n"

    @skipped.each do |skipped_event|
      msg << build_event_message(skipped_event)
      msg << "\n\n"
    end

    msg
  end

  def build_failures_message
    msg = "#{@failures.count} evento(s) importado(s) falhou(aram):\n\n"

    @failures.each do |failure_event|
      msg << build_event_message(failure_event)
      msg << "Erro: #{failure_event.errors.inspect}"
      msg << "\n\n"
    end

    msg
  end

  def build_event_message(event)
    msg = "Evento: #{event.band.name}\n"
    msg << "Quando: #{event.occurs_at.strftime('%d/%m/%Y, %H:%M')}\n"
    msg << "Preço masc: $#{event.price_masc}, "
    msg << "fem: $#{event.price_fem}\n"
    msg << "Local: #{event.place.name}\n"
    msg << "Detalhes: #{event.description}\n"

    msg
  end
end
