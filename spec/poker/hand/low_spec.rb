require 'spec_helper'
require 'poker/hand/low'

describe Hand::Low do
  example 'ace to five' do
    Hand::Low.ace_five?('QhAh3h5h6h7h').value.should == %w(A 3 5 6 7)
    #Hand::Low.ace_five('Jd4s6d5s5c4c6s').value.should == %w(4 5 6 J 4)
    Hand::Low.deuce_seven?('2s3s4s5s7d').value.should == %w(2 3 4 5 7)

    r = Hand::Low.deuce_seven?('2s3s4s5s7d') <=> Hand::Low.deuce_seven?('2s3s4s5s8d')
    r.should == 1
    
    Hand::Low.deuce_seven?('2s3s4s5s7d').should be > Hand::Low.deuce_seven?('2s3s4s5s7s')
    Hand::Low.deuce_seven?('2s3s4s5s7s').should be > Hand::Low.deuce_seven?('3s4s5s7s8s')
    
    Hand::Low.ace_five8?('2s3s4s7s9c').rank.should be_nil
    Hand::Low.ace_five8?('2s3s4s7s8c').rank.should == :low
  end
end
