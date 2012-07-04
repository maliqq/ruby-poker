module Poker
  module High
    class Hand < ::Poker::Hand
      RANKS = %w(high_card one_pair two_pair three_kind straight flush full_house four_kind straight_flush)
    
      def kickers!
        @kickers = (@cards - @value).sort.reverse.slice(0, 5 - @value.size)
      end
    end
    
    class << self
      def detect(cards)
        raise ArgumentError.new('7 or less cards allowed for high') unless cards.size <= 7
        hand = ::Poker::High::Hand.new(cards)
        detect_high(hand, [:straight_flush?, :three_kind?, :two_pair?, :one_pair?, :high_card?])
      end

      def [](cards)
        detect(Card[cards])
      end

      def detect_high(hand, ranks)
        result = false
        ranks.each { |rank|
          result = send(rank, hand)
          break if result
        }
        return result
      end

      def straight_flush?(hand)
        flush = flush?(hand)
        if flush
          if straight = straight?(Hand.new(flush.value))
            hand.tap { |h|
              h.rank = :straight_flush
              h.value = straight.value
              h.high = straight.high
            }
          else
            detect_high(hand, [:four_kind?, :full_house?]) || flush
          end
        else
          detect_high(hand, [:four_kind?, :full_house?, :straight?])
        end
      end

      def flush?(hand)
        suited = hand.suited.select { |g| g.size >= 5 }
        return false unless suited.size == 1
        hand.tap { |h|
          h.rank = :flush
          h.value = suited.first.sort.reverse
        }
      end

      def straight?(hand)
        gaps = hand.gaps.select { |g| g.size >= 5 }
        return false unless gaps.size == 1
        row = gaps.first
        hand.tap { |h|
          h.rank = :straight
          h.value = row
          h.high = [row.first]
        }
      end

      def four_kind?(hand)
        quad = hand.paired(4).first
        return false unless quad
        hand.tap { |h|
          h.rank = :four_kind
          h.value = quad
          h.kickers!
        }
      end

      def three_kind?(hand)
        sets = hand.paired(3)
        return false unless sets.size == 1
        hand.tap { |h|
          h.rank = :three_kind
          h.value = sets.first
          h.kickers!
        }
      end

      def full_house?(hand)
        sets = hand.paired(3)
        pairs = hand.paired(2)

        return false if sets.empty? || (sets.size == 1 && pairs.empty?)

        if sets.size >= 2
          major, minor, *_ = sets.sort_by(&:max).reverse
        else
          major = sets.first
          minor = pairs.sort_by(&:max).last
        end

        hand.tap { |h|
          h.rank = :full_house
          h.value = major + minor
          h.high = [major.max, minor.max]
        }
      end

      def two_pair?(hand)
        pairs = hand.paired(2)

        return false if pairs.size < 2

        major, minor, *_ = pairs.sort_by(&:max).reverse
        hand.tap { |h|
          h.rank = :two_pair
          h.value = major + minor
          h.high = [major.max, minor.max]
          h.kickers!
        }
      end

      def one_pair?(hand)
        pairs = hand.paired(2)

        return false unless pairs.size == 1

        pair = pairs.first
        hand.tap { |h|
          h.rank = :one_pair
          h.value = pair
          h.kickers!
        }
      end

      def high_card?(hand)
        hand.tap { |h|
          h.rank = :high_card
          h.value = [h.cards.max]
          h.kickers!
        }
      end
    end
  end
end
