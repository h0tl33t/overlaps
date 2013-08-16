require 'spec_helper'

module Overlaps
  describe EndPoint do
    subject {EndPoint.new(10, 1)}
    
    it {should respond_to(:value)}
    it {should respond_to(:id)}
    
    its(:value) {should == 10}
    its(:id) {should == 1}
    
    it {should_not be_start}
    it {should be_end}
  end
end