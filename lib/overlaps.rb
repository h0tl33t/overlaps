require_relative 'overlaps/version'
require_relative 'overlaps/input_parser'
require_relative 'overlaps/start_point'
require_relative 'overlaps/end_point'
require_relative 'overlaps/overlap'

require 'date'
require 'time'

module Overlaps
  extend Overlaps::InputParser
  
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods
    #include Overlaps::InputParser
    def count_overlaps(input_array)
      points = Overlaps::parse_input(input_array) if Overlaps::valid_input?(input_array) #Validate array of ranges, then parse into a sorted array of StartPoint and EndPoint objects.
      overlap_counter = -1 #Starts at negative 1, knowing that the first start element would start the counter at 0.
      overlap_tally = points.inject(0) do |tally, point|
        if point.class == StartPoint
          overlap_counter += 1 #If we run into a start_point, increment the overlap_counter.
        elsif point.class == EndPoint #If we run into an end point..
          tally += overlap_counter #Add the current overlap_counter number of overlaps to the overall tally, noting the number of overlaps that are shared with the end point encountered.
          overlap_counter -= 1 #Decrement the overlap counter, noting that one of the ranges was closed out.
        end
        tally
      end
    end
    
    def find_overlaps(input_array, accessors = {})
      points = Overlaps::parse_input(input_array, accessors)
      
      overlaps = []
      overlap_counter = -1 #Starts at negative 1, knowing that the first start element would start the counter at 0.

      points.inject([]) do |start_stack, point|
        if point.class == StartPoint
          overlap_counter += 1 #If we run into a start_point, increment the overlap_counter.
          start_stack.push(point)
        elsif point.class == EndPoint
          overlaps_to_make = overlap_counter #If we run into an end_point, capture the current overlap counter pre-decrement so we know how many overlaps to construct.
          overlap_counter -= 1 #If we run into an end_point, decrement the overlap_counter.
          overlaps << build_overlaps(start_stack.dup, point, overlaps_to_make) #Returns array of overlaps (as hashes) in format {overlap: (start..end), indices: [all start indices]}
          start_stack.delete_if {|start_point| start_point.id == point.id} #Delete the start element from the start_stack if it was the starting point for the end_point found.
        end
        start_stack #Pass the current start_stack back into the inject to keep a running list of starts.
      end
      overlaps.flatten! #To end up with a single array of overlap hashes in format {overlap: (start..end), indeces: [all indices of original ranges that cover the given overlap]}
    end
    
    private
      def build_overlaps(start_stack, end_point, overlaps_to_make)
        #Take a stack of start points, an end point, and a number of overlaps to make.
        overlaps = []
        start_ids = start_stack.map {|start_point| start_point.id} #Map ids for all start points in the stack.
        overlaps_to_make.times do #Based on the overlap_counter value, we want to build that many overlaps starting with the closest start point to the given end point.
          #Create overlap with the top of the start stack and given end point, attributing all start ids as sharing the overlap, then pop the start point off of the stack.
          overlaps << Overlaps::Overlap.new(start_stack.pop.value, end_point.value, start_ids.dup)
          start_ids.pop #Remove the id from the discarded start point from the list of start point ids.
        end
        overlaps
      end
  end
end