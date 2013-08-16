module Overlaps
  class Overlap
    attr_accessor :start_point, :end_point, :ids
    
    def initialize(start_point, end_point, ids)
      @start_point = start_point
      @end_point = end_point
      @ids = ids
    end
    
    def range
      (start_point..end_point)
    end
  end
end
