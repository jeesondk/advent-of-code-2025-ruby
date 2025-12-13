# frozen_string_literal: true

# Advent of Code 2025 - Day 1 (Part 1)
# Count how many times the dial points at 0 after a rotation
#
# Usage:
#   ruby day01.rb < input.txt
#   ruby day01.rb input.txt

module AOC2025
  module Day01

    MOD=100
    START=50

    ParseError = Class.new(StandardError)

    # Parse one instruction line eg. "L55" or "R7"
    # Returns [dir, n]
    def self.parse_line(line)
      s = line.strip
      raise ParseError, "empty line" if s.empty?

      dir = s[0]
      raise ParseError, "invalid direction: #{dir.inspect}" unless dir == "L" || dir == "R"

      num_str = s[1..]
      raise ParseError, "missing distance" if num_str.nil? || num_str.strip.empty?

      n = Integer(num_str, 10)
      raise ParseError, "negative distance" if n < 0

      [dir, n]
    rescue ArgumentError
      raise ParseError, "invalid distance: #{num_str.inspect}"
    end

    # Solve Part 1. Accepts:
    # - an IO (responds to #each_line) or
    # - an array of strings (lines)
    def self.solve(input)
      lines =
        if input.respond_to?(:each_line)
          input.each_line
        else
          input.each
        end

      pos = START
      hits = 0

      lines.each do |line|
        dir, n = parse_line(line)
        step = n % MOD
        pos += (dir == "L" ? -step : step)
        pos %= MOD
        hits += 1 if pos == 0
      end

      hits
    end
  end
end