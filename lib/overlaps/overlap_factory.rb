module Overlaps
  class OverlapFactory

    def initialize(points)
      @count = -1
      @points = Array(points)
      @overlaps = []
    end

    def overlaps
      build_overlaps_with_points
      @overlaps
    end

    private

    def build_overlaps_with_points
      @points.each { |point| process(point) }
    end

    def start_points
      @start_points ||= []
    end

    def process(point)
      if point.start?
        store_start_point(point)
      elsif point.end?
        store_end_point(point)
      end
    end

    def store_start_point(point)
      start_points << point
      @count += 1
    end

    def store_end_point(point)
      build_overlap(point)
      close_out_range(point)
      @count -= 1
    end

    def start_ids
      start_points.map(&:id)
    end

    def build_overlap(end_point)
      stack_of_start_points = start_points.dup
      ids = start_ids

      @count.times do
        start_point = stack_of_start_points.pop
        @overlaps << Overlaps::Overlap.new(start_point.value, end_point.value, ids.dup)
        break if start_point.id == end_point.id
        ids.pop
      end
    end

    def close_out_range(end_point)
      start_points.delete_if {|start| start.id == end_point.id}
    end
  end
end