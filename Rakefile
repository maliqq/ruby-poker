require 'bundler'

Bundler::GemHelper.install_tasks

require "rspec/core/rake_task" 

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rspec_opts = ['--color']
end

require "cucumber/rake/task"

Cucumber::Rake::Task.new(:features) do |task|
  task.cucumber_opts = ["features --format pretty"]
end

task default: :spec
