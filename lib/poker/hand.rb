module Poker
  autoload :High, 'poker/hand/high'
  autoload :Badugi, 'poker/hand/badugi'
  
  class Hand
    include Comparable
    
    RANKS = []

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
        elsif prev.index - card.index < 2 || card.index - prev.index == 12
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
      @high ||= [@value.first]
    end
    
    def kickers!
      @kickers = (@cards - @value).sort.reverse.slice(0, 5 - @value.size)
    end

    def ==(b)
      @rank == b.rank && @value == b.value && @kickers == b.kickers
    end
    
    def index
      RANKS.index(@rank.to_s)
    end

    def ==(b)
      self.index == b.index && self.value == b.value
    end

    def <=>(b)
      return self.index <=> b.index unless self.index == b.index
      
      self.high.each_with_index { |h, i|
        return h <=> b.high[i] unless h == b.high[i]
      }
      
      self.value.each_with_index { |v, i|
        return v <=> b.value[i] unless v == b.value[i]
      }
      
      self.kickers.each_with_index { |k, i|
        return k <=> b.kickers[i] unless k == b.kickers[i]
      }
      
      return 0
    end
  end
end
