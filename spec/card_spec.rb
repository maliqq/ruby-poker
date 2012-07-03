require 'spec_helper'

describe Card do
  example 'new' do
    card = Card.new('A', 's')
    card.to_s.should == 'As'
    
    Card['Ks'].kind.should == 'K'
    Card[card.to_i].should == card
    Card[card].should == card
  end
  
  example 'parse' do
    Card['AhAdAcAs'].size.should == 4
    puts Card.deck.to_s
  end
end
