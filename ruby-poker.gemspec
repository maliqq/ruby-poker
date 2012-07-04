# encoding: utf-8
lib = File.expand_path("../lib/", __FILE__)
$:.unshift(lib) unless $:.include?(lib)

require 'poker/version'

Gem::Specification.new do |s|
  s.name = 'ruby-poker'
  s.version = Poker::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = ['Malik Bakhtiyar']
  s.email = ['malik@baktiyarov.com']
  s.homepage = 'https://github.com/malikbakt/ruby-poker'
  s.summary = 'cards and hands'
  s.description = 'Poker cards and hands'
  s.required_rubygems_version = ">= 1.3.6"
  s.add_dependency 'rake'
  s.add_dependency 'activesupport'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'autowatchr'
  s.require_paths = ['lib']
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- spec/*`.split("\n")
end
