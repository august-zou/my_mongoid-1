require 'active_support/all'

module MyMongoid
  class Field
    attr_accessor :name
    def initialize(name)
      @name = name
  
    end
  
  end
end