module Overlaps
  module InputParser
    class MissingParameter < StandardError; end
    
    def valid_input?(objects, start_attr = nil, end_attr = nil)
      raise TypeError, "Expecting an Array object, got a #{objects.class} instead." unless objects.class == Array #Ensure Overlaps is receiving an Array object.
      classes_in_range = []
      objects.each do |object|
        if object.class == Range
          classes_in_range << object.first.class #Add class of start element to classes_in_range tracker
          classes_in_range << object.last.class #Add class of end element to classes_in_range tracker
        elsif object.class.ancestors.include?(ActiveRecord::Base)
          raise MissingParameter unless start_attr && end_attr #The names of the start_attr and end_attr must be passed with an array of ActiveRecord objects
          classes_in_range << object.send(start_attr.to_sym).class #Add class of start element to classes_in_range tracker
          classes_in_range << object.send(end_attr.to_sym).class #Add class of end element to classes_in_range tracker
        else
          #Ensure array contains only Range or ActiveRecord::Base-descendant objects.
          raise TypeError, "Expecting an array of Range or ActiveRecord::Base-descendant objects, got array with a #{object.class} object instead."
        end
        raise TypeError, 'All ranges must share the same class-type for start and end points.' if classes_in_range.uniq.size > 1 #Ensure all range start/ends are of the same class.
      end
      true #If we get through each array element, verifying it is both a range and that its start/end points share a class with all the other ranges, return true.
    end
    
    def parse_input(objects, start_attr = nil, end_attr = nil)
      valid_input?(objects, start_attr, end_attr)
    end
  end
end
