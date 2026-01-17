# frozen_string_literal: true

require 'rspec/core/rake_task'

# Default task
task default: :spec

# Run all specs with coverage
RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = 'spec/**/*_spec.rb'
  t.rspec_opts = '--format documentation'
end

# Namespace for individual day specs
namespace :spec do
  desc 'Run Day 01 specs'
  RSpec::Core::RakeTask.new(:day01) do |t|
    t.pattern = 'spec/day01_spec.rb'
    t.rspec_opts = '--format documentation'
  end

  desc 'Run Day 02 specs'
  RSpec::Core::RakeTask.new(:day02) do |t|
    t.pattern = 'spec/day02_spec.rb'
    t.rspec_opts = '--format documentation'
  end

  desc 'Run Day 03 specs'
  RSpec::Core::RakeTask.new(:day03) do |t|
    t.pattern = 'spec/day03_spec.rb'
    t.rspec_opts = '--format documentation'
  end

  desc 'Run Day 04 specs'
  RSpec::Core::RakeTask.new(:day04) do |t|
    t.pattern = 'spec/day04_spec.rb'
    t.rspec_opts = '--format documentation'
  end

  desc 'Run Day 05 specs'
  RSpec::Core::RakeTask.new(:day05) do |t|
    t.pattern = 'spec/day05_spec.rb'
    t.rspec_opts = '--format documentation'
  end
end

# Coverage task
desc 'Run all specs with coverage report'
task :coverage do
  ENV['COVERAGE'] = 'true'
  Rake::Task[:spec].invoke
end
