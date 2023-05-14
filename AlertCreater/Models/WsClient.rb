require 'websocket-client-simple'
require_relative '../Dependencies/WsDependencies.rb'

class WebSocketClient
  include AutoInject['wsClient']
  include AutoInject['logger']
  include AutoInject['alertCreator']

  def start
    currPrice = 0
    currLogger = logger
    currAlertCreator = alertCreator

    wsClient.on :message do |msg|
      priceObj = JSON.parse(msg.data)
      currLogger.log("Current price: #{priceObj[KEYS::PRICE]}")
      if currPrice != priceObj[KEYS::PRICE].to_f
        currPrice = priceObj[KEYS::PRICE].to_f
        currAlertCreator.create(priceObj)
      end
    end

    wsClient.on :open do |e|
      currLogger.log("Connection Opened!")
    end

    wsClient.on :close do |e|
      currLogger.log("Closed connection: #{e}")
      exit 1
    end

    wsClient.on :error do |e|
      currLogger.log("Error: #{e}")
    end

    loop do
      STDIN.gets.strip
    end
  end
end

WebSocketClient.new.start if __FILE__ == $0
