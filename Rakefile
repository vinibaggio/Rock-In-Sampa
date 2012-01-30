require 'bundler'
Bundler.require

require_relative 'config/boot'

require 'rake/dsl_definition'
require 'rake/testtask'

task :default => [:test]

desc 'Migrate database schema'
task :migrate do
  DataMapper.auto_migrate!
  puts "Schema migrated."
end

desc 'Update database schema'
task :upgrade do
  DataMapper.auto_upgrade!
  puts "Schema updated."
end

desc 'Run tests.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'spec'
  t.pattern = 'spec/**/*_spec.rb'
  t.verbose = true
end
