require 'spec_helper'

describe Hand::Badugi do
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
