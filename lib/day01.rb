# frozen_string_literal: true

# Advent of Code 2025 - Day 1 (Part 1 & 2)
#
# Usage:
#   ruby day01.rb < input.txt (part 1)
#   ruby day01.rb input.txt (part 1)
#   ruby day01.rb 2 < input.txt (part 2)
#   ruby day01.rb 2 input.txt (part 2)

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
    def self.solve_part1(input)
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

    # Part 2 helper: how many times do we land on 0 during clicks from pos?
    def self.hits_during_rotation(pos, dir, n)
      return 0 if n == 0

      cycles = n / MOD
      rem = n % MOD

      # Count each full 100-click cycle that lands on 0 exactly once
      hits = cycles

      # Remainder, can land on 0 at most once if rem < 100
      dist =
        if dir == "R"
          (MOD - pos) % MOD
        else
          pos % MOD
        end

      hits += 1 if dist != 0 && dist <= rem
      hits
    end

  # Part 2: count when clicks causes the dial to point at 0
  def self.solve_part2(input)
    lines =
      if input.respond_to?(:each_line)
        input.each_line
      else
        input.each
      end

    pos = START
    hits = 0

    lines.each do |line|
      dir,n = parse_line(line)

      hits += hits_during_rotation(pos, dir, n)

      step = n % MOD
      pos += (dir == "L" ? -step : step)
      pos %= MOD
    end

    hits
    end
  end
end