require_relative 'overlaps/version'
require_relative 'overlaps/range_collection'
require_relative 'overlaps/overlap_factory'
require_relative 'overlaps/pseudo_range'
require_relative 'overlaps/start_point'
require_relative 'overlaps/end_point'
require_relative 'overlaps/overlap'

require 'date'
require 'time'

module Overlaps

  def self.find(ranges, accessors = {})
    range_collection = Overlaps::RangeCollection.new(ranges, accessors)
    Overlaps::OverlapFactory.new(range_collection.points).overlaps
  end

  def self.count(ranges, accessors = {})
    find(ranges, accessors).size
  end
end