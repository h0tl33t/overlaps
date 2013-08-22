require 'spec_helper'

module Overlaps
  describe InputParser do
    subject(:klass) {Class.new {extend InputParser}}
    let(:valid_range_input) {[(1..10), (1..5), (3..7)]}
    
    let(:valid_obj_input) {[ObjectWithRange.new(1, 10, 1), ObjectWithRange.new(1, 5, 2), ObjectWithRange.new(3, 6, 3)] }
    
    context '#valid_input?' do
      context 'raises an error when given' do
        it 'a non-array object' do
          expect {klass.valid_input?(Hash.new)}.to raise_error(TypeError)
        end
        
        context 'an array' do
          context 'of non-Range objects' do
            it 'without providing the accessor methods for the start and end points' do
              expect {klass.valid_input?(valid_obj_input)}.to raise_error(InputParser::MissingParameter)
            end
            
            it 'where the class of the start and end points of each object are not all the same' do
              invalid_obj_input = valid_obj_input << ObjectWithRange.new(4, 'a', 'z')
              expect {klass.valid_input?(invalid_obj_input, :start_point, :end_point)}.to raise_error(TypeError)
            end
          end
          
          context 'of Range objects' do
            it 'where the start and end points of each range are not all the same class' do
              expect {klass.valid_input?([(1..5), ('a'..'b')])}.to raise_error(TypeError)
            end
          end
        end
      end
      
      context 'returns true when given' do
        it 'an array of ranges where all start/end points are the same class' do
          expect(klass.valid_input?(valid_range_input)).to be_true
        end
        
        it 'an array of objects with start and end points that form a valid range and are all of the same class' do
          expect(klass.valid_input?(valid_obj_input, :start_point, :end_point)).to be_true
        end
      end
    end
    
    context '#grab_id' do
      it 'returns the value of an id attribute if one exists' do
        obj = ObjectWithRange.new(1, 10, 1)
        expect(klass.grab_id(obj)).to eq(1)
      end
      it 'returns nil if no id attribute is found' do
        expect(klass.grab_id(Object.new)).to be_nil
      end
    end
    
    context '#convert_range_to_points' do
      let(:start_point) {klass.convert_range_to_points(1..10, 1).first}
      let(:end_point) {klass.convert_range_to_points(1..10, 1).last}
      
      context 'returns a start point' do
        it 'of class StartPoint' do
          expect(start_point).to be_an_instance_of(StartPoint)
        end
        
        it 'with a value equal to the first value in the range' do
          expect(start_point.value).to eq(1)
        end
        
        it 'with an id' do
          expect(start_point.id).to eq(1)
        end
      end
      
      context 'returns an end point' do
        it 'of class EndPoint' do
          expect(end_point).to be_an_instance_of(EndPoint)
        end
        
        it 'with a value equal to the last value in the range' do
          expect(end_point.value).to eq(10)
        end
        
        it 'with an id' do
          expect(end_point.id).to eq(1)
        end
      end
    end
    
    context '#parse_input' do
      context 'returns a collection of start and end points when given valid input' do        
        context 'consisting of non-Range objects' do
          let(:output) { klass.parse_input(valid_obj_input, {start_attr: :start_point, end_attr: :end_point})}
          
          it 'where the collection is an Array' do
            expect(output).to be_an_instance_of(Array)
          end
          
          it 'where the start points are StartPoint objects' do
            expect(output.first).to be_an_instance_of(StartPoint)
          end
            
          it 'where the end points are EndPoint objects' do
            expect(output.last).to be_an_instance_of(EndPoint)
          end

          it 'where the collection is sorted by the value attribute of each point' do
            expect(output).to eq(output.sort_by {|point| point.value})
          end
          
          context 'having an id attribute' do
            it 'where the id of each start point point matches that of its originating object' do
              expect(output.first.id).to eq(1)
            end
            it 'where the id of each end point point matches that of its originating object' do
              expect(output.last.id).to eq(1)
            end
          end
          
          context 'not having an id attribute' do
            let(:valid_obj_input) {[ObjectWithRange.new(1, 10), ObjectWithRange.new(1, 5), ObjectWithRange.new(3, 6)]}
            it 'where the id of each start point matches the index of its originating object as found in the input array' do
              expect(output.first.id).to eq(0)
            end
            
            it 'where the id of each end point matches the index of its originating object as found in the input array' do
              expect(output.last.id).to eq(0)
            end
          end
        end
        
        context 'consisting of Range objects' do
          let(:output) { klass.parse_input(valid_range_input)}
          
          it 'where the collection is an Array' do
            expect(output).to be_an_instance_of(Array)
          end
          
          it 'where the start points are StartPoint objects' do
            expect(output.first).to be_an_instance_of(StartPoint)
          end
            
          it 'where the end points are EndPoint objects' do
            expect(output.last).to be_an_instance_of(EndPoint)
          end

          it 'where the collection is sorted by the value attribute of each point' do
            expect(output).to eq(output.sort_by {|point| point.value})
          end
          
          it 'where the id of the start points match the index of its originating range as found in the input array' do
            expect(output.first.id).to eq(0)
          end
          
          it 'where the id of the end points match the index of its originating range as found in the input array' do
            expect(output.last.id).to eq(0)
          end
        end
      end
    
      context 'when given invalid input' do
        it 'raises an error' do
          expect {klass.parse_input(['a', 1..5])}.to raise_error #Not sure if I need to specify an error type or if I can leave a general catch-all type 'raise_error' call.
        end
      end
    end
  end
end