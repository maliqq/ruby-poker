module Poker
  module Low
    class Hand < ::Poker::Hand
      def <=>(b)
        return 1 unless b.rank == :low
        return b.value.reverse <=> self.value.reverse unless self.value == b.value

        return 0
      end

      def ==(b)
        self.value == b.value
      end
    end

    class High < ::Poker::High::Hand
      def <=>(b)
        result = super(b)
        result == -1 ? 1 : (result == 1 ? -1 : 0)
      end
    end

    class << self
      def ace_five(cards)
        hand = ::Poker::Low::Hand.new(Card.low(cards))
        hand.rank = :low
        hand.value = hand.kinds.values.map(&:first).sort.slice(0, 5)
        #if hand.value.size < 5
        #  paired = (hand.cards - hand.value).sort
        #  while hand.value.size < 5
        #    hand.value << paired.shift
        #  end 
        #end
        hand.high = [hand.value.max] if hand.value.size == 5
        hand
      end

      def deuce_seven(str)
        cards = Card[str]
        raise ArgumentError.new('only 5 cards allowed for 2-7') unless cards.size == 5
        hand = ::Poker::High.detect_high(::Poker::Low::High.new(cards))
        if hand.rank == :high_card
          hand = ::Poker::Low::Hand.new(cards)
          hand.rank = :low
          hand.value = hand.kinds.values.map(&:first).sort.slice(0, 5)
          hand.high = [hand.value.max] if hand.value.size == 5
        end
        hand
      end
    end
  end
end
