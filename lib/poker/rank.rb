require 'delegate'

module Poker
  class Rank < Delegator
    class << self
      def [](*hands)
        new(hands)
      end
    end

    def initialize(hands = [])
      @hands = hands
    end

    def __setobj__(hands)
      @hands = hands
    end

    def __getobj__
      @hands
    end
    
    def result(hand)
      return :lose unless hand && winners.include?(hand)
      winners.size == 1 ? :wins : :ties
    end

    def winners
      @winners ||= begin
        sorted = self.compact.sort.reverse
        sorted.take_while { |hand| hand == sorted.first }
      end
    end
  end
end
