require 'spec_helper'

describe Overlaps do
  it 'has a version' do
    expect(Overlaps::VERSION).to_not be_nil
  end

  describe "#find" do
    let(:ranges) { [1..10, 3..6] }
    let(:options) { Hash.new }
    let(:overlaps) { 'overlaps' }
    let(:overlap_factory) { double 'overlap_factory', overlaps: overlaps}
    let(:range_collection) { double 'range_collection', points: 'PONITZ!' }
    let(:overlaps) { double 'overlaps' }

    it "it creates a RangeCollection with provided input" do
      Overlaps::OverlapFactory.stub(:new => overlap_factory )
      Overlaps::OverlapFactory.stub(:overlaps)
      Overlaps::RangeCollection.should_receive(:new).with(ranges, options).and_return(range_collection)
      subject.find(ranges, options)
    end

    it "it makes an OverlapsFactory with that RangeCollection" do
      Overlaps::RangeCollection.stub(:new).with(ranges, options).and_return(range_collection)
      Overlaps::OverlapFactory.should_receive(:new).with(range_collection.points).and_return(overlap_factory)
      subject.find(ranges, options)
    end

    it "it calls overlaps on the created OverlapFactory" do
      Overlaps::RangeCollection.stub(:new).with(ranges, options).and_return(range_collection)
      Overlaps::OverlapFactory.stub(:new).with(range_collection.points).and_return(overlap_factory)
      overlap_factory.should_receive(:overlaps).and_return(overlaps)
      subject.find(ranges, options)
    end
  end

  describe "#count" do
    let(:ranges) { [1..100, 25..75] }

    it "returns the number of overlaps found" do
      subject.count(ranges).should == 1
    end
  end
end