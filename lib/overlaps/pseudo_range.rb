module Overlaps
  class PseudoRange
    attr_accessor :start_point, :end_point

    def initialize(start_point, end_point, id)
      unless start_point.class != end_point.class
        @start_point = StartPoint.new(start_point, id)
        @end_point = EndPoint.new(end_point, id)
      else
        raise TypeError, 'Range start and end points must be of the same class.'
      end
    end

    def points
      [@start_point, @end_point]
    end

    def range
      (@start_point.value..@end_point.value)
    end
  end
end