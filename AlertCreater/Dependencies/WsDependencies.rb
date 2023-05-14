require 'dry-container'
require 'dry-auto_inject'
require 'logger'
require 'kafka'
require_relative '../Models/CustomLogger.rb'
require_relative '../Models/AlertCreator.rb'
require_relative '../Config/Utilities.rb'
require_relative '../Config/Environment.rb'

dependencyContainer = Dry::Container.new
dependencyContainer.register('logger', -> {
  logger = CustomLogger.new(isNilOrEmpty(ENV['LOG_OUTPUT']) ? STDOUT : ENV['LOG_OUTPUT'])
  logger.level = Logger::INFO
  logger
})

dependencyContainer.register('wsClient', -> {
  WebSocket::Client::Simple.connect "#{ENV['BASE_URL']}:#{ENV['WS_PORT']}#{ENV['EXTENSION']}"
})

dependencyContainer.register('alertCreator', -> {
  AlertCreator.new
})

AutoInject = Dry::AutoInject(dependencyContainer)
