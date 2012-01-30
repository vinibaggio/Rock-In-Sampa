#encoding: utf-8

require 'spec_helper'

describe JobReport do
  before(:each) do
    @report = JobReport.new
  end

  after(:each) do
    Mail::TestMailer.deliveries = []
  end

  describe "#successes" do
    it "is appendable" do
      object = Object.new

      @report.successes << object

      @report.successes.must_include object
    end
  end

  describe "#skipped" do
    it "is appendable" do
      object = Object.new

      @report.skipped << object

      @report.skipped.must_include object
    end
  end

  describe "#failures" do
    it "is appendable" do
      object = Object.new

      @report.failures << object

      @report.failures.must_include object
    end
  end

  describe "#deliver" do
    before(:each) do
      band_mock = MiniTest::Mock.new
      band_mock.expect(:name, 'Metallica Cover')

      place_mock = MiniTest::Mock.new
      place_mock.expect(:name, 'Morrison Rock Bar')

      event_mock = MiniTest::Mock.new
      event_mock.expect(:price_masc, 20.00)
      event_mock.expect(:price_fem, 15.00)
      event_mock.expect(:occurs_at, Time.local(2011, 10, 15, 23, 0))
      event_mock.expect(:description, '123')
      event_mock.expect(:public, true)
      event_mock.expect(:errors, "Event Error")
      event_mock.expect(:approval_hash, 123456789)
      event_mock.expect(:band, band_mock)
      event_mock.expect(:place, place_mock)

      @report.successes << event_mock
      @report.failures << event_mock
      @report.skipped << event_mock
    end

    it "enqueues a message for delivery" do
      @report.deliver

      Mail::TestMailer.deliveries.length.must_equal 1
    end

    it "builds a message report with successes" do
      @report.deliver

      mail = Mail::TestMailer.deliveries.first
      mail.body.to_s.must_equal <<-MSG
Relatório de scraping:

1 evento(s) importado(s) com sucesso:

Evento: Metallica Cover
Quando: 15/10/2011, 23:00
Preço masc: $20.0, fem: $15.0
Local: Morrison Rock Bar
Detalhes: 123
Aprovar: http://teste.local/aprovar/123456789
Reprovar: http://teste.local/reprovar/123456789


=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

1 evento(s) importado(s) falhou(aram):

Evento: Metallica Cover
Quando: 15/10/2011, 23:00
Preço masc: $20.0, fem: $15.0
Local: Morrison Rock Bar
Detalhes: 123
Erro: "Event Error"

=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

1 evento(s) não foi(ram) importado(s):

Evento: Metallica Cover
Quando: 15/10/2011, 23:00
Preço masc: $20.0, fem: $15.0
Local: Morrison Rock Bar
Detalhes: 123


      MSG
    end
  end
end
