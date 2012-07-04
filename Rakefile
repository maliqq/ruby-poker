require 'bundler'

Bundler::GemHelper.install_tasks

require "rspec/core/rake_task" 

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rspec_opts = ['--color']
end

task default: :spec

task :badugi do
  $:.unshift(File.dirname(__FILE__) + '/lib')
  require 'poker'
  
  include Poker
  
  hands = Card.deck.combination(4).map { |cards|
        Hand::Badugi[cards]
      }.sort
  hands.each { |h|
    puts "#{h.cards} | #{h.value.inspect}"
  }
end
