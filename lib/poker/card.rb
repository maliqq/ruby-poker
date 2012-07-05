# encoding: utf-8

module Poker
  def Card(card)
    Card.wrap(card)
  end

  class Card
    include Comparable
    
    attr_reader :kind, :suit
    
    ACE = 12
    SUITS = %w(s c h d)
    KINDS = %w(2 3 4 5 6 7 8 9 T J Q K A)
    
    def initialize(kind, suit)
      @kind = kind
      @suit = suit
      @low = false
    end
    
    def low!
      @low = true
      self
    end
    
    class << self
      def parse(str)
        return str if str.is_a?(Array)
        str.scan(/([akqjt2-9]{1})([schd]{1})/i).map { |(kind, suit)| new(kind, suit) }
      end
      
      def wrap(card)
        case card
        when Numeric
          kind = KINDS[card >> 2]
          suit = SUITS[card & 3]
          new(kind, suit)
        when String
          new(*card.split(//, 2))
        when Card
          card
        end
      end
      
      alias :[] parse
      
      def low(cards)
        parse(cards).map(&:low!)
      end
      
      def deck
        SUITS.collect { |suit|
          KINDS.collect { |kind|
            new(kind, suit)
          }
        }.flatten
      end
    end
    
    def index(kind = @kind)
      idx = KINDS.index(kind)
      @low ? (idx == ACE ? 0 : idx + 1) : idx
    end
    
    CHARS =  %w(♠ ♥ ♦ ♣)
    
    def to_str
      "#{self.kind}#{CHARS[SUITS.index(self.suit)]}"
    end
    
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
      b.is_a?(Card) ? self.index <=> b.index : (KINDS.include?(b) ? self.index <=> self.index(b) : 1)
    end
    
    def to_i
      self.index << 2 + SUITS.index(self.suit)
    end
  end
end
