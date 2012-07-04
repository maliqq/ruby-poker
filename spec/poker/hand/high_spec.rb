require 'spec_helper'

describe Hand::High do
  example 'royal flush' do
    High['AsKsQsJsTs'].rank.should == :straight_flush
    High['AsKsQsJsTsQc'].should == High['AdKdQdJdTdTs']
  end

  example 'straight flush' do
    h = High['AsQsJsTs9s8s']
    h.rank.should == :straight_flush
    h.high.should == ['Q']
  end

  example 'four kind' do
    High['AsAhAdAcKc'].rank.should == :four_kind
    High['AsAhAdAcKc'].should > High['AsAhAdAcQc']
  end
  
  example 'full house' do
    High['AhAdAcKhKd'].should > High['AhAdAcQhQd']
    High['AhAdAcKhKd'].should > High['KhKdKcQhQd']
  end

  example 'flash' do
    High['AdKdJdTd9d7d'].should == High['AsKsJsTs9s7s']
  end

  example 'wheel straight' do
    High['Ad2c3d4d5d'].rank.should == :straight
    High['Ad2d3d4d5d'].rank.should == :straight_flush
    High['8h4dAc5s3h6s4c'].rank.should_not == :straight
  end

  example 'three kind' do
  end

  example 'two pair' do
    High['AhAdKhKd7d'].should > High['AhAdQhQd7d']
  end
  
  example 'comparing kickers' do
    High['AhAdAcAsKd'].should > High['AhAdAcAsQd']
  end
end
