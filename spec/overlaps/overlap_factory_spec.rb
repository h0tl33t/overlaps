require 'spec_helper'

module Overlaps
  describe OverlapFactory do

    describe "#overlaps" do
      let(:point1) { double 'point', start?: true, end?: false, id: 0, value: 1 }
      let(:point2) { double 'point', start?: true, end?: false, id: 1, value: 2 }
      let(:point3) { double 'point', start?: true, end?: false, id: 2, value: 3 }
      let(:point4) { double 'point', start?: false, end?: true, id: 2, value: 6 }
      let(:point5) { double 'point', start?: false, end?: true, id: 1, value: 8 }
      let(:point6) { double 'point', start?: false, end?: true, id: 0, value: 9}
      let(:points) { [point1, point2, point3, point4, point5, point6] }
      let(:overlap1) { double 'overlap1' }
      let(:overlap2) { double 'overlap2' }
      subject { described_class.new(points) }

      before do
        Overlap.stub(:new).with(3, 6, [0,1,2,]).and_return(overlap1)
        Overlap.stub(:new).with(2, 8, [0,1]).and_return(overlap2)
      end

      it "returns the correct set of overlaps" do
        subject.overlaps.should == [overlap1, overlap2]
      end
    end
  end
end