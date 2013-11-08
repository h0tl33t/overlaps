# Overlaps

The Overlaps module provides methods to either find or count overlaps in an array of:
  1. Range objects
  2. Range-like objects that have start and end point-type attributes/values that form a valid range.

The main purpose of Overlaps -- given a set of range/range-like objects -- is to find all possible overlaps and have information about which ranges belong to/share in a given overlap.

## Installation

Add this line to your application's Gemfile:

    gem 'overlaps'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install overlaps

## Usage

Require the Overlaps module and call either #find or #count.  You can feed them two main types of input:

Array of Range objects where all range start/end points are of the same class:

    array_of_ranges = [1..100, 25..55, 30..110, 10..27]
    Overlaps.find(array_of_ranges)
    Overlaps.count(array_of_ranges)

Array of Range-like objects where each object is of the same class and the start and end point attribute/accessors are passed as values in an options hash to the :start and :end keys:

    PseudoRange = Struct.new(:start_point, :end_point)

    array_of_objects = [ PseudoRange.new(1,10), PseudoRange.new(1,5), PseudoRange.new(3,6) ]
    Overlaps.find(array_of_objects, start: :start_point, end: :end_point)
    Overlaps.count(array_of_objects, start: :start_point, end: :end_point)

Overlaps.count returns a Fixnum count:

    Overlaps.count(array_of_ranges) => 5

Overlaps.find returns an array of Overlap objects, where each overlap captures the following (with example output):

  Start Point Value

    overlap.start_point => 1

  End Point Value

    overlap.end_point => 5

  Range

    overlap.range => 1..5

  IDs of Each Range that Shares the Overlap

    overlap.ids => [0,1]

Also, you may pass a specific attribute to use as the id (assign the id attr/accessor to the :id key in the options hash).  When an array of Ranges is given, the id is set to the index of range as it appears in the original input array.  When an array of non-Ranges is given, it looks for an :id attribute by default.  If an :id attribute is not found, it falls back to the index of the object as it appears in the original input array.  The following section provides an example of setting the id to a specific object attribute.

## Example Use Case
Say we had a list of Zombie objects with :name, :date_of_birth, and :date_turned_zombie attributes that looked something like this:

    zombies => [#<Zombie:0x2c78220 @name="Bob", @date_of_birth=#<Date: 1920-01-21 ((2422345j,0s,0n),+0s,2299161j)>, @date_turned_zombie=#<Date: 1950-06-20 ((2433453j,0s,0n),+0s,2299161j)>>,
    #<Zombie:0x2c70e88 @name="Karen", @date_of_birth=#<Date: 1927-03-10 ((2424950j,0s,0n),+0s,2299161j)>, @date_turned_zombie=#<Date: 1950-07-04 ((2433467j,0s,0n),+0s,2299161j)>>,
    #<Zombie:0x2c69a60 @name="Frank", @date_of_birth=#<Date: 1938-10-15 ((2429187j,0s,0n),+0s,2299161j)>, @date_turned_zombie=#<Date: 1950-11-27 ((2433613j,0s,0n),+0s,2299161j)>>]

 If we wanted to find the overlapping periods where each of them were alive and not yet a zombie, we could call Overlaps.find like so:

    Overlaps.find(zombies, start: :date_of_birth, end: :date_turned_zombie, id: :name)
    => [#<Overlaps::Overlap:0x2f47d10 @start_point=#<Date: 1938-10-15 ((2429187j,0s,0n),+0s,2299161j)>, @end_point=#<Date: 1950-06-20((2433453j,0s,0n),+0s,2299161j)>, @ids=["Bob", "Karen", "Frank"]>,
    #<Overlaps::Overlap:0x2f47ce0 @start_point=#<Date: 1927-03-10 ((2424950j,0s,0n),+0s,2299161j)>, @end_point=#<Date: 1950-06-20 ((2433453j,0s,0n),+0s,2299161j)>, @ids=["Bob", "Karen"]>,
    #<Overlaps::Overlap:0x2f47c68 @start_point=#<Date: 1938-10-15 ((2429187j,0s,0n),+0s,2299161j)>, @end_point=#<Date: 1950-07-04 ((2433467j,0s,0n),+0s,2299161j)>, @ids=["Karen", "Frank"]>]

  If we simply wanted to count the number of overlapping periods, we could call count_overlaps like so:

    Overlaps.count(zombies, start: :date_of_birth, end: :date_turned_zombie) => 3

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
