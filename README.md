# Overlaps

The Overlaps module enables a class to either count or find overlaps in an array of:
  1. Range objects
  2. Objects that have start and end point-type attributes that form a valid range.

The start and end points for each range in the array must all be of the same class.

Example Use Case: Finding shared availability between the schedules of multiple people.
* Feed Overlaps' find_overlaps an array of start/end datetime ranges and it will return all the shared time slots with the identifiers of the original availabilities that cover the overlaps.
* You could then look at each of the original availabilities by identifier and figure out who it belongs to.
* Using whatever identifier (name, id, etc) for the original owners, create a new event/time slot and tie it to the owners of the original availabilities used to find the overlap.

## Installation

Add this line to your application's Gemfile:

    gem 'overlaps'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install overlaps

## Usage

Include the Overlaps module in the class you want to manage overlaps in your application (class Klass; include Overlaps; end).  The class now has access to the count_overlaps and find_overlaps methods (from Overlaps::ClassMethods).

Both methods expect an array of Range objects.

    Klass.count_overlaps(array_of_ranges)
    Klass.find_overlaps(array_of_ranges)

You may also feed them an array of objects with a hash containing the start point attribute and end point attribute:

    Klass.count_overlaps(array_of_objects, start_attr: 's', end_attr: :e)
    Klass.find_overlaps(array_of_objects, start_attr: 's', end_attr: :e)

Overlaps::ClassMethods::count_overlaps returns a Fixnum count:

    Klass.count_overlaps(array_of_ranges) => 5
    
Overlaps::ClassMethods::find_overlaps returns an array of Overlap objects, where each overlap captures the following (with example output):

  Method Call (either array of ranges or objects with start/end point attributes)
  
    Klass.find_overlaps(array_of_ranges)
    Klass.find_overlaps(array_of_objects, start_attr: 's', end_attr: :e) #Pass accessor as symbol or string
    
  Start Point Value
  
    overlap.start_point => 1
    
  End Point Value
  
    overlap.end_point => 10
    
  Range
  
    overlap.range => 1..10
    
  Ids Sharing the Overlap
  
    overlap.ids => [1,5,7]
    
Also, you may pass a specific attribute to use as the id.  When an array of Ranges is given, the id is set to the index of range as it appears in the original input array.  When an array of non-Ranges is given, it looks for an :id attribute by default.  If an :id attribute is not found, it falls back to the index of the object as it appears in the original input array.

## Example Use Case
Say we had a list of Zombie objects (zombies, where the Zombie class has included Overlaps) with a :name attribute ('Bob', 'Karen', 'Frank'), :date_of_birth attribute, and :date_turned_zombie attribute that looked something like this:

    zombies => [#<Zombie:0x2c78220 @name="Bob", @date_of_birth=#<Date: 1920-01-21 ((2422345j,0s,0n),+0s,2299161j)>, @date_turned_zombie=#<Date: 1950-06-20 ((2433453j,0s,0n),+0s,2299161j)>>,
    #<Zombie:0x2c70e88 @name="Karen", @date_of_birth=#<Date: 1927-03-10 ((2424950j,0s,0n),+0s,2299161j)>, @date_turned_zombie=#<Date: 1950-07-04 ((2433467j,0s,0n),+0s,2299161j)>>,
    #<Zombie:0x2c69a60 @name="Frank", @date_of_birth=#<Date: 1938-10-15 ((2429187j,0s,0n),+0s,2299161j)>, @date_turned_zombie=#<Date: 1950-11-27 ((2433613j,0s,0n),+0s,2299161j)>>]

 If we wanted to find the overlap periods where each of them were alive and not yet a zombie, we could call find_overlaps like so:
 
    Zombie.find_overlaps(zombies, start_attr: :date_of_birth, end_attr: :date_turned_zombie, id_attr: :name)
    => [#<Overlaps::Overlap:0x2f47d10 @start_point=#<Date: 1938-10-15 ((2429187j,0s,0n),+0s,2299161j)>, @end_point=#<Date: 1950-06-20((2433453j,0s,0n),+0s,2299161j)>, @ids=["Bob", "Karen", "Frank"]>,
    #<Overlaps::Overlap:0x2f47ce0 @start_point=#<Date: 1927-03-10 ((2424950j,0s,0n),+0s,2299161j)>, @end_point=#<Date: 1950-06-20 ((2433453j,0s,0n),+0s,2299161j)>, @ids=["Bob", "Karen"]>,
    #<Overlaps::Overlap:0x2f47c68 @start_point=#<Date: 1938-10-15 ((2429187j,0s,0n),+0s,2299161j)>, @end_point=#<Date: 1950-07-04 ((2433467j,0s,0n),+0s,2299161j)>, @ids=["Karen", "Frank"]>]

  If we simply wanted to count the number of overlapping periods, we could call count_overlaps like so:
  
    Klass.count_overlaps(zombies, start_attr: :date_of_birth, end_attr: :date_turned_zombie) => 3

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
