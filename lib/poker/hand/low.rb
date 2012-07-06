module Poker
  class Hand::Low < ::Poker::Hand::High
    RANKS = %w(low one_pair two_pair three_kind straight flush full_house four_kind straight_flush)
  
    def compare_rank_index(index)
      index <=> self.rank_index
    end

    def compare_high_cards(high)
      high <=> self.high_cards
    end

    def compare_value_cards(value)
      value <=> self.value_cards
    end

    def ==(b)
      b.is_a?(Hand) && self.value_cards == b.value_cards
    end

    def high_cards
      @high ||= []
    end

    class << self
      def row_low?(hand)
        hand.value = hand.kinds.values.map(&:first).sort.slice(0, 5)
        
        if hand.value.size == 5
          hand.rank = :low
          hand.high = [hand.value.max]
        end
        
        hand
      end
      
      def ace_five?(cards)
        row_low? new(Card[cards], low: true)
      end
      
      def ace_five8?(cards)
        row_low? new(Card[cards], qualifier: '8', low: true)
      end
      
      def ace_five9?(cards)
        row_low? new(Card[cards], qualifier: '9', low: true)
      end
      
      def deuce_six?(cards)
        row_low? new(Card[cards])
      end

      def gap_low?(hand)
        if hand.rank == :high_card
          hand = new(hand.cards)
          hand.rank = :low
          hand.value = hand.kinds.values.map(&:first).sort.slice(0, 5)
          hand.high = [hand.value.max] if hand.value.size == 5
        end
        hand
      end
      
      def deuce_seven?(cards)
        gap_low? ::Poker::Hand::High.detect(new(Card[cards]))
      end
      
      def ace_six?(cards)
        gap_low? ::Poker::Hand::High.detect(new(Card[cards], low: true))
      end
    end
  end
end
