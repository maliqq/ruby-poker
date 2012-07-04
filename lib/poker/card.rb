# encoding: utf-8

module Poker
  class Card
    include Comparable
    attr_reader :kind, :suit
    attr_accessor :low
    
    SUITS = %w(s c h d)
    KINDS = %w(1 2 3 4 5 6 7 8 9 T J Q K A)
    
    def initialize(kind, suit)
      @kind = kind
      @suit = suit
    end
    
    class << self
      def parse(str)
        str.scan(/([akqjt2-9]{1})([schd]{1})/i).map { |(kind, suit)| new(kind, suit) }
      end
      
      def wrap(card)
        case card
        when Numeric
          kind = KINDS[card >> 2]
          suit = SUITS[card & 3]
          new(kind, suit)
        when String
          if card.size == 2
            new(*card.split(//, 2))
          else
            parse(card)
          end
        when Card
          card
        end
      end
      
      alias :[] wrap
      
      def low(cards)
        wrap(cards).map { |card|
          card.low = true if card.kind == 'A'
          card
        }
      end
      
      def deck
        KINDS.slice(1..-1).collect { |kind|
          SUITS.collect { |suit|
            new(kind, suit)
          }
        }.flatten
      end
    end
    
    def index
      KINDS.index(low ? '1' : self.kind)
    end
    
    #CHARS =  %w(♠ ♥ ♦ ♣)
    
    def to_s
      "#{self.kind}#{self.suit}"
    end
    
    def ==(b)
      b.respond_to?(:kind) ? self.kind == b.kind : self.kind == b
    end
    
    def ===(b)
      b.is_a?(Card) && self == b && self.suit == b.suit
    end
    
    def <=> (b)
      self.index <=> b.index
    end
    
    def to_i
      self.index << 2 + SUITS.index(self.suit)
    end
  end
end
