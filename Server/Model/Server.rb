require 'sinatra'
require 'sinatra/base'
require 'sinatra/namespace'
require_relative '../Dependency/Dependencies.rb'
require_relative '../Config/Constants.rb'

class Server < Sinatra::Base
  register Sinatra::Namespace
  set :bind, '0.0.0.0'
  enable :logging

  include AutoInject['logger']
  include AutoInject['userRepo'] # this is a class and not an instance
  include AutoInject['alertRepo'] # this is a class and not an instance

  get '/' do
    logger.log('Received "/" get request')

    "Looks like the App works, Phew!"
  end

  namespace '/user' do
    before do
      logger.log('Before "/user/*" request')
      payload = request.body.read
      if isNilOrEmpty(payload)
        halt 400, UserMessages::ERROR400 + RequiredParams[request.path_info].join(", ")
      end

      payload = JSON.parse(payload)
      logger.log("Require params: #{RequiredParams[request.path_info].join(", ")} for #{request.path_info}")
      if RequiredParams[request.path_info] - payload.keys != []
        halt 400, UserMessages::ERROR400 + RequiredParams[request.path_info].join(", ")
      end
      request.body.rewind
    end

    post '/create' do
      logger.log('Received "/user/create" post request')
      begin
        object = JSON.parse(request.body.read)
        object["status"] = UserStatus::ACTIVE
        userRepo.create(object)
        UserMessages::CREATED
      rescue Exception => e
        logger.error("Exception occurred: #{e.message} with trace #{e.backtrace.inspect}")
        halt 409, UserMessages::DUPLICATE if e.message.include?(Errors::DUPLICATE)
        halt 500, UserMessages::ERROR500
      end
    end

    get '/token' do
      logger.log('Received "/user/token" get request')
      # TODO: implement jwt token retrieval
      'gets token'
    end

    delete '/delete' do
      logger.log('Received "/user/delete" delete request')
      begin
        object = JSON.parse(request.body.read)
        logger.log("Deleting user id: #{object['id']}")
        userRepo.where(object).delete_all
        alertRepo.where(:user_id => object["id"]).delete_all
        UserMessages::DELETED
      rescue Exception => e
        logger.error("Exception occurred: #{e.message} with trace #{e.backtrace.inspect}")
        halt 500, UserMessages::ERROR500
      end
    end
  end

  namespace '/alert' do
    before do
      logger.log('Before "/alert/*" request')
      payload = request.body.read
      if isNilOrEmpty(payload)
        halt 400, AlertMessages::ERROR400 + RequiredParams[request.path_info].join(", ")
      end

      payload = JSON.parse(payload)
      logger.log("Require params: #{RequiredParams[request.path_info].join(", ")} for #{request.path_info}")
      if RequiredParams[request.path_info] - payload.keys != []
        halt 400, AlertMessages::ERROR400 + RequiredParams[request.path_info].join(", ")
      end

      if !userRepo.exists?(:id => payload['user_id'], :password => payload['password'])
        halt 404, AlertMessages::ID_NOT_FOUND
      end

      request.body.rewind
    end

    post '/create' do
      logger.log('Received "/alert/create" post request')
      begin
        object = JSON.parse(request.body.read)
        object["status"] = AlertStatus::CREATED
        object.keys.each do |key|
          object.delete(key) if !alertRepo.column_names.include?(key)
        end
        puts !alertRepo.exists?(object)
        if !alertRepo.exists?(object)
          alert = alertRepo.create(object)
          AlertMessages::CREATED + "#{alert['id']}"
        else
          halt 409, AlertMessages::DUPLICATE
        end
      rescue Exception => e
        logger.error("Exception occurred: #{e.message} with trace #{e.backtrace.inspect}")
        halt 500, AlertMessages::ERROR500
      end
    end

    delete '/delete' do
      logger.log('Received "/alert/delete" delete request')
      begin
        object = JSON.parse(request.body.read)
        logger.log("Deleting alert id: #{object['id']}")
        alertRepo.where(:id => object['id'], :user_id => object['user_id']).delete_all
        AlertMessages::DELETED
      rescue Exception => e
        logger.error("Exception occurred: #{e.message} with trace #{e.backtrace.inspect}")
        halt 500, UserMessages::ERROR500
      end
    end

    get '/all' do
      logger.log('Received "/alert/all" get request')
      begin
        limit = params[KEYS::LIMIT] || ENV['RECORD_LIMIT']
        offset = params[KEYS::OFFSET] || '0'
        filter = params[KEYS::FILTER] || ''
        logger.log("Addition params limit: #{limit}, offset: #{offset}, filter: #{filter}")
        object = JSON.parse(request.body.read)
        queryBuiler = alertRepo.where(:user_id => object['user_id']).order(:id).limit(limit).offset(offset)
        queryBuiler = queryBuiler.where(:status => filter) if !isNilOrEmpty(filter)
        queryBuiler.to_json
      rescue Exception => e
        logger.error("Exception occurred: #{e.message} with trace #{e.backtrace.inspect}")
        halt 500, UserMessages::ERROR500
      end
    end
  end

  run! if __FILE__ == $0
end
