# encoding: utf-8

module Poker
  def Card(card)
    Card.wrap(card)
  end

  class Card
    include Comparable
    
    attr_reader :kind, :suit
    attr_accessor :low
    
    ACE = 12
    SUITS = %w(s c h d)
    CHARS =  %w(♠ ♥ ♦ ♣)
    KINDS = %w(2 3 4 5 6 7 8 9 T J Q K A)
    
    def initialize(kind, suit, low = false)
      raise ArgumentError.new('unknown suit') unless SUITS.include?(suit)
      raise ArgumentError.new('unknown kind') unless KINDS.include?(kind)
      @kind = kind
      @suit = suit
      @low = low
    end
    
    def index(kind = @kind)
      idx = KINDS.index(kind)
      @low ? (idx == ACE ? 0 : idx + 1) : idx
    end
    
    def to_str
      "#{self.kind}#{CHARS[SUITS.index(self.suit)]}"
    end
    
    def to_s
      "#{self.kind}#{self.suit}"
    end
    
    def ==(b)
      b.is_a?(Card) ? self.kind == b.kind : self.kind == b.to_s
    end
    
    def ===(b)
      b.is_a?(Card) && self == b && self.suit == b.suit
    end
    
    def <=> (b)
      b.is_a?(Card) ? self.index <=> b.index : (KINDS.include?(b) ? self.index <=> self.index(b) : 1)
    end
    
    def to_i
      (self.index << 2) + SUITS.index(self.suit)
    end
    
    class << self
      def parse(cards)
        case cards
        when Array
          cards.map { |card| wrap(card) }
        when String
          cards.scan(/([akqjt2-9]{1})([schd]{1})/i).map { |(kind, suit)| new(kind, suit) }
        else
          raise ArgumentError.new('Card can parse string or array')
        end
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
      
      def [](*args)
        parse(
          args.size == 1 ? args.first : args
          )
      end

      def deck
        SUITS.collect { |suit|
          KINDS.collect { |kind|
            new(kind, suit)
          }
        }.flatten
      end
    end
  end
end
