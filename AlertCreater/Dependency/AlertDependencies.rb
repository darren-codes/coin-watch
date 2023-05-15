require 'dry-container'
require 'dry-auto_inject'
require 'logger'
require 'kafka'
require_relative '../Model/CustomLogger.rb'
require_relative '../Config/Utilities.rb'
require_relative '../Config/Environment.rb'
require_relative '../Db/Db.rb'

dependencyContainer = Dry::Container.new
dependencyContainer.register('logger', -> {
  logger = CustomLogger.new(isNilOrEmpty(ENV['LOG_OUTPUT']) ? STDOUT : ENV['LOG_OUTPUT'])
  logger.level = Logger::INFO
  logger
})
dependencyContainer.register('producer', -> {
  kafka = Kafka.new(["#{ENV['KAFKA_HOST']}:#{ENV['KAFKA_PORT']}"])
  kafka.producer
})
dependencyContainer.register('alertRepo', -> { Alert })


Injector = Dry::AutoInject(dependencyContainer)
