require 'spec_helper'

describe Hand do
  describe Hand::High do
    example 'royal flush' do
      Hand::High['AsKsQsJsTs'].rank.should == :straight_flush
      Hand::High['AsKsQsJsTsQc'].should == Hand::High['AdKdQdJdTdTs']
    end

    example 'four kind' do
      Hand::High['AsAhAdAcKc'].rank.should == :four_kind
      Hand::High['AsAhAdAcKc'].should > Hand::High['AsAhAdAcQc']
    end
    
    example 'full house' do
      Hand::High['AhAdAcKhKd'].should > Hand::High['AhAdAcQhQd']
      Hand::High['AhAdAcKhKd'].should > Hand::High['KhKdKcQhQd']
    end

    example 'flash' do
      Hand::High['AdKdJdTd9d7d'].should == Hand::High['AsKsJsTs9s7s']
    end

    example 'wheel straight' do
      Hand::High['Ad2c3d4d5d'].rank.should == :straight
      Hand::High['Ad2d3d4d5d'].rank.should == :straight_flush
    end

    example 'three kind' do
    end

    example 'two pair' do
      Hand::High['AhAdKhKd7d'].should > Hand::High['AhAdQhQd7d']
    end
    
    example 'comparing kickers' do
      Hand::High['AhAdAcAsKd'].should > Hand::High['AhAdAcAsQd']
    end
  end
  
  describe Hand::Badugi do
    example 'four' do
      Hand::Badugi['AsKcQdTh'].rank.should == :badugi4
    end
    
    example 'three' do
      Hand::Badugi['AsAc9h8d'].rank.should == :badugi3
      Hand::Badugi['AsKs9h8d'].rank.should == :badugi3
      Hand::Badugi['AsAc9c8d'].rank.should == :badugi3
      Hand::Badugi['AdQc9s8s'].rank.should == :badugi3
    end
    
    example 'two' do
      Hand::Badugi['AsAcKdKc'].rank.should == :badugi2
      Hand::Badugi['AsAcAd6c'].rank.should == :badugi2
      Hand::Badugi['JsTs8sAd'].rank.should == :badugi2
      Hand::Badugi['AdAc9c9c'].rank.should == :badugi2
    end
    
    example 'one' do
      Hand::Badugi['AsAcAdAh'].rank.should == :badugi1
      Hand::Badugi['AsKsQsJs'].rank.should == :badugi1
    end
  end
end
