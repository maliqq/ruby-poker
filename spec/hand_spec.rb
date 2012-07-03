require 'spec_helper'

describe Hand do
  example 'royal flush' do
    Hand::High['AsKsQsJsTs'].rank.should == :straight_flush
    Hand::High['AsAhAdAcKc'].rank.should == :four_kind
  end
  
  example 'comparing quads full houses and two pairs' do
    Hand::High['AhAdAcKhKd'].should > Hand::High['AhAdAcQhQd']
    Hand::High['AhAdAcKhKd'].should > Hand::High['KhKdKcQhQd']
    Hand::High['AhAdKhKd7d'].should > Hand::High['AhAdQhQd7d']
  end
  
  example 'comparing kickers' do
    Hand::High['AhAdAcAsKd'].should > Hand::High['AhAdAcAsQd']
  end
end
