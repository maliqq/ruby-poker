require 'rspec/autorun'

RSpec.configure do |c|
  c.mock_with :rspec
end

require 'poker'

include Poker
