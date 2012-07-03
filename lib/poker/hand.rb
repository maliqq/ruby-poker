class Hand
  attr_reader :cards, :kinds, :suits
  attr_accessor :rank, :high, :value, :kickers

  def initialize(cards)
    @cards = cards
    @kinds = @cards.group_by(&:kind)
    @suits = @cards.group_by(&:suit)
  end

  def repeats(n)
    @kinds.select { |g| g.size == n }
  end

  def gaps
    @cards.sort.group_by { |a, b| (a.index - b.index).abs == 1 }
  end

  def kick(n)
    (@cards - @value).sort.slice(0, n)
  end

  def ==(b)
  end

  def <=>(b)
  end

  module High
    def detect(cards)
      hand = Hand.new(cards)
      detect_high(hand, [:straight_flush?, :three_kind?, :two_pair?, :one_pair?, :high_card?])
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
      suited = hand.suits.select { |g| g.size >= 5 }
      return false unless suited.size == 1
      hand.tap { |h|
        h.rank = :flush
        h.value = suited.sort.slice(0, 5)
        h.high = suited.max
      }
    end

    def straight?
      gaps = hand.gaps.select { |g| g.size >= 5 }
      return false unless gaps.size == 1
      row = gaps.first
      hand.tap { |h|
        h.rank = :straight
        h.value = row.sort.slice(0, 5)
        h.high = row.max
      }
    end

    def four_kind?
      quads = hand.repeats(4)
      return false unless quads.size == 1
      hand.tap { |h|
        h.rank = :four_kind
        h.value = quads.first
        h.kickers = h.kick(1)
      }
    end

    def three_kind?
      sets = hand.repeats(3)
      return false unless sets.size == 1
      hand.tap { |h|
        h.rank = :three_kind
        h.value = sets.first
        h.kickers = h.kick(2)
      }
    end

    def full_house?(hand)
      sets = hand.repeats(3)
      pairs = hand.repeats(2)

      return false if sets.empty? || (sets.size == 1 && pairs.empty?)

      if sets.size >= 2
        major, minor, *_ = sets.sort_by { |a, b| a.max <=> b.max }
      else
        major = sets.first
        minor = pairs.sort_by { |a, b| a.max <=> b.max }
      end

      hand.tap { |h|
        h.rank = :full_house
        h.value = major + minor
        h.high = [major.max, minor.max]
      }
    end

    def two_pair?(hand)
      pairs = hand.repeats(2)

      return false unless pairs.size < 2

      major, minor, *_ = pairs.sort_by { |a, b| a.max <=> b.max }
      hand.tap { |h|
        h.rank = :two_pair
        h.value = major + minor
        h.high = [major.max, minor.max]
        h.kickers = h.kick(1)
      }
    end

    def one_pair?(hand)
      pairs = hand.repeats(2)

      return false unless pairs.size == 1

      pair = pairs.first
      hand.tap { |h|
        h.rank = :one_pair
        h.value = pair
        h.kickers = h.kick(3)
      }
    end

    def high_card?(hand)
      hand.tap { |h|
        h.rank = :high_card
        h.value = h.cards.max
        h.kickers = h.kick(4)
      }
    end
  end

  module Badugi
    def detect(cards)
      hand = Hand.new(cards)
      detect_badugi(hand, [:four?, :three?, :two?, :one?])
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
