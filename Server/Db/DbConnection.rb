require 'pg'
require "active_record"
require_relative '../Config/Environment.rb'

ActiveRecord::Base.establish_connection(
  adapter: ENV['ADAPTER'],
  host: ENV['HOST'],
  port: ENV['PORT'],
  username: ENV['DB_USERNAME'],
  password: ENV['PASSWORD'],
  database: ENV['DATABASE'],
  ssl_mode: ENV['SSL_MODE']
)
ActiveRecord::Base.pluralize_table_names = false
