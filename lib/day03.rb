# frozen_string_literal: true

require 'stringio'

# Advent of Code 2025 - Day 3
#
# Usage:
#   ruby day03.rb < day03_input.txt (part 1)
#   ruby day03.rb day03_input.txt (part 1)

module AOC2025
  # Solution for Day 3: Battery Bank Joltage Calculator
  #
  # This class solves a problem involving battery banks represented as strings of digits.
  # Each line of input represents a battery bank where each character is a single digit (0-9).
  #
  # Part 1: For each battery bank, find the largest possible two-digit joltage by selecting
  # two batteries (digits) where the first selected battery appears before the second in the
  # sequence. The joltage is formed as: first_digit * 10 + second_digit.
  #
  # @example Input format
  #   987654321111111
  #   811111111111119
  #   234234234234278
  #   818181911112111
  #
  # @example Usage
  #   Day03.new(File.read("input.txt")).solve_part1  # => total output joltage
  #
  # @example Calculation
  #   "987654321111111" => largest joltage is 98 (first two batteries)
  #   "811111111111119" => largest joltage is 89 (8 at start, 9 at end)
  #   "234234234234278" => largest joltage is 78 (last two batteries)
  #   "818181911112111" => largest joltage is 92 (9 followed by 2)
  #   Total: 98 + 89 + 78 + 92 = 357
  class Day03
    # Custom error raised when input parsing fails
    ParseError = Class.new(StandardError)

    # @return [Array<Array<Integer>>] parsed battery banks as arrays of digits
    attr_reader :battery_banks

    # Initialize the solver with input data
    #
    # @param input [String, IO] the puzzle input as a string or IO object
    # @raise [ParseError] if the input contains non-digit characters
    def initialize(input)
      @input = input.is_a?(String) ? StringIO.new(input) : input
      @battery_banks = parse_lines
    end

    # Solve Part 1: Sum of maximum joltages from each battery bank
    #
    # @return [Integer] the total output joltage
    def solve_part1
      battery_banks.map { |bank| max_joltage(bank) }.sum
    end

    # Solve Part 2: Sum of maximum 12-digit joltages from each battery bank
    #
    # @return [Integer] the total output joltage
    def solve_part2
      battery_banks.map { |bank| max_joltage_n_digits(bank, 12) }.sum
    end

    private

    # Find the maximum n-digit joltage by selecting n digits in order
    #
    # Uses a greedy algorithm: for each position, pick the largest digit
    # that still leaves enough digits for remaining positions.
    #
    # @param digits [Array<Integer>] array of single digits
    # @param num_digits [Integer] number of digits to select
    # @return [Integer] maximum n-digit joltage
    def max_joltage_n_digits(digits, num_digits)
      return 0 if digits.length < num_digits

      result = []
      start_idx = 0

      num_digits.times do |i|
        max_val, max_pos = find_max_digit_in_range(digits, start_idx, num_digits, i)
        result << max_val
        start_idx = max_pos + 1
      end

      result.join.to_i
    end

    # Find the maximum digit in a valid range
    #
    # @param digits [Array<Integer>] array of single digits
    # @param start_idx [Integer] starting index
    # @param num_digits [Integer] total number of digits to select
    # @param current_pos [Integer] current position in selection
    # @return [Array<Integer>] [max_value, max_position]
    def find_max_digit_in_range(digits, start_idx, num_digits, current_pos)
      end_idx = digits.length - (num_digits - current_pos - 1) - 1
      max_val = -1
      max_pos = start_idx

      (start_idx..end_idx).each do |j|
        if digits[j] > max_val
          max_val = digits[j]
          max_pos = j
        end
      end

      [max_val, max_pos]
    end

    # Find the maximum two-digit joltage from a battery bank
    #
    # Selects two batteries where the tens digit appears before the units digit
    # in the sequence, maximizing the resulting two-digit number.
    #
    # @param digits [Array<Integer>] array of single digits
    # @return [Integer] maximum two-digit joltage or 0 if fewer than 2 digits
    def max_joltage(digits)
      return 0 if digits.length < 2

      max = 0
      # For each position, find the maximum digit that appears after it
      # and compute the two-digit number
      (0...(digits.length - 1)).each do |i|
        tens = digits[i]
        # Find the maximum units digit after position i
        max_units = digits[(i + 1)..].max
        joltage = (tens * 10) + max_units
        max = joltage if joltage > max
      end
      max
    end

    # Parse all lines from input into arrays of digits
    #
    # @return [Array<Array<Integer>>] array of digit arrays, one per non-empty line
    def parse_lines
      @input.each_line.map(&:strip).reject(&:empty?).map { |line| parse_line(line) }
    end

    # Parse a single line into an array of digits
    #
    # @param line [String] a string of digit characters
    # @return [Array<Integer>] array of single-digit integers
    # @raise [ParseError] if any character is not a digit
    def parse_line(line)
      line.chars.map do |char|
        raise ParseError, "invalid digit: #{char.inspect}" unless char =~ /\d/

        char.to_i
      end
    end
  end
end
