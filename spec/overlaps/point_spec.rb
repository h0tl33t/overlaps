require 'spec_helper'

module Overlaps
  describe Point do
    subject { described_class.new(10, 1) }

    it { should respond_to(:value) }
    it { should respond_to(:id) }

    its(:value) { should == 10 }
    its(:id) { should == 1 }

    it { should_not be_start }
    it { should_not be_end }

    describe "#<=>" do
      context "when passed a point with a lesser value" do
        let(:point) { described_class.new(5,1) }
        it "returns 1" do
          (subject <=> point).should == 1
        end
      end

      context "when passed a point with equal value" do
        let(:point) { described_class.new(10,1) }

        it "returns 0" do
          (subject <=> point).should == 0
        end
      end

      context "when passed a point of greater value" do
        let(:point) { described_class.new(20, 1) }

        it "returns -1" do
          (subject <=> point).should == -1
        end
      end
    end
  end
end