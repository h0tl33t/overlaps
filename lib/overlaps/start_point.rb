require_relative 'point'

module Overlaps
  class StartPoint < Point
    def start?
      true
    end
  end
end
