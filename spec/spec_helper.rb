$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$:.unshift(File.dirname(__FILE__))

require 'rspec/autorun'

require 'poker'

include Poker
