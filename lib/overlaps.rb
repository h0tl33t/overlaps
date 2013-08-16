require_relative 'overlaps/version'
require_relative 'overlaps/input_parser'
#require 'overlaps/point'
require_relative 'overlaps/start_point'
require_relative 'overlaps/end_point'
require_relative 'overlaps/overlap'

module Overlaps
  extend Overlaps::InputParser
end