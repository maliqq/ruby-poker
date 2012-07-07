Given /^(.*) low (.*)$/ do |low_ranking, cards|
  @hand = Hand::Low.send("#{low_ranking}?", cards)
end
