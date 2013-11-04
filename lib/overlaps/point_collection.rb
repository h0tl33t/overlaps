module Overlaps
  class PointCollection
    include Enumerable

    def initialize(ranges, accessors = {})
      @points = convert_ranges_to_points(ranges, accessors) if valid_input?(ranges, accessors)
    end

    def list
      @points
    end

    def valid_input?(ranges, accessors)
      #How to handle this validation in an OO fashion?
      #1) Given an array of stuff?  Sweet!
      #2) Ranges => We're cool!  Format collection of Range objects.
      #3) Objects => Start and end attributes provided?  ID attribute (or whatever you want to use as ID) provided (optional, but track this)?  Start and end attributes (as provided) the same class?  If so, we're good!
      #4) If not-so-good/cool/sweet on any counts...throw exception back up.
      #5) If we're all good, return true.
    end

    def validate_start_and_end_point_classes(ranges, accessors)
      #Ensure there's only one class represented between all start and end points.
    end

    def covert_ranges_to_points(ranges, accessors)
      #Turn each Range or pseudo-Range object into a StartPoint and EndPoint.
      #Use range.first and range.last for a Range object.
      #Use start_attr and end_attr for psuedo-Range objects.
      #Use index of range as it's found in the ranges array for the id.
      #Use id_attr if provided for psuedo-Range objects.  If not, check if it responds to :id (like an ActiveRecord obj).  If all else fails, use the index.
    end

    delegate :each, to: :@points
  end
end