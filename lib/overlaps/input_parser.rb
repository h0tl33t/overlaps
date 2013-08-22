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
        else
          raise MissingParameter unless start_attr && end_attr #The names of the start_attr and end_attr must be passed with an array of ActiveRecord objects
          classes_in_range << object.send(start_attr.to_sym).class #Add class of start element to classes_in_range tracker
          classes_in_range << object.send(end_attr.to_sym).class #Add class of end element to classes_in_range tracker
        end
        raise TypeError, 'All ranges must share the same class-type for start and end points.' if classes_in_range.uniq.size > 1 #Ensure all range start/ends are of the same class.
      end
      true #If we get through each array element, verifying it is both a range and that its start/end points share a class with all the other ranges, return true.
    end
    
    def grab_id(obj, id = nil)
      id ||= :id
      obj.respond_to?(id) ? obj.send(id) : nil
    end
    
    def convert_range_to_points(range, id)
      return StartPoint.new(range.first, id), EndPoint.new(range.last, id)
    end
    
    def parse_input(objects, accessors = {})
      valid_input?(objects, accessors[:start_attr], accessors[:end_attr])
      output = []
      objects.each_with_index do |object, index|
        id = grab_id(object, accessors[:id_attr]) || index
        if object.class == Range
          output << convert_range_to_points(object, id)
        else
          range = object.send(accessors[:start_attr])..object.send(accessors[:end_attr])
          output << convert_range_to_points(range, id)
        end
      end
      output.flatten!.sort_by {|point| point.value}
    end
  end
end
