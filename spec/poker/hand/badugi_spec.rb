require 'spec_helper'

describe Hand::Badugi do
  example 'comparing' do
    Hand::Badugi['AsAcAdAh'].should be < Hand::Badugi['AsKcQdTh']
    Hand::Badugi['AsAc9h8d'].should be < Hand::Badugi['As2c3d4h']
    Hand::Badugi['AsKcQdTh'].should be < Hand::Badugi['As2c3d4h']
    Hand::Badugi['AsKcQdTh'].should be < Hand::Badugi['As2c3d4h']
  end

  example 'four' do
    Hand::Badugi['AsKcQdTh'].value.should == %w(A T Q K)
    Hand::Badugi['As2c3d4h'].value.should == %w(A 2 3 4)
  end
  
  example 'three' do
    Hand::Badugi['AsAc9h8d'].value.should == %w(A 8 9)
    Hand::Badugi['AsKs9h8d'].value.should == %w(A 8 9)
    Hand::Badugi['AsAc9c8d'].value.should == %w(A 8 9)
    Hand::Badugi['AdQc9s8s'].value.should == %w(A 8 Q)
    Hand::Badugi['4d4hAd9s'].value[2].suit.should_not == 'd'  
  end
  
  example 'two' do
    Hand::Badugi['AsAcKdKc'].value.should == %w(A K)
    Hand::Badugi['AsAcAd6c'].value.should == %w(A 6)
    Hand::Badugi['JsTs8sAd'].value.should == %w(A 8)
    Hand::Badugi['AdAc9c9c'].value.should == %w(A 9)
    Hand::Badugi['9h6sKh9s'].value.should == %w(6 9)
  end
  
  example 'one' do
    Hand::Badugi['AsAcAdAh'].value.should == %w(A)
    Hand::Badugi['AsKsQsJs'].value.should == %w(A)
  end
end
