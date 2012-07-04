module Poker
  class Hand
    include Comparable

    attr_reader :cards, :kinds, :suits
    attr_accessor :rank, :high, :value, :kickers
    attr_accessor :ranks
    
    def initialize(cards)
      @cards = cards
      @kinds = @cards.group_by(&:kind)
      @suits = @cards.group_by(&:suit)
      @kickers = @high = []
      @value = @rank = nil
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
    
    def value=(value)
      @value = value
      @kickers = (@cards - @value).sort.reverse.slice(0, 5 - @value.size) if @value.size < 5
    end

    def ==(b)
      @rank == b.rank && @value == b.value && @kickers == b.kickers
    end
    
    def index
      ranks.index(@rank.to_s)
    end

    def ==(b)
      self.index == b.index && self.value == b.value
    end

    def <=>(b)
      return self.index <=> b.index unless self.index == b.index
      
      self.high.each_with_index { |h, i|
        return h <=> b.high[i] unless h == b.high[i]
      }
      
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
        RANKS = %w(high_card one_pair two_pair three_kind straight flush full_house four_kind straight_flush)
        
        def detect(cards)
          raise ArgumentError.new('7 or less cards allowed for high') unless cards.size <= 7
          hand = Hand.new(cards)
          hand.ranks = RANKS
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
          suited = hand.suited.select { |g| g.size >= 5 }
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
          quad = hand.paired(4).first
          return false unless quad
          hand.tap { |h|
            h.rank = :four_kind
            h.value = quad
          }
        end

        def three_kind?(hand)
          sets = hand.paired(3)
          return false unless sets.size == 1
          hand.tap { |h|
            h.rank = :three_kind
            h.value = sets.first
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
          }
        end

        def one_pair?(hand)
          pairs = hand.paired(2)

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
      class << self
        RANKS = %w(four_card three_card two_card one_card)
        
        def detect(cards)
          raise ArgumentError.new('exactly 4 cards allowed for badugi') unless cards.size == 4
          hand = Hand.new(cards)
          hand.ranks = RANKS
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
          else
            flush = hand.suited.first
            a = flush.min
            other = hand.cards - flush
            b = other.select { |card| card.suit != a.suit && card.kind != a.kind }.first
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
end
