# frozen_string_literal: true

require 'stringio'

# Advent Of Code 2025 - Day 5:
#
# Usage:
#   ruby day04.rb < day05_input.txt (part 1)
#   ruby day04.rb day05_input.txt (part 1)
#   ruby day04.rb 2 < day05_input.txt (part 2)
#   ruby day04.rb 2 day05_input.txt (part 2)

module AOC2025
  # Solution for Day 5: Cafeteria Inventory Management System
  #
  # This class processes ingredient ID ranges and determines which of the available ingredient IDs are fresh.
  #
  # Part 1: Count the number of fresh ingredient IDs from a list based on given fresh ID ranges.
  #
  # @example Input format
  #   3-5
  #   10-14
  #   16-20
  #   12-18
  #
  #   1
  #   5
  #   8
  #   11
  #   17
  #   32
  #
  # @example Usage
  #   Day05.new(File.read("input.txt")).solve_part1  # => number of fresh ingredient IDs
  class Day05
    ParseError = Class.new(StandardError)

    attr_reader :fresh_ranges

    # Initialize the solver with input data
    #
    # @param input [String, IO] the puzzle input as a string or IO object
    # @raise [ParseError] if the input contains invalid ranges or IDs
    def initialize(input)
      @input = input.is_a?(String) ? StringIO.new(input) : input
      @fresh_ranges = []
      @ingredient_ids = []

      parse_input
    end

    def fresh?(id)
      fresh_ranges.any? { |start_range, end_range| id.between?(start_range, end_range) }
    end

    # Solve part 1: Count how many available ingredient IDs are fresh
    #
    # @return [Integer] the count of fresh ingredient IDs
    def solve_part1
      @ingredient_ids.count { |id| fresh?(id) }
    end

    # Solve part 2: Count total unique ingredient IDs across all fresh ranges
    #
    # Efficiently handles large ranges by merging overlapping ranges first,
    # then calculating the total count without expanding into arrays.
    #
    # @return [Integer] the count of unique fresh ingredient IDs
    def solve_part2
      merged_ranges = merge_ranges(fresh_ranges)
      merged_ranges.sum { |start_range, end_range| end_range - start_range + 1 }
    end

    private

    # Parse all lines from input into fresh ranges and ingredient IDs
    #
    # @raise [ParseError] if any line is invalid
    # @return [Object]
    def parse_input
      reading_ranges = true

      @input.each_line do |line|
        stripped_line = line.strip
        next reading_ranges = false if stripped_line.empty?

        reading_ranges ? parse_range(stripped_line) : parse_ingredient_id(stripped_line)
      end
    end

    # Parse a range line and add it to fresh_ranges
    #
    # @param line [String] the line to parse
    # @raise [ParseError] if the line is not a valid range
    def parse_range(line)
      match_data = line.match(/^(\d+)-(\d+)$/)
      raise ParseError, "invalid input line: #{line.inspect}" unless match_data

      start_range, end_range = match_data.captures.map(&:to_i)
      fresh_ranges << [start_range, end_range]
    end

    # Parse an ingredient ID line and add it to ingredient_ids
    #
    # @param line [String] the line to parse
    # @raise [ParseError] if the line is not a valid ingredient ID
    def parse_ingredient_id(line)
      raise ParseError, "invalid input line: #{line.inspect}" unless line =~ /^\d+$/

      @ingredient_ids << line.to_i
    end

    # Merge overlapping or adjacent ranges
    #
    # @param ranges [Array<Array<Integer>>] array of [start, end] pairs
    # @return [Array<Array<Integer>>] merged non-overlapping ranges
    def merge_ranges(ranges)
      return [] if ranges.empty?

      sorted = ranges.sort_by(&:first)
      merged = [sorted.first]

      sorted[1..].each do |current_start, current_end|
        last_start, last_end = merged.last
        merge_or_append(merged, current_start, current_end, last_start, last_end)
      end

      merged
    end

    # Merge current range into last range or append as new range
    def merge_or_append(merged, current_start, current_end, last_start, last_end)
      if current_start <= last_end + 1
        merged[-1] = [last_start, [last_end, current_end].max]
      else
        merged << [current_start, current_end]
      end
    end
  end
end
