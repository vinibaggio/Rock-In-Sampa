require 'data_mapper'

DataMapper.setup(:default, {
  :adapter  => 'postgres',
  :host     => 'localhost',
  :username => App.settings['db_user'],
  :password => App.settings['db_pass'],
  :database => App.settings['db_name']
})

Dir[App.root('/models/*.rb')].each do |file|
  require_relative file
end

DataMapper.logger.set_log(STDOUT, :debug)

DataMapper.finalize
