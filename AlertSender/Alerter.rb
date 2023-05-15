require "kafka"
require_relative 'Environment.rb'

kafka = Kafka.new(["#{ENV['KAFKA_HOST']}:#{ENV['KAFKA_PORT']}"])
begin
  puts "Connecting to #{ENV['KAFKA_HOST']}:#{ENV['KAFKA_PORT']}"
  consumer = kafka.consumer(group_id: ENV['GROUP'])
  consumer.subscribe(ENV['TOPIC'])
  consumer.each_message do |message|
    # TODO: write an emailer here
    puts "#{message.value}"
  end
rescue Exception => e
  puts "Exception occurred: #{e.message} with trace #{e.backtrace.inspect}"
  exit 1
end

