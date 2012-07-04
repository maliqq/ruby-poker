module Poker
  module Low
    class Hand < ::Poker::Hand
      def <=>(b)
        self.value.each_with_index { |v, i|
          return b.value[i] <=> v unless v == b.value[i]
        }

        return 0
      end

      def ==(b)
        self.value == b.value
      end
    end

    class << self
      def ace_five(cards)
        hand = ::Poker::Low::Hand.new(Card.low(cards))
        hand.rank = :low
        hand.value = hand.kinds.values.map(&:first).sort.slice(0, 5)
        hand
      end
    end
  end
end
