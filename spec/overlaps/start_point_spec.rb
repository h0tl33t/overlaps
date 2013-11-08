require 'spec_helper'

module Overlaps
  describe StartPoint do
    subject { described_class.new(10, 1) }

    it { should respond_to(:value) }
    it { should respond_to(:id) }

    its(:value) { should == 10 }
    its(:id) { should == 1 }

    it { should be_start }
    it { should_not be_end }
  end
end