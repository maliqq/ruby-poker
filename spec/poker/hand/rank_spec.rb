require 'spec_helper'

describe Rank do
  describe 'compares' do
    a1 = Hand::High['Ah']
    a2 = Hand::High['Ad']
    r = Rank[
      Hand::High['9d'],
      a1,
      a2,
      Hand::High['7d']
    ]
    r.winners.should == [a1, a2]
  end
end
