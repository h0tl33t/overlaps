require_relative 'point'

module Overlaps
  class EndPoint < Point
    def end?
      true
    end
  end
end
