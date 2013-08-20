require 'spec_helper'


describe Overlaps do
  it 'provides its version number'
  
  it {should respond_to( :valid_input? )}
  
  context 'included in a class' do
    subject(:klass) {Class.new {include Overlaps}}
    
    it 'counts overlaps'
    it 'finds overlaps'
    
  end
end