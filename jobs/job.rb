require 'logger'

require_relative '../config/boot'
require_relative '../config/email'

class Job
  attr_reader :log

  def initialize
    @log = Logger.new(App.root('log/jobs.log'), 'monthly')
  end
end
