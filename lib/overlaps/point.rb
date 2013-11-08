module Overlaps
  class Point
    include Comparable

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

    def <=>(other_point)
      value <=> other_point.value
    end
  end
end
