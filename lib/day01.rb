# frozen_string_literal: true

# Advent of Code 2025 - Day 1 (Part 1)
# Count how many times the dial points at 0 after a rotation
#
# Usage:
#   ruby day01.rb < input.txt
#   ruby day01.rb input.txt

def lines_from_argv_or_string
  if ARGV[0]
    File.readlines(ARGV[0], chomp: true)
  else
    STDIN.read.lines.map(&:strip)
  end
end

pos = 50
hits = 0

lines_from_argv_or_string.each do |line|
  next if line.empty?
  dir = line[0]
  n = Integer(line[1..], 10)

  step = n % 100
  pos += (dir == "L" ? -step : step)

  pos %= 100

  hits += 1 if pos == 0
end

puts hits