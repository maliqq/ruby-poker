Given /^hand (.*)$/ do |cards|
  @hand = Hand::Badugi[cards]
end

When /^detect$/ do
  @rank = @hand.rank
end

Then /^rank should be (.*)$/ do |rank|
  @rank.should == rank.to_sym
end

Then /^(.*_cards) should be (.*)$/ do |method, cards|
  @hand.send(method).should == cards.split(//)
end
