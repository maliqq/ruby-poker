require 'spec_helper'

describe Card do
  example 'card' do
    Card::KINDS.size.should == 13
    Card::SUITS.size.should == 4
    Card::ACE.should == Card::KINDS.index('A')
  end

  example 'low' do
    a = Card.new('A', 's')
    a.low.should be_false
    a.index.should == Card::ACE

    a.low = true
    a.index.should == 0
  end

  example 'parse' do
    Card.parse(['Ah', 'Ad', 'Ac']).map { |card| card.kind.should == 'A' }
    Card.parse('AsJsKs').size.should == 3
    Card['AsJsKs'].size.should == 3
    Card['Ah', 'Ad', 'Ac', 'Ac'].size.should == 4
    -> { Card.parse(nil) }.should raise_error(ArgumentError)
  end

  example 'wrap' do
    Card.wrap(51).kind.should == 'A'
    Card.wrap(50).suit.should == 'h'
    ah = Card.wrap(50)
    Card.wrap(ah).should === ah
    Card.wrap('Ah').should === ah
    ah.to_i.should == 50
  end

  example 'new' do
    card = Card.new('A', 's')
    card.to_s.should == 'As'

    -> { Card.new('F', 's') }.should raise_error(ArgumentError)
    -> { Card.new('A', 'x') }.should raise_error(ArgumentError)
    
    Card('Ks').kind.should == 'K'
    Card(card.to_i).should == card
    Card(card).should == card
  end
  
  example 'deck' do
    deck = Card.deck
    deck.size.should == 52
    deck.min.kind.should == '2'
    deck.max.kind.should == 'A'
    deck.map! { |c| c.low = true; c }
    deck.min.kind.should == 'A'
    deck.max.kind.should == 'K'
  end

  example 'to string' do
    c = Card('As')
    c.to_s.should == 'As'
    c.to_str.should == 'A' + Card::CHARS.first
  end
end
