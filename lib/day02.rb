# frozen_string_literal: true

require 'stringio'

module AOC2025
  # Day02 contains parsing, validation and solver logic for Advent of Code 2025 Day 02.
  #
  # Public methods:
  # - parse_ranges(line) => Array<[Integer,Integer]>: parse comma-separated "lo-hi" ranges.
  # - invalid_part1?(n) => Boolean: checks part 1 invalid condition.
  # - invalid_part2?(n) => Boolean: checks part 2 invalid condition.
  # - solve_part1 => Integer: compute sum for part 1 from input lines.
  # - solve_part2 => Integer: compute sum for part 2 from input lines.
  class Day02
    ParseError = Class.new(StandardError)

    attr_reader :lines

    def initialize(input)
      @input = input.is_a?(String) ? StringIO.new(input) : input
      @lines = parse_input
    end

    def solve_part1
      lines.sum { |ranges| sum_invalid_ids_in_ranges(ranges, :invalid_part1?) }
    end

    def solve_part2
      lines.sum { |ranges| sum_invalid_ids_in_ranges(ranges, :invalid_part2?) }
    end

    def parse_ranges(line)
      s = line.strip
      raise ParseError, 'empty input' if s.empty?

      s.split(',', -1).map { |chunk| parse_single_range(chunk) }
    end

    def invalid_part1?(num)
      s = num.to_s
      return false unless s.length.even?

      half = s.length / 2
      s[0, half] == s[half, half]
    end

    def invalid_part2?(num)
      s = num.to_s
      doubled = s + s
      doubled[1..-2].include?(s)
    end

    private

    def parse_input
      @input.each_line.map { |line| parse_ranges(line) }
    end

    def parse_single_range(chunk)
      chunk = chunk.strip
      raise ParseError, 'empty range element' if chunk.empty?

      m = chunk.match(/\A(\d+)-(\d+)\z/)
      raise ParseError, "bad range: #{chunk.inspect}" unless m

      lo = Integer(m[1], 10)
      hi = Integer(m[2], 10)
      raise ParseError, "lo>hi: #{chunk.inspect}" if lo > hi

      [lo, hi]
    end

    def sum_invalid_ids_in_ranges(ranges, check_method)
      ranges.sum { |lo, hi| (lo..hi).select { |n| send(check_method, n) }.sum }
    end
  end
end
