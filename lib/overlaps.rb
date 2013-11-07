require_relative 'overlaps/version'
require_relative 'overlaps/input_parser'
require_relative 'overlaps/start_point'
require_relative 'overlaps/end_point'
require_relative 'overlaps/overlap'
require_relative 'overlaps/range_collection'
require_relative 'overlaps/pseudo_range'
require_relative 'overlaps/overlap_factory'

require 'date'
require 'time'

module Overlaps
  def self.find(ranges, accessors = {})
    Overlaps::OverlapFactory.build_with(ranges, accessors)
  end

  def self.count(ranges, accessors = {})
    find(ranges, accessors).size
  end
end