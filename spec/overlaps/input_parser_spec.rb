require 'spec_helper'

module Overlaps
  describe InputParser do
    it 'stores input when valid'
    
    context '#valid_input?' do
      context 'raises an error when given' do
        it 'a non-array object'
        context 'an array' do
          it 'that contains anything other than range objects'
          it 'of range objects where the start/end points of each range are not all the same class'
        end
      end
      
      context 'returns true when given' do
        it 'an array of ranges where all start/end points are the same class'
      end
    end
    
    context '#parse_input' do
      it 'takes an array of Range objects'
      context 'iterates through each Range object' do
        it 'and checks for an id-type attribute'
        it 'and uses the index as an id if no id-type attribute is found'
        it 'and calls #transform_range - passing the Range along with the id'
      end
    end
    
    context '#transform_range' do
      it 'takes a Range object along with an id'
      it 'splits a Range into a start and end point'
    end
  end
end