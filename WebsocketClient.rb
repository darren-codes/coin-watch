require 'websocket-client-simple'

class WebSocketClient
  def initialize
  end
end

ws = WebSocket::Client::Simple.connect 'wss://stream.binance.com:9443/ws/btcusdt@trade'

ws.on :message do |msg|
  puts msg
end

ws.on :open do |e|
  puts "Connection Opened to #{}"
end

ws.on :close do |e|
  puts e
  exit 1
end

ws.on :error do |e|
  puts e
end

loop do
  STDIN.gets.strip
end