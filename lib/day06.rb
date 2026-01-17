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
      @lines = nil # Cache for input lines

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

    # Solve part 2: Calculate grand total reading numbers as vertical columns
    #
    # In Part 2, each character position represents a column. Reading each
    # column top-to-bottom (excluding operator row) forms one number.
    #
    # @return [Integer] the sum of all problem answers
    def solve_part2
      lines = get_input_lines
      return 0 if lines.empty?

      # Pad lines to same length
      max_length = lines.map(&:length).max
      grid = lines.map { |line| line.ljust(max_length) }

      # Find separator columns
      separator_columns = find_separator_columns(grid, max_length)

      # Build column ranges for each problem
      column_ranges = build_column_ranges(separator_columns, max_length)

      # Process each problem with Part 2 logic
      column_ranges.sum do |start_col, end_col|
        operator = extract_operator_from_range(grid, start_col, end_col)
        numbers = parse_problem_part2(grid, start_col, end_col)
        solve_problem({ numbers: numbers, operator: operator })
      end
    end

    private

    # Get input lines, using cache if available or rewinding input
    #
    # @return [Array<String>] array of input lines
    def get_input_lines
      return @lines if @lines

      @input.rewind if @input.respond_to?(:rewind)
      @lines = @input.each_line.map(&:chomp)
    end

    # Parse a problem section as vertical columns (Part 2 logic)
    #
    # @param grid [Array<String>] padded grid of input lines
    # @param start_col [Integer] starting column index
    # @param end_col [Integer] ending column index
    # @return [Array<Integer>] array of numbers parsed from columns
    def parse_problem_part2(grid, start_col, end_col)
      numbers = []
      number_rows = grid[0...-1] # Exclude operator row

      (start_col..end_col).each do |col|
        digits = number_rows.map { |row| row[col] }.reject { |char| char == ' ' }
        numbers << digits.join.to_i unless digits.empty?
      end

      numbers
    end

    # Extract operator from a problem section
    #
    # @param grid [Array<String>] padded grid of input lines
    # @param start_col [Integer] starting column index
    # @param end_col [Integer] ending column index
    # @return [String] the operator character
    def extract_operator_from_range(grid, start_col, end_col)
      operator_line = grid.last
      operator = operator_line[start_col..end_col].strip
      raise ParseError, "Invalid operator: #{operator}" unless %w[+ *].include?(operator)

      operator
    end

    # Parse the worksheet input into problems
    #
    # Problems are arranged vertically and separated by columns of all spaces.
    # Falls back to proximity-based matching if no separator columns exist.
    #
    # @raise [ParseError] if the input is invalid
    def parse_input
      lines = get_input_lines
      return if lines.empty?

      # Pad lines to same length
      max_length = lines.map(&:length).max
      grid = lines.map { |line| line.ljust(max_length) }

      # Check if there are separator columns (preferred approach)
      separator_columns = find_separator_columns(grid, max_length)

      if separator_columns.any?
        parse_with_separators(grid, separator_columns, max_length)
      else
        parse_with_proximity(lines)
      end
    end

    # Parse using separator columns (for properly formatted input)
    def parse_with_separators(grid, separators, max_length)
      column_ranges = build_column_ranges(separators, max_length)

      column_ranges.each do |start_col, end_col|
        problem_lines = grid.map { |line| line[start_col..end_col].strip }
        operator = problem_lines.last.strip
        raise ParseError, "Invalid operator: #{operator}" unless %w[+ *].include?(operator)

        numbers = problem_lines[0...-1].reject(&:empty?).map(&:to_i)
        @problems << { numbers: numbers, operator: operator }
      end
    end

    # Parse using proximity matching (for test examples without separators)
    def parse_with_proximity(lines)
      operator_line = lines.last
      number_lines = lines[0...-1]

      numbers_by_line = number_lines.map { |line| extract_numbers_with_positions(line) }
      operators = find_operator_positions(operator_line)

      operators.each do |op_pos, operator|
        numbers = collect_numbers_for_operator(numbers_by_line, op_pos)
        @problems << { numbers: numbers, operator: operator }
      end
    end

    # Extract all numbers from a line with their positions
    #
    # @param line [String] the line to parse
    # @return [Array<Hash>] array of {number: Integer, start: Integer, end: Integer}
    def extract_numbers_with_positions(line)
      numbers = []
      current_num = ''
      start_pos = nil

      line.each_char.with_index do |char, idx|
        current_num, start_pos = process_char(char, idx, current_num, start_pos, numbers)
      end

      finalize_number(current_num, start_pos, line.length, numbers)
      numbers
    end

    # Process a single character while extracting numbers
    def process_char(char, idx, current_num, start_pos, numbers)
      if char =~ /\d/
        [current_num + char, start_pos || idx]
      elsif !current_num.empty?
        numbers << { number: current_num.to_i, start: start_pos, end: idx - 1 }
        ['', nil]
      else
        [current_num, start_pos]
      end
    end

    # Finalize the last number if the line ends with a digit
    def finalize_number(current_num, start_pos, line_length, numbers)
      return if current_num.empty?

      numbers << { number: current_num.to_i, start: start_pos, end: line_length - 1 }
    end

    # Find separator columns (all spaces across all rows)
    def find_separator_columns(grid, max_length)
      separators = []
      (0...max_length).each do |col|
        separators << col if grid.all? { |line| line[col] == ' ' }
      end
      separators
    end

    # Build column ranges from separator positions
    def build_column_ranges(separators, max_length)
      ranges = []
      start_col = 0

      separators.each do |sep_col|
        ranges << [start_col, sep_col - 1] if start_col < sep_col
        start_col = sep_col + 1
      end

      ranges << [start_col, max_length - 1] if start_col < max_length
      ranges
    end

    # Find positions of operators in the operator line
    #
    # @param operator_line [String] the line containing operators
    # @return [Array<Array>] array of [column_index, operator_char] pairs
    def find_operator_positions(operator_line)
      positions = []
      operator_line.each_char.with_index do |char, index|
        positions << [index, char] if %w[+ *].include?(char)
      end
      positions
    end

    # Collect numbers for a specific operator
    #
    # Numbers belong to an operator if they're horizontally closest to it
    #
    # @param numbers_by_line [Array<Array<Hash>>] numbers from each line
    # @param op_pos [Integer] operator position
    # @return [Array<Integer>] numbers for this operator
    def collect_numbers_for_operator(numbers_by_line, op_pos)
      result = []

      numbers_by_line.each do |line_numbers|
        # Find the number closest to this operator
        closest_num = line_numbers.min_by do |num_info|
          # Calculate distance from operator to number's center
          num_center = (num_info[:start] + num_info[:end]) / 2.0
          (num_center - op_pos).abs
        end

        result << closest_num[:number] if closest_num
      end

      result
    end
  end
end
