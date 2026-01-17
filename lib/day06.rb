# frozen_string_literal: true

require 'stringio'

# Advent Of Code 2025 - Day 6:
#
# Usage:
#   ruby day06.rb < day06_input.txt (part 1)
#   ruby day06.rb day06_input.txt (part 1)
#   ruby day06.rb 2 < day06_input.txt (part 2)
#   ruby day06.rb 2 day06_input.txt (part 2)

module AOC2025
  # Solution for Day 6: Trash Compactor Math Worksheet
  #
  # This class parses and solves a cephalopod math worksheet where problems
  # are arranged in vertical columns separated by spaces.
  #
  # Part 1: Calculate the grand total of all problem answers
  #
  # @example Input format
  #   123 328  51 64
  #   45 64  387 23
  #   6 98  215 314
  #   *   +   *   +
  #
  # @example Usage
  #   Day06.new(File.read("input.txt")).solve_part1  # => grand total
  class Day06
    ParseError = Class.new(StandardError)

    attr_reader :problems

    # Initialize the solver with input data
    #
    # @param input [String, IO] the puzzle input as a string or IO object
    # @raise [ParseError] if the input is invalid
    def initialize(input)
      @input = input.is_a?(String) ? StringIO.new(input) : input
      @problems = []

      parse_input
    end

    # Solve a single problem by applying the operator to all numbers
    #
    # @param problem [Hash] with :numbers (Array<Integer>) and :operator (String)
    # @return [Integer] the result of the operation
    def solve_problem(problem)
      numbers = problem[:numbers]
      operator = problem[:operator]

      case operator
      when '*'
        numbers.reduce(1, :*)
      when '+'
        numbers.reduce(0, :+)
      else
        raise ParseError, "Unknown operator: #{operator}"
      end
    end

    # Solve part 1: Calculate grand total of all problem answers
    #
    # @return [Integer] the sum of all problem answers
    def solve_part1
      problems.sum { |problem| solve_problem(problem) }
    end

    private

    # Parse the worksheet input into problems
    #
    # Problems are arranged vertically in columns, separated by blank columns.
    # The last row contains operators (* or +).
    #
    # @raise [ParseError] if the input is invalid
    def parse_input
      lines = @input.each_line.map(&:chomp)
      return if lines.empty?

      # Pad all lines to same length
      max_length = lines.map(&:length).max
      grid = lines.map { |line| line.ljust(max_length) }

      # Find column ranges for each problem (separated by all-space columns)
      column_ranges = find_problem_columns(grid, max_length)

      # Parse each problem
      column_ranges.each do |start_col, end_col|
        parse_problem_from_columns(grid, start_col, end_col)
      end
    end

    # Find the column ranges for each problem
    #
    # @param grid [Array<String>] the padded input lines
    # @param max_length [Integer] maximum line length
    # @return [Array<Array<Integer>>] array of [start_col, end_col] pairs
    def find_problem_columns(grid, max_length)
      ranges = []
      start_col = nil

      (0...max_length).each do |col|
        column_empty = grid.all? { |line| line[col] == ' ' }

        if column_empty
          ranges << [start_col, col - 1] if start_col
          start_col = nil
        elsif start_col.nil?
          start_col = col
        end
      end

      ranges << [start_col, max_length - 1] if start_col

      ranges
    end

    # Parse a problem from a range of columns
    #
    # @param grid [Array<String>] the input grid
    # @param start_col [Integer] starting column index
    # @param end_col [Integer] ending column index
    def parse_problem_from_columns(grid, start_col, end_col)
      # Extract the problem text from these columns
      problem_lines = grid.map { |line| line[start_col..end_col].strip }

      # Last line has the operator - find the first non-space character
      operator_line = problem_lines.last
      operator = operator_line.chars.find { |c| c != ' ' }
      raise ParseError, "Invalid operator: #{operator}" unless %w[+ *].include?(operator)

      # Extract numbers from the lines above the operator
      numbers = problem_lines[0...-1].reject(&:empty?).map(&:to_i)

      @problems << { numbers: numbers, operator: operator }
    end
  end
end
