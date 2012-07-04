require 'spec_helper'
require 'poker/hand/low'

describe Low do
  example 'ace to five' do
    Low.ace_five('QhAh3h5h6h7h').value.should == %w(A 3 5 6 7)
  end
end
