#!/usr/bin/env ruby
# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "day01"

part = (ARGV[0] == "2" ? 2 : 1)

input =
  if part == 2
    # if part arg is present, the filename is in ARGV[1]
    ARGV[1] ? File.open(ARGV[1], "r") : STDIN
  else
    # part 1: filename in ARGV[0]
    ARGV[0] ? File.open(ARGV[0], "r") : STDIN
  end

result =
  if part == 2
    AOC2025::Day01.solve_part2(input)
  else
    AOC2025::Day01.solve_part1(input)
  end

puts result
