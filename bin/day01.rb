#!/usr/bin/env ruby
# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path('../lib', __dir__))
require "day01"

input =
  if ARGV[0]
    File.open(ARGV[0], "r")
  else
    STDIN
  end

puts AOC2025::Day01.solve(input)