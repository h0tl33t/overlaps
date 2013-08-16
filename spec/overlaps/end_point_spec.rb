require 'spec_helper'

module Overlaps
  describe EndPoint do
    it 'has a value'
    it 'has an id it belongs to'
    
    context "#start?" do
      it 'returns false'
    end
    
    context "#end?" do
      it 'returns true'
    end
  end
end