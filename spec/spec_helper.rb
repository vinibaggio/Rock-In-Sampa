Bundler.require

require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/mock'
require 'webmock/minitest'
require 'mocha'

ENV['RACK_ENV'] = 'test'

require_relative '../config/boot'
require_relative '../config/email'

require_relative '../scrapers/scraper'
require_relative '../scrapers/morrison/scraper'
require_relative '../scrapers/piupiu/scraper'
require_relative '../scrapers/thewall/scraper'
require_relative '../jobs/job_report'
require_relative '../jobs/update_events_job/event_sync'
require_relative '../app/contact'

def load_fixture(file_name)
  File.read App.root("spec/fixtures/#{file_name}")
end

Mail.defaults do
  delivery_method :test
end
