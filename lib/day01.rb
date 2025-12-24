# frozen_string_literal: true

require 'stringio'

# Advent of Code 2025 - Day 1 (Part 1 & 2)
#
# Usage:
#   ruby day01.rb < day01_input.txt (part 1)
#   ruby day01.rb day01_input.txt (part 1)
#   ruby day01.rb 2 < day01_input.txt (part 2)
#   ruby day01.rb 2 day01_input.txt (part 2)

module AOC2025
  # Solution for Day 1: Rotary Dial Parser
  #
  # This class solves a problem involving a rotary dial with 100 positions (0-99).
  # The dial starts at position 50 and can be rotated left (L) or right (R) by
  # a specified number of clicks, wrapping around modulo 100.
  #
  # Part 1: Count how many times the dial lands exactly on position 0 after
  # processing each instruction line.
  #
  # Part 2: Count how many times the dial passes through position 0 during
  # the rotation process (including the start and end positions).
  #
  # @example Input format
  #   L55
  #   R23
  #   L100
  #
  # @example Usage
  #   Day01.new(File.read("input.txt")).solve_part1  # => count of times landing on 0
  #   Day01.new(File.read("input.txt")).solve_part2  # => count of times passing 0
  class Day01
    MOD = 100
    START = 50

    ParseError = Class.new(StandardError)

    attr_reader :lines

    def initialize(input)
      @input = normalize_input(input)
      @lines = parse_input
    end

    # Solve Part 1
    def solve_part1
      pos = START
      hits = 0

      lines.each do |dir, num|
        pos = update_position(pos, dir, num)
        hits += 1 if pos.zero?
      end

      hits
    end

    # Part 2: count when clicks causes the dial to point at 0
    def solve_part2
      pos = START
      hits = 0

      lines.each do |dir, num|
        hits += hits_during_rotation(pos, dir, num)
        pos = update_position(pos, dir, num)
      end

      hits
    end

    # Parse one instruction line eg. "L55" or "R7"
    # Returns [dir, n]
    def parse_line(line)
      s = line.strip
      raise ParseError, 'empty line' if s.empty?

      dir = s[0]
      raise ParseError, "invalid direction: #{dir.inspect}" unless %w[L R].include?(dir)

      num_str = s[1..]
      raise ParseError, 'missing distance' if num_str.nil? || num_str.strip.empty?

      num = validate_distance(num_str)
      [dir, num]
    rescue ArgumentError
      raise ParseError, "invalid distance: #{num_str.inspect}"
    end

    private

    def normalize_input(input)
      if input.is_a?(String)
        StringIO.new(input)
      else
        input
      end
    end

    def parse_input
      lines = @input.respond_to?(:each_line) ? @input.each_line : @input
      lines.map { |line| parse_line(line) }
    end

    def validate_distance(num_str)
      num = Integer(num_str, 10)
      raise ParseError, 'negative distance' if num.negative?

      num
    end

    def update_position(pos, dir, num)
      step = num % MOD
      pos += (dir == 'L' ? -step : step)
      pos % MOD
    end

    # Part 2 helper: how many times do we land on 0 during clicks from pos?
    def hits_during_rotation(pos, dir, num)
      return 0 if num.zero?

      cycles = num / MOD
      rem = num % MOD

      # Count each full 100-click cycle that lands on 0 exactly once
      hits = cycles

      # Remainder, can land on 0 at most once if rem < 100
      dist = calculate_distance_to_zero(pos, dir)

      hits += 1 if dist != 0 && dist <= rem
      hits
    end

    def calculate_distance_to_zero(pos, dir)
      if dir == 'R'
        (MOD - pos) % MOD
      else
        pos % MOD
      end
    end
  end
end
