require_relative '../Config/Constants.rb'
require_relative '../Dependency/AlertDependencies.rb'

class AlertCreator
  include Injector['logger']
  include Injector['producer']
  include Injector['alertRepo']

  def create(priceObj)
    price = priceObj[KEYS::PRICE].to_f
    logger.log("Beginning to push alerts to queue for price: #{price}")
    alertRepo.where({ :price => price, :status => AlertStatus::CREATED }).find_each do |alert|
      alertString = alert.to_json
      logger.log("Creating alert for #{alertString}")
      producer.produce(alertString, topic: ENV['TOPIC'])
      producer.deliver_messages
      logger.log("Changing status to #{AlertStatus::TRIGGERED}")
      alert.status = AlertStatus::TRIGGERED
      alert.save
    end

    # logger.log("Changing status to #{AlertStatus::TRIGGERED}")
    # recordsUpdated = alertRepo.where({:price => price, :status => AlertStatus::CREATED}).update_all(:status => AlertStatus::TRIGGERED)
    # logger.log("Records updated: #{recordsUpdated}")
  end
end
