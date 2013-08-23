require 'spec_helper'

describe Overlaps do
  it 'has a version' do
    expect(Overlaps::VERSION).to_not be_nil
  end
  
  it {should respond_to(:valid_input? )}
  it {should respond_to(:grab_id)}
  it {should respond_to(:convert_range_to_points)}
  it {should respond_to(:parse_input)}
  
  context 'included in a class' do
    subject(:klass) {Class.new {include Overlaps}}
    
    let(:date_ranges) {[Date.parse('2013-01-01')..Date.parse('2013-06-30'), Date.parse('2013-02-14')..Date.parse('2013-04-01'), Date.parse('2013-03-01')..Date.parse('2013-12-25'), Date.parse('2013-01-21')..Date.parse('2013-11-04')]}
    let(:time_ranges) {[Time.parse('8:00AM')..Time.parse('8:00PM'), Time.parse('11:00AM')..Time.parse('5:30PM'), Time.parse('1:00AM')..Time.parse('12:45PM'), Time.parse('12:00PM')..Time.parse('11:00PM')]}
    let(:float_ranges) {[(1.1..5.9), (3.3..7.1), (0.5..15.9), (6.6..16.6), (5.5..10.2)]}
    let(:fixnum_ranges) {[(1..100), (25..55), (30..110), (150..175), (10..27)]}

    it {should respond_to(:count_overlaps)}
    it {should respond_to(:find_overlaps)}
    
    context '#count_overlaps' do
      let(:output) {klass.count_overlaps(fixnum_ranges)}
      it 'returns a numeric count' do
        expect(output).to be_an_instance_of(Fixnum)
      end
      
      context 'when given an array of ranges with 5 overlaps' do
        it 'returns 5' do
          expect(output).to eq(5)
        end
      end
      
      context 'when given an array of date ranges with 6 overlaps' do
        let(:output) {klass.count_overlaps(date_ranges)}
        it 'returns 6' do
          expect(output).to eq(6)
        end
      end
      
      context 'when given an array of time ranges with 6 overlaps' do
        let(:output) {klass.count_overlaps(time_ranges)}
        it 'returns 6' do
          expect(output).to eq(6)
        end
      end
    end
    
    context '#find_overlaps' do
      context 'given an array of objects having start and end point attributes' do
        context 'having 3 overlaps' do
          let(:objects_with_range) {[ObjectWithRange.new(1, 10, 1), ObjectWithRange.new(1, 5, 2), ObjectWithRange.new(3, 6, 3)]}
          let(:output) {klass.find_overlaps(objects_with_range, {start_attr: :start_point, end_attr: :end_point})}
          
          it 'returns output in an array' do
            expect(output).to be_an_instance_of(Array)
          end
          
          it 'returns a set of Overlap objects' do
            expect(output.first).to be_an_instance_of(Overlaps::Overlap)
          end
          
          it 'returns 3 overlaps' do
            expect(output.size).to eq(3)
          end
          
          it 'returns the correct set of overlaps' do
            expect(output[0].range).to eq(3..5)
            expect(output[0].ids).to match_array([1,2,3])
            expect(output[1].range).to eq(1..5)
            expect(output[1].ids).to match_array([1,2])
            expect(output[2].range).to eq(3..6)
            expect(output[2].ids).to match_array([1,3])
          end
        end
      end
      
      context 'given an array of fixnum ranges with 5 overlaps' do
        let(:output) {klass.find_overlaps(fixnum_ranges)}
        
        it 'returns output in an array' do
          expect(output).to be_an_instance_of(Array)
        end
        
        it 'returns a set of Overlap objects' do
          expect(output.first).to be_an_instance_of(Overlaps::Overlap)
        end
        
        it 'returns 5 overlaps' do
          expect(output.size).to eq(5)
        end
        
        it 'returns the correct set of overlaps' do
          expect(output[0].range).to eq(25..27)
          expect(output[0].ids).to match_array([0,4,1])
          expect(output[1].range).to eq(10..27)
          expect(output[1].ids).to match_array([0,4])
          expect(output[2].range).to eq(30..55)
          expect(output[2].ids).to match_array([0,1,2])
          expect(output[3].range).to eq(25..55)
          expect(output[3].ids).to match_array([0,1])
          expect(output[4].range).to eq(30..100)
          expect(output[4].ids).to match_array([0,2])
        end
      end
      
      context 'given an array of float ranges with 9 overlaps' do
        let(:output) {klass.find_overlaps(float_ranges)}
        
        it 'returns output in an array' do
          expect(output).to be_an_instance_of(Array)
        end
        
        it 'returns a set of Overlap objects' do
          expect(output.first).to be_an_instance_of(Overlaps::Overlap)
        end
        
        it 'returns 9 overlaps' do
          expect(output.size).to eq(9)
        end
        
        it 'returns the correct set of overlaps' do
          expect(output[0].range).to eq(5.5..5.9)
          expect(output[0].ids).to match_array([2,0,1,4])
          expect(output[1].range).to eq(3.3..5.9)
          expect(output[1].ids).to match_array([2,0,1])
          expect(output[2].range).to eq(1.1..5.9)
          expect(output[2].ids).to match_array([2,0])
          expect(output[3].range).to eq(6.6..7.1)
          expect(output[3].ids).to match_array([2,1,4,3])
          expect(output[4].range).to eq(5.5..7.1)
          expect(output[4].ids).to match_array([2,1,4])
          expect(output[5].range).to eq(3.3..7.1)
          expect(output[5].ids).to match_array([2,1])
          expect(output[6].range).to eq(6.6..10.2)
          expect(output[6].ids).to match_array([2,4,3])
          expect(output[7].range).to eq(5.5..10.2)
          expect(output[7].ids).to match_array([2,4])
          expect(output[8].range).to eq(6.6..15.9)
          expect(output[8].ids).to match_array([2,3])
        end
      end
      
      context 'given an array of date ranges with 6 overlaps' do
        let(:output) {klass.find_overlaps(date_ranges)}
        
        it 'returns output in an array' do
          expect(output).to be_an_instance_of(Array)
        end
        
        it 'returns a set of Overlap objects' do
          expect(output.first).to be_an_instance_of(Overlaps::Overlap)
        end
        
        it 'returns 6 overlaps' do
          expect(output.size).to eq(6)
        end
      
       it 'returns the correct set of overlaps' do
          expect(output[0].range).to eq(Date.parse('2013-03-01')..Date.parse('2013-04-01'))
          expect(output[0].ids).to match_array([0,3,1,2])
          expect(output[1].range).to eq(Date.parse('2013-02-14')..Date.parse('2013-04-01'))
          expect(output[1].ids).to match_array([0,3,1])
          expect(output[2].range).to eq(Date.parse('2013-01-21')..Date.parse('2013-04-01'))
          expect(output[2].ids).to match_array([0,3])
          expect(output[3].range).to eq(Date.parse('2013-03-01')..Date.parse('2013-06-30'))
          expect(output[3].ids).to match_array([0,3,2])
          expect(output[4].range).to eq(Date.parse('2013-01-21')..Date.parse('2013-06-30'))
          expect(output[4].ids).to match_array([0,3])
          expect(output[5].range).to eq(Date.parse('2013-03-01')..Date.parse('2013-11-04'))
          expect(output[5].ids).to match_array([3,2])
       end
      end
      
      context 'given an array of time ranges with 6 overlaps' do
        let(:output) {klass.find_overlaps(time_ranges)}
        
        it 'returns output in an array' do
          expect(output).to be_an_instance_of(Array)
        end
        
        it 'returns a set of Overlap objects' do
          expect(output.first).to be_an_instance_of(Overlaps::Overlap)
        end
        
        it 'returns 6 overlaps' do
          expect(output.size).to eq(6)
        end
      
       it 'returns the correct set of overlaps' do
          expect(output[0].range).to eq(Time.parse('12:00PM')..Time.parse('12:45PM'))
          expect(output[0].ids).to match_array([2,0,1,3])
          expect(output[1].range).to eq(Time.parse('11:00AM')..Time.parse('12:45PM'))
          expect(output[1].ids).to match_array([2,0,1])
          expect(output[2].range).to eq(Time.parse('8:00AM')..Time.parse('12:45PM'))
          expect(output[2].ids).to match_array([2,0])
          expect(output[3].range).to eq(Time.parse('12:00PM')..Time.parse('5:30PM'))
          expect(output[3].ids).to match_array([0,1,3])
          expect(output[4].range).to eq(Time.parse('11:00AM')..Time.parse('5:30PM'))
          expect(output[4].ids).to match_array([0,1])
          expect(output[5].range).to eq(Time.parse('12:00PM')..Time.parse('8:00PM'))
          expect(output[5].ids).to match_array([0,3])
       end
      end
    end
  end
end