module Poker
  class Hand::High < ::Poker::Hand
    RANKS = %w(high_card one_pair two_pair three_kind straight flush full_house four_kind straight_flush)

    def <=>(b)
      return 1 unless b.rank
      return -1 unless self.rank
      compare b, [:rank_index, :high_cards, :value_cards, :kicker_cards]
    end

    def compare_kicker_cards(kickers)
      self.kicker_cards <=> kickers
    end

    def high_cards
      @high ||= [@value.first]
    end

    def ==(b)
      if super(b)
        self.kickers.each_with_index { |k, i|
          return false unless k == b.kickers[i]
        }
      else
        return false
      end
    end

    def kickers!
      @kickers = (@cards - @value).sort.reverse.slice(0, 5 - @value.size)
    end
    
    class << self
      def high?(cards)
        raise ArgumentError.new('7 or less cards allowed for high') unless cards.size <= 7
        hand = new(cards)
        detect(hand)
      end

      def [](cards)
        high?(Card[cards])
      end

      def detect(hand, ranks = [:straight_flush, :three_kind, :two_pair, :one_pair, :high_card])
        result = false
        ranks.each { |rank|
          result = send("#{rank}?", hand)
          if result
            result.rank ||= rank
            break
          end
        }
        return result
      end

      def straight_flush?(hand)
        flush = flush?(hand)
        if flush
          suited = flush.suited.select { |g| g.size >= 5 }.first
          if straight = straight?(new(suited))
            hand.tap { |h|
              h.value = straight.value
              h.high = straight.high
            }
          else
            flush.rank = :flush
            detect(hand, [:four_kind, :full_house]) || flush
          end
        else
          detect(hand, [:four_kind, :full_house, :straight])
        end
      end

      def flush?(hand)
        suited = hand.suited.select { |g| g.size >= 5 }
        return false unless suited.size == 1
        hand.tap { |h|
          h.value = suited.first.sort.reverse.slice(0, 5)
        }
      end

      def straight?(hand)
        gaps = hand.gaps.select { |g| g.size >= 5 }
        return false unless gaps.size == 1
        row = gaps.first
        hand.tap { |h|
          h.value = row.slice(0, 5)
          h.high = [row.first]
        }
      end

      def four_kind?(hand)
        quad = hand.paired(4).first
        return false unless quad
        hand.tap { |h|
          h.value = quad
          h.kickers!
        }
      end

      def three_kind?(hand)
        sets = hand.paired(3)
        return false unless sets.size == 1
        hand.tap { |h|
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
          h.value = major + minor
          h.high = [major.max, minor.max]
        }
      end

      def two_pair?(hand)
        pairs = hand.paired(2)

        return false if pairs.size < 2

        major, minor, *_ = pairs.sort_by(&:max).reverse
        hand.tap { |h|
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
          h.value = pair
          h.kickers!
        }
      end

      def high_card?(hand)
        hand.tap { |h|
          h.value = [h.cards.max]
          h.kickers!
        }
      end
    end
  end
end
