require "rspec/core/rake_task" 

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rspec_opts = ['--backtrace', '--color']
end

task default: :spec
