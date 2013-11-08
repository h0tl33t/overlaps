require 'spec_helper'

module Overlaps
  describe PseudoRange do

    let(:range) { 1..100 }
    let(:accessors) { {index: 5} }
    subject { described_class.new(range, accessors) }

    context "when initialized with a Range object" do
      context "without an index in the accompanying hash" do
        it "raises an error" do
          expect { described_class.new(range) }.to raise_error(ArgumentError)
        end
      end

      context "with an index in the accompanying hash" do
        subject { described_class.new(range, accessors) }

        it "creates a start_point of class Overlaps::StartPoint" do
          subject.start_point.class == Overlaps::StartPoint
        end

        it "creates a start point with the index as the id" do
          subject.start_point.id == 5
        end

        it "creates an end_point of class Overlaps::EndPoint" do
          subject.end_point.class == Overlaps::EndPoint
        end

        it "creates an end point with the index as the id" do
          subject.end_point.id == 5
        end
      end
    end

    context "when initialized with a non-Range object" do
      let(:range) { double 'range', start_point: 1, end_point: 100, id: 5 }

      context "without a start accessor in the accompanying hash" do
        let(:accessors) { {end: :end_point, id: :id} }

        it "raises an error" do
          expect { described_class.new(range, accessors) }.to raise_error(ArgumentError)
        end
      end

      context "without an end accessor in the accompanying hash" do
        let(:accessors) { {start: :start_point, id: :id} }

        it "raises an error" do
          expect { described_class.new(range, accessors) }.to raise_error(ArgumentError)
        end
      end

      context "where the start and end points are of a different class" do
        let(:range) { double 'range', start_point: 1, end_point: 'z', id: 5 }
        let(:accessors) { {start: :start_point, end: :end_point, id: :id} }

        it "raises an error" do
          expect { described_class.new(range, accessors) }.to raise_error(TypeError)
        end
      end

      context "with valid input" do
        let(:accessors) { {start: :start_point, end: :end_point, id: :id} }
        subject { described_class.new(range, accessors) }

        context "creates a start point" do
          it "of class Overlaps::StartPoint" do
            subject.start_point.class.should == Overlaps::StartPoint
          end

          it "with the start value of the original range as determined by the start accessor" do
            subject.start_point.value.should == 1
          end

          it "with the id from the original object as determined by the id accessor" do
            subject.start_point.id.should == 5
          end
        end

        context "creates an end point" do
          it "of class Overlaps::EndPoint" do
            subject.end_point.class.should == Overlaps::EndPoint
          end

          it "with the start value of the original range as determined by the start accessor" do
            subject.end_point.value.should == 100
          end

          it "with the id from the original object as determined by the id accessor" do
            subject.end_point.id.should == 5
          end
        end
      end
    end

    describe "#points" do
      it "returns an array containing the start and end point" do
        subject.points.should == [subject.start_point, subject.end_point]
      end
    end

    describe "#range" do
      it "returns a Range using the start and end point values" do
        subject.range.should == (1..100)
      end
    end

    describe "#type" do
      it "returns the class of the start and end point values" do
        subject.type.should == Fixnum
      end
    end
  end
end