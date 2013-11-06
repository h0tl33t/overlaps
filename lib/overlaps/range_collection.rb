module Overlaps
  class RangeCollection

    def initialize(ranges, accessors)
      @ranges = [] #Better place/way to do this?
      determine_range_type(ranges) == Range ? build_traditional(ranges) : validate_accessors(ranges, accessors)
    end

    def list
      @ranges
    end

    def points
      @ranges.map(&:points).flatten.sort_by { |point| point.value}
    end

    private

    def determine_range_type(ranges)
      classes_represented_by_ranges = ranges.map(&:class).uniq!
      classes_represented_by_ranges.size > 1 ? invalid_input(:inconsistent_types) : classes_represented_by_ranges.first
    end

    def build_traditional(ranges)
      ranges.each_with_index { |range, index| store(range.first, range.last, index) }
    end

    def build_pseudo(ranges, start_accessor, end_accessor)
      ranges.each_with_index { |range, index| store(range.send(start_accessor), range.send(end_accessor), range.grab_id(range, index, accessors[:id])) }
    end

    def store(start_point, end_point, id)
      @ranges << PseudoRange.new(start_point, end_point, id)
    end

    def validate_accessors(ranges, accessors)
      verify_presence_of(accessors)
      verify_response_of(ranges, accessors)
      build_pseudo(ranges, accessors[:start], accessors[:end])
    end

    def verify_presence_of(accessors)
      invalid_input(:missing_start_accessor) if accessors[:start].nil?
      invalid_input(:missing_end_accessor) if accessors[:end].nil?
    end

    def verify_response_of(ranges, accessors)
      ranges.each do |range|
        [:start, :end].each { |method| invalid_type("invalid_#{method}_accessor".to_sym) unless range.responds_to?(accessors[method]) }
      end
    end

    def evaluate_id(range, index, id = nil)
      if id && range.responds_to?(id)
        range.send(id)
      elsif range.responds_to?(:id)
        range.send(:id)
      else
        index
      end
    end

    def invalid_input(type)
      case type
      when :inconsistent_types then raise TypeError, 'All range or pseudo-range objects must be of the same class.'
      when :missing_start_accessor then raise MissingParameter, 'Given a non-range object without a start accessor for the start_point value.'
      when :missing_end_accessor   then raise MissingParameter, 'Given a non-range object without an end accessor for the end_point value.'
      when :invalid_start_accessor then raise ArgumentError, 'The provided start point accessor is not a known method for the given non-range objects.'
      when :invalid_start_accessor then raise ArgumentError, 'The provided end point accessor is not a known method for the given non-range objects.'
      else
        raise StandardError
      end
    end
  end
end