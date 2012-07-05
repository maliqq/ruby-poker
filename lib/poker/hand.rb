module Poker
  autoload :High, 'poker/hand/high'
  autoload :Badugi, 'poker/hand/badugi'
  autoload :Low, 'poker/hand/low'
  
  class Hand
    include Comparable
    
    attr_reader :cards, :kinds, :suits
    attr_accessor :rank, :high, :value, :kickers
    
    def initialize(cards)
      @cards = cards
      @kinds = @cards.group_by(&:kind)
      @suits = @cards.group_by(&:suit)
      @kickers = []
      @high = @value = @rank = nil
    end
    
    def paired(n = nil)
      @kinds.values.select { |g| n ? g.size == n : g.size > 1 }
    end
    
    def suited(n = nil)
      @suits.values.select { |g| n ? g.size == n : g.size > 1 }
    end

    def gaps
      gaps = []
      gap = []
      prev = nil
      aces = @cards.select { |a| a.kind == "A" }
      (@cards.sort.reverse + aces).each_with_index { |card, i|
        if i == 0
          gap << card
          prev = card
          next
        end
        if prev.index == card.index
          #gap << card
        elsif prev.index - card.index == 1 || card.index - prev.index == 12
          gap << card
        else
          gaps << gap
          gap = [card]
        end
        prev = card
      }
      gaps << gap
      gaps
    end
    
    def high
      @high ||= []
    end

    def ==(b)
      @rank == b.rank && @value == b.value && @kickers == b.kickers
    end

    def ==(b)
      self.rank == b.rank && self.value == b.value
    end

    def inspect
      "<#{@rank}:#{@cards.inspect} high=#{@high.inspect} value=#{@value.inspect} kickers=#{@kickers.inspect}>"
    end
  end
end
