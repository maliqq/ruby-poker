module Poker
  module Badugi
    class Hand < ::Poker::Hand
      RANKS = %w(four_card three_card two_card one_card)
    end
    
    class << self
      def detect(cards)
        raise ArgumentError.new('exactly 4 cards allowed for badugi') unless cards.size == 4
        hand = ::Poker::Badugi::Hand.new(cards)
        detect_badugi(hand, [:one?, :four?, :three?, :two?])
      end

      def [](cards)
        detect(Card.low(cards))
      end

      def detect_badugi(hand, ranks)
        result = false
        ranks.each { |rank|
          result = send(rank, hand)
          break if result
        }
        return result
      end

      def four?(hand)
        return false unless hand.kinds.size == 4 && hand.suits.size == 4
        hand.tap { |h|
          h.rank = :four_card
          h.value = hand.cards.sort
        }
      end

      def three?(hand)
        pairs = hand.paired(2)
        flush = hand.suited(2)
        a = b = c = nil
        if pairs.size == 1
          pair = pairs.first
          a = pair.first
          other = hand.cards - pair
          b, c = other.select { |card| card.kind != a.kind }
          return false if b.suit == c.suit
          a = pair.second if b.suit == a.suit || c.suit == a.suit
        elsif flush.size == 1 && pairs.empty?
          a = flush.first.min
          other = hand.cards - flush.first
          b, c = other.select { |card| card.suit != a.suit }
          return false if b.kind == c.kind
        else
          return false
        end
        hand.tap { |h|
          h.rank = :three_card
          h.value = [a, b, c].sort
        }
      end

      def two?(hand)
        a = b = nil
        if set = hand.paired(3).first
          b = (hand.cards - set).first
          a = set.select { |card| card.suit != b.suit }.first
        elsif flush = hand.suited(3).first
          a = (hand.cards - flush).first
          b = flush.select { |card| card.kind != a.kind }.min
        elsif flush = hand.suited.first
          a = flush.min
          other = hand.cards - flush
          b = other.select { |card| card.suit != a.suit && card.kind != a.kind }.min
        else
          pair = hand.paired.first
          other = hand.cards - pair
          a = pair.first
          b = other.select { |card| card.kind != a.kind }.min
        end
        hand.tap { |h|
          h.rank = :two_card
          h.value = [a, b].sort
        }
      end

      def one?(hand)
        return false unless hand.kinds.size == 1 || hand.suits.size == 1
        hand.tap { |h|
          h.rank = :one_card
          h.value = [if hand.kinds.size == 1
            hand.cards.first
          else
            hand.suited.first.min
          end]
        }
      end
    end
  end
end