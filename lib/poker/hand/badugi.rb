module Poker
  class Hand::Badugi < ::Poker::Hand
    RANKS = %w(one_card two_card three_card four_card)

    def <=>(b)
      return self.index <=> b.index unless self.index == b.index
      
      return b.high <=> self.high unless self.high == b.high
      
      return b.value.reverse <=> self.value.reverse unless self.value == b.value

      return 0
    end

    def high
      @high ||= [@value.max]
    end
    
    class << self
      def badugi?(cards)
        raise ArgumentError.new('exactly 4 cards allowed for badugi') unless cards.size == 4
        
        hand = ::Poker::Hand::Badugi.new(cards, low: true)
        
        detect(hand, [:one?, :four?, :three?, :two?])
      end

      def [](cards)
        badugi?(Card[cards])
      end

      def detect(hand, ranks)
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
        if pairs.size == 1 && flush.size != 2
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
