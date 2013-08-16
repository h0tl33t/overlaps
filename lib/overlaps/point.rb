module Overlaps
  class Point
    attr_accessor :value, :id
    
    def initialize(value, id)
      @value = value
      @id = id
    end
    
    def start?
      false
    end
    
    def end?
      false
    end
  end
end
