require 'spec_helper'

describe Hand::High do
  example 'royal flush' do
    Hand::High['AsKsQsJsTs'].rank.should == :straight_flush
    Hand::High['AsKsQsJsTsQc'].should == Hand::High['AdKdQdJdTdTs']
    Hand::High['AsKsQsJsTs'].should be > Hand::High['9d9c9sJdJs']
  end

  example 'straight flush' do
    h = Hand::High['AsQsJsTs9s8s']
    h.rank.should == :straight_flush
    h.high.should == ['Q']
  end

  example 'four kind' do
    Hand::High['AsAhAdAcKc'].rank.should == :four_kind
    Hand::High['AsAhAdAcKc'].should > Hand::High['AsAhAdAcQc']
  end
  
  example 'full house' do
    Hand::High['AhAdAcKhKd'].should > Hand::High['AhAdAcQhQd']
    Hand::High['AhAdAcKhKd'].should > Hand::High['KhKdKcQhQd']
  end

  example 'flush' do
    Hand::High['AdKdJdTd9d7d'].should == Hand::High['AsKsJsTs9s7s']
    Hand::High['2s7sKs7hQc9s8s'].rank.should == :flush
  end

  example 'wheel straight' do
    Hand::High['Ad2c3d4d5d'].rank.should == :straight
    Hand::High['Ad2d3d4d5d'].rank.should == :straight_flush
    Hand::High['8h4dAc5s3h6s4c'].rank.should_not == :straight
  end

  example 'three kind' do
  end

  example 'two pair' do
    Hand::High['AhAdKhKd7d'].should > Hand::High['AhAdQhQd7d']
  end
  
  example 'comparing kickers' do
    Hand::High['AhAdAcAsKd'].should > Hand::High['AhAdAcAsQd']
  end

  example 'comparing' do
    board = Card['3s8s8c7h2c']
    hands = [
      Hand::High[Card['9s9h'] + board],
      Hand::High[Card['9s8s'] + board],
      Hand::High[Card['8s3s'] + board]
    ]
    hands.max.rank.should == :full_house
  end
end
