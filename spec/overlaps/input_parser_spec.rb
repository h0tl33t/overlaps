require 'spec_helper'

module Overlaps
  describe InputParser do
    subject(:klass) {Class.new {extend InputParser}}
    let(:valid_input) {[(1..10), (1..5), (3..7)]}
    
    context '#valid_input?' do
      context 'raises an error when given' do
      
        it 'a non-array object' do
          expect {klass.valid_input?(Hash.new)}.to raise_error(TypeError)
        end
        
        context 'an array' do
          context 'of ActiveRecord objects' do
            it 'without knowing the attributes for the start and end points'
            it 'where the start and end points do not form a valid range'
          end
            
          it 'that contains anything other than Range or ActiveRecord objects' do
            expect {klass.valid_input?([1,2,3])}.to raise_error(TypeError)
          end
          
          it 'of Range objects where the start/end points of each range are not all the same class' do
            expect {klass.valid_input?([(1..5), ('a'..'b')])}.to raise_error(TypeError)
          end
          
        end
      end
      
      context 'returns true when given' do
        it 'an array of ranges where all start/end points are the same class' do
          klass.valid_input?(valid_input).should be_true
        end
        
        it 'an array of ActiveRecord objects with start/end points that form a valid range'
      end
    end
    
    context '#parse_input' do
      it 'checks validity of input' do
        klass.should_receive( :valid_input? )
        klass.parse_input(valid_input)
      end
      
      context 'when given valid input' do
        context 'containing ActiveRecord objects' do
          it 'grabs an id directly from each'
          it 'creates a StartPoint from the objects start point and id'
          it 'creates an EndPoint from the objects end point and id'
        end
        
        context 'containing Range objects' do
          it 'uses the index of each as an id'
          it 'creates a StartPoint using the Range.first element and id'
          it 'creates an EndPoint using the Range.last element and id'
        end
      end
      
      it 'returns a sorted array of StartPoint and EndPoint objects'
    end
  end
end