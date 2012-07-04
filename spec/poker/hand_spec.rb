require 'spec_helper'

describe Hand do
  describe High do
    example 'royal flush' do
      High['AsKsQsJsTs'].rank.should == :straight_flush
      High['AsKsQsJsTsQc'].should == High['AdKdQdJdTdTs']
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
  
  describe Badugi do
    example 'four' do
      Badugi['AsKcQdTh'].value.should == %w(A T Q K)
      Badugi['As2c3d4h'].value.should == %w(A 2 3 4)
    end
    
    example 'three' do
      Badugi['AsAc9h8d'].value.should == %w(A 8 9)
      Badugi['AsKs9h8d'].value.should == %w(A 8 9)
      Badugi['AsAc9c8d'].value.should == %w(A 8 9)
      Badugi['AdQc9s8s'].value.should == %w(A 8 Q)
      Badugi['4d4hAd9s'].value[2].suit.should_not == 'd'  
    end
    
    example 'two' do
      Badugi['AsAcKdKc'].value.should == %w(A K)
      Badugi['AsAcAd6c'].value.should == %w(A 6)
      Badugi['JsTs8sAd'].value.should == %w(A 8)
      Badugi['AdAc9c9c'].value.should == %w(A 9)
    end
    
    example 'one' do
      Badugi['AsAcAdAh'].value.should == %w(A)
      Badugi['AsKsQsJs'].value.should == %w(A)
    end
  end
end
