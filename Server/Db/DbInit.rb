require 'active_record'
require_relative 'DbConnection.rb'

unless ActiveRecord::Base.connection.table_exists?('user')
  ActiveRecord::Schema.define do
    create_table :user, { id: false } do |table|
      table.string :id, primary_key: true, null: false
      table.string :name, null: false
      table.string :email, null: false
      table.string :password, null: false
      table.string :status, null: false
      table.timestamps
    end
  end
end

unless ActiveRecord::Base.connection.table_exists?('alert')
  ActiveRecord::Schema.define do
    create_table :alert do |table|
      table.string :user_id, null: false
      table.string :coin, null: false
      table.decimal :price, null: false
      table.string :currency, null: false
      table.string :status, null: false
      table.timestamps
    end
  end
end
