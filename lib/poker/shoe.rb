module Poker
  class Shoe
    attr_reader :hands_high, :hands_low, :holes

    def initialize(cards = Card.deck.shuffle)
      @deck = cards
      @board = []
      @holes = []
      @hands_high = Poker::Rank.new
      @hands_low = Poker::Rank.new
      yield self if block_given?
    end

    def deal_cards(n)
      [].tap { |cards|
        n.times { cards << @deck.shift }
      }
    end

    def deal_board(n = 5)
      @board = deal_cards(n)
    end

    def deal_hole(n)
      @holes << deal_cards(n)
    end

    def deal(n, options = {})
      deal_board if options[:board]
      n.times { deal_hole(options[:hole]) }
      @holes.each { |hole|
        if options[:board].respond_to?(:call)
          hs = options[:board].call(hole, @board)
          @hands_high << hs.map { |h|
            options[:high_hand].send(options[:high], h)
          }.max if options[:high]
          @hands_low << hs.map { |h|
            options[:low_hand].send(options[:low], h)
          }.max if options[:low]
        else
          @hands_high << options[:high_hand].send(options[:high], hole + @board) if options[:high]
          @hands_low << options[:low_hand].send(options[:low], hole + @board) if options[:low]
        end
      }
    end
  end
end
