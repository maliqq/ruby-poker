module Poker
  class Hand
    autoload :High, 'poker/hand/high'
    autoload :Badugi, 'poker/hand/badugi'
    autoload :Low, 'poker/hand/low'
    
    include Comparable
    
    attr_reader :cards, :kinds, :suits
    attr_accessor :rank, :high, :value, :kickers

    def initialize(cards, options = {})
      raise ArgumentError.new('no cards') unless cards.present?
      cards = cards.map { |card|
          card.low = true; card
        } if options[:low]
      @cards = options[:qualifier] ? cards.select { |card|
          card <= options[:qualifier]
        } : cards
      @kinds = @suits = nil
      @kickers = []
      @high = @value = @rank = nil
    end
    
    def kinds
      @kinds ||= @cards.group_by(&:kind)
    end
    
    def paired(n = nil)
      kinds.values.select { |g| n ? g.size == n : g.size > 1 }
    end
    
    def suits
      @suits ||= @cards.group_by(&:suit)
    end
    
    def suited(n = nil)
      suits.values.select { |g| n ? g.size == n : g.size > 1 }
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
    
    def rank_index
      self.class.const_get(:RANKS).index(@rank.to_s)
    end

    def high_cards
      @high ||= []
    end
    alias :value_cards value
    alias :kicker_cards kickers

    def ==(b)
      self.rank == b.rank && self.value == b.value
    end

    def compare(b, methods)
      methods.each { |meth|
        return send("compare_#{meth}", b.send(meth)) unless self.send(meth) == b.send(meth)
      }
      return 0
    end

    def compare_rank_index(index)
      self.rank_index <=> index
    end

    def compare_high_cards(high)
      self.high_cards <=> high
    end

    def compare_value_cards(value)
      self.value_cards <=> value
    end
    
    def inspect
      "<#{@rank}:#{@cards.inspect} high=#{high.inspect} value=#{@value.inspect} kickers=#{@kickers.inspect}>"
    end
  end
end
