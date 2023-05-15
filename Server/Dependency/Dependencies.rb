require 'dry-container'
require 'dry-auto_inject'
require 'logger'
require_relative '../Model/CustomLogger.rb'
require_relative '../Db/Db.rb'
require_relative '../Config/Utilities.rb'
require_relative '../Config/Environment.rb'

dependencyContainer = Dry::Container.new
dependencyContainer.register('logger', -> {
  logger = CustomLogger.new(isNilOrEmpty(ENV['LOG_OUTPUT']) ? STDOUT : ENV['LOG_OUTPUT'])
  logger.level = Logger::INFO
  logger
})
dependencyContainer.register('userRepo', -> { User })
dependencyContainer.register('alertRepo', -> { Alert })

AutoInject = Dry::AutoInject(dependencyContainer)
