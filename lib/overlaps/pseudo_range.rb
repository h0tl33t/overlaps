module Overlaps
  class PseudoRange
    attr_accessor :start_point, :end_point, :id

    def initialize(range, accessors = {})
      verify_input(range, accessors)
      ensure_points_are_same_class
      build
    end

    def points
      [@start_point, @end_point]
    end

    def range
      (@start_point.value..@end_point.value)
    end

    def type
      @start_point.class
    end

    private

    def verify_input(range, accessors)
      if range.is_a?(Range)
        @start_point = range.first
        @end_point = range.last
        @id = accessors.fetch(:index) { raise ArgumentError, 'Must provide the :index key/value option when given a Range object.' }
      else
        @start_point = accessors.fetch(:start) { raise ArgumentError, 'Must provide the :start key/value option when given a non-Range object.' }
        @end_point = accessors.fetch(:end) { raise ArgumentError, 'Must provide the :end key/value option when given a non-Range object.' }
        @id = determine_id(range, accessors)
      end
    end

    def determine_id(range, accessors)
      id = accessors.fetch(:id) { range.responds_to?(:id) ? range.id : accessors.fetch(:index) }

      if id && range.responds_to?(id)
        range.send(id)
      else
        id
      end
    end

    def ensure_points_are_same_class
      raise TypeError, 'The start and end points for a PseudoRange must be of the same class.' unless start_point.class == end_point.class
    end

    def build
      @start_point = StartPoint.new(@start_point, @id)
      @end_point = EndPoint.new(@end_point, @id)
    end
  end
end