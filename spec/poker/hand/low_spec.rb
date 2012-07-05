require 'spec_helper'
require 'poker/hand/low'

describe Low do
  example 'ace to five' do
    Low.ace_five('QhAh3h5h6h7h').value.should == %w(A 3 5 6 7)
    #Low.ace_five('Jd4s6d5s5c4c6s').value.should == %w(4 5 6 J 4)
    Low.deuce_seven('2s3s4s5s7d').value.should == %w(2 3 4 5 7)
  end
end
