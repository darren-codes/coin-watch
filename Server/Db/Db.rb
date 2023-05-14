require "active_record"
require_relative 'DbConnection.rb'

class User < ActiveRecord::Base
  attribute :id
  attribute :name
  attribute :email
  attribute :password
end

class Alert < ActiveRecord::Base
  attribute :id
  attribute :user_id
  attribute :coin
  attribute :price
  attribute :currency
  attribute :status
end
