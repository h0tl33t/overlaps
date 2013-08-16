require 'spec_helper'

module Overlaps
  describe Overlap do
    subject(:overlap) {Overlap.new(5,10,[1,2])}
    
    it {should respond_to(:start_point)}
    it {should respond_to(:end_point)}
    it {should respond_to(:ids)}
    
    its(:start_point) {should == 5}
    its(:end_point) {should == 10}
    
    its(:ids) {should be_an_instance_of(Array)}
    its(:ids) {should == [1,2]}
    
    its(:range) {should == (5..10)}
  end
end