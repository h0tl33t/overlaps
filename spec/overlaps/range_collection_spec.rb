require 'spec_helper'

module Overlaps
  describe RangeCollection do

    let(:ranges) { [1..100, 25..75, 50..90] }
    let(:accessors) { Hash.new }
    let(:pseudo_range) { double('pseudo_range', points: [1,5], type: :cool) }
    subject { described_class.new(ranges, accessors) }

    context "when initialized" do
      it "converts each of the passed ranges to PseudoRange objects before storing" do
        PseudoRange.stub(new: pseudo_range)
        PseudoRange.should_receive(:new).exactly(ranges.size).times
        described_class.new(ranges, accessors)
      end
    end

    describe "#ranges" do
      it "returns an array of PseudoRange objects" do
        subject.ranges.map(&:class).uniq.should == [PseudoRange]
      end
    end

    describe "#points" do
      it "returns a sorted list of points" do
        PseudoRange.stub(new: pseudo_range)
        pseudo_range.should_receive(:points).exactly(ranges.size).times
        subject.points.should == [1,1,1,5,5,5]
      end
    end
  end
end