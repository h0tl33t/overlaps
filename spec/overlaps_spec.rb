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
    end
  end
end