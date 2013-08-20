module Overlaps
  module InputParser
    def valid_input?(ranges)
      raise TypeError, "Expecting an Array object, got a #{ranges.class} instead." unless ranges.class == Array #Ensure Overlaps is receiving an Array object.
      classes_in_range = []
      ranges.each do |range|
        raise TypeError, "Expecting an array of Range objects, got array with a #{range.class} object instead." unless range.class == Range #Ensure array contains only Range objects.
        classes_in_range << range.first.class
        raise TypeError, 'All ranges must share the same class-type for start and end points.' if classes_in_range.uniq.size > 1 #Ensure all range start/ends are of the same class.
      end
      true #If we get through each array element, verifying it is both a range and that its start/end points share a class with all the other ranges, return true.
    end
    
    def parse_input(ranges)
      valid_input?(ranges)
    end
  end
end
