require 'active_support/all'

require "my_mongoid/version"
require "my_mongoid/document"
require "my_mongoid/fields"
require "my_mongoid/configuration"

require "moped"
require "bson"


module MyMongoid

  def self.models
    @models ||= []
  end

  def self.register_model(klass)
    models << klass
  end

  def self.configuration
    
     MyMongoid::Configuration.instance
  end

  def self.configure
    yield MyMongoid::Configuration.instance if block_given?
   end

  def self.session
    raise UnconfiguredDatabaseError if (self.configuration.host==nil || self.configuration.database==nil)
    @session ||= create_session
  end

  def self.create_session
    session ||= ::Moped::Session.new([configuration.host])
    session.use configuration.database
    session
  end

  class DuplicateFieldError < StandardError
  
  end

  class UnknownAttributeError < StandardError

  end

  class UnconfiguredDatabaseError < StandardError

  end

  class RecordNotFoundError < StandardError
  end
end
