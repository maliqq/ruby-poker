Given /^hand (.*)$/ do |cards|
  @hand = @ranking[cards]
end

Then /^rank should be (.*)$/ do |rank|
  @hand.rank.should == rank.to_sym
end

Then /^(.*_cards) are empty$/ do |method|
  @hand.send(method).should be_empty
end

Then /^(.*_cards) should be (.*)$/ do |method, cards|
  @hand.send(method).should == cards.split(//)
end
