require "active_record"
require_relative 'DbConnection.rb'

class Alert < ActiveRecord::Base
  attribute :id
  attribute :user_id
  attribute :coin
  attribute :price
  attribute :currency
  attribute :status
end

# puts User.column_names
