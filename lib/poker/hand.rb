module Poker
  class Hand
    include Comparable

    attr_reader :cards, :kinds, :suits
    attr_accessor :rank, :high, :value
    
    RANKS = %w(high_card one_pair two_pair three_kind straight flush full_house four_kind straight_flush)

    def initialize(cards)
      @cards = cards
      @kinds = @cards.group_by(&:kind)
      @suits = @cards.group_by(&:suit)
      @high = @value = @rank = @kickers = nil
    end

    def repeats(n)
      @kinds.values.select { |g| g.size == n }
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

    def kickers
      @kickers ||= (@cards - @value).sort.reverse.slice(0, 5 - @value.size)
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
      } if self.high
      
      self.kickers.each_with_index { |k, i|
        return k <=> b.kickers[i] unless k == b.kickers[i]
      } if self.value == b.value

      self.value.each_with_index { |v, i|
        return v <=> b.value[i] unless v == b.value[i]
      }
      
      return 0
    end

    module High
      class << self
        def detect(cards)
          hand = Hand.new(cards)
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
            straight = straight?(flush)
            if straight
              straight.tap { |h|
                h.rank = :straight_flush
              }
            else
              detect_high(hand, [:four_kind?, :full_house?]) || flush
            end
          else
            detect_high(hand, [:four_kind?, :full_house?, :straight?])
          end
        end

        def flush?(hand)
          suited = hand.suits.values.select { |g| g.size >= 5 }
          return false unless suited.size == 1
          hand.tap { |h|
            h.rank = :flush
            h.value = suited.sort.reverse.slice(0, 5)
          }
        end

        def straight?(hand)
          gaps = hand.gaps.select { |g| g.size >= 5 }
          return false unless gaps.size == 1
          row = gaps.first
          hand.tap { |h|
            h.rank = :straight
            h.value = row.sort.reverse.slice(0, 5)
            h.high = row.max
          }
        end

        def four_kind?(hand)
          quads = hand.repeats(4)
          return false unless quads.size == 1
          hand.tap { |h|
            h.rank = :four_kind
            h.value = quads.first
          }
        end

        def three_kind?(hand)
          sets = hand.repeats(3)
          return false unless sets.size == 1
          hand.tap { |h|
            h.rank = :three_kind
            h.value = sets.first
          }
        end

        def full_house?(hand)
          sets = hand.repeats(3)
          pairs = hand.repeats(2)

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
          pairs = hand.repeats(2)

          return false if pairs.size < 2

          major, minor, *_ = pairs.sort_by(&:max).reverse
          hand.tap { |h|
            h.rank = :two_pair
            h.value = major + minor
            h.high = [major.max, minor.max]
          }
        end

        def one_pair?(hand)
          pairs = hand.repeats(2)

          return false unless pairs.size == 1

          pair = pairs.first
          hand.tap { |h|
            h.rank = :one_pair
            h.value = pair
          }
        end

        def high_card?(hand)
          hand.tap { |h|
            h.rank = :high_card
            h.value = [h.cards.max]
          }
        end
      end
    end

    module Badugi
      def detect(cards)
        raise ArgumentError('4 cards allowed for badugi') unless cards.size == 4
        hand = Hand.new(cards)
        detect_badugi(hand, [:one?, :four?, :two?, :three?])
      end

      def four?(hand)
        return false unless hand.kinds.size == 4 || hand.suits.size == 4
        hand.tap { |h|
          h.rank = :badugi4
        } 
      end

      def three?(hand)
      end

      def two?(hand)
      end

      def one?(hand)
        return false unless hand.kinds.size == 1 || hand.suits.size == 1
        hand.tap { |h|
          h.rank = :badugi1
        }
      end

      def detect_badugi(hand, ranks)
        result = false
        ranks.each { |rank|
          result = send(rank)
          break if result
        }
        return result
      end
    end
  end
end
