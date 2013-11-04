module Overlaps
  class OverlapFactory

    def initialize
      @count = -1
      @overlaps = []
    end

    def process(point)
      if point.start?
        store_start_point(point)
      elsif point.end?
        build_overlap(point)
        close_out_range(point)
      end
    end

    def store_start_point(point)
      @start_points << point
      @count += 1
    end

    def start_points
      @start_points.dup
    end

    def start_ids
      @start_points.map(&:id)
    end

    def build_overlap(end_point)
      stack_of_start_points = start_points
      ids = start_ids
      @count.times do
        @overlaps << Overlaps::Overlap.new(stack_of_start_points.pop.value, end_point.value, ids)
        ids.pop
      end
    end

    def close_out_range(end_point)
      @start_points.delete_if {|start| start.id == end_point.id}
      @count -= 1
    end

    def overlaps
      @overlaps
    end
  end
end