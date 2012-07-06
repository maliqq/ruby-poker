require 'spec_helper'

describe Hand do
  example 'new' do
    h = Hand.new(Card['As7s8s9s'])
    h.high_cards.should be_empty
    h.kicker_cards.should be_empty
    h.value_cards.should be_nil
    h.rank.should be_nil
  end

  example 'low' do
    h = Hand.new(Card['As7s8s9s'])
    h.cards.max.should == 'A'
    h = Hand.new(Card['As7s8s9s'], low: true)
    h.cards.max.should == '9'
  end

  example 'qualifier' do
    h = Hand.new(Card['As7s9s4d'], qualifier: '8')
    h.cards.should_not include('9')
    h.cards.should_not include('A')
    
    h = Hand.new(Card['As7s9s4d'], qualifier: '8', low: true)
    h.cards.should include('A')
  end

  example 'kinds' do
    h = Hand.new(Card['AsAdAcKsKd'])
    h.kinds.size.should == 2
    h.paired.size.should == 2
    h.paired.map(&:first).should == %w(A K)
  end

  example 'suits' do
    h = Hand.new(Card['AsKsQs7d8d9dTc'])
    h.suits.size.should == 3
    h.suits.keys.should == %w(s d c)
    h.suited.size.should == 2
    h.suited.map(&:first).map(&:suit).should == %w(s d)
  end

  example 'gaps' do
    h = Hand.new(Card['2s3d4c5d7s8sTsJs'])
    h.gaps.size.should == 3
    h.gaps.map(&:first).should == %w(J 8 5)

    h = Hand.new(Card['As2s3s4s5s'])
    h.gaps.second.should == %w(5 4 3 2 A)
  end
end
