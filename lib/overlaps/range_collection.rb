module Overlaps
  class RangeCollection

    def initialize(range_input, accessors)
      build(range_input, accessors)
      ensure_single_class_among_points
    end

    def ranges
      @ranges ||= []
    end

    def points
      ranges.map(&:points).flatten.sort_by { |point| point.value}
    end

    private

    def build(range_input, accessors)
      range_input.each_with_index do |range, index|
        accessors[:index] = index
        ranges << PseudoRange.new(range, accessors)
      end
    end

    def ensure_single_class_among_points
      raise TypeError, 'All ranges must have a single shared class of start/end point.' unless ranges.map(&:type).uniq.size == 1
    end
  end
end