# frozen_string_literal: true

require 'stringio'

# Advent Of Code 2025 - Day 4:
#
# Usage:
#   ruby day04.rb < day04_input.txt (part 1)
#   ruby day04.rb day04_input.txt (part 1)
#   ruby day04.rb 2 < day04_input.txt (part 2)
#   ruby day04.rb 2 day04_input.txt (part 2)

module AOC2025
  # Solution for Day 4: Printing Department
  #
  # This class solves a problem involving paper rolls arranged on a grid.
  # Each line of input represents a grid row where each character is either
  # a paper roll (@) or an empty space (.)
  #
  # Part 1: Determine how many paper rolls can be accessed by forklifts. A forklift
  # can access a paper roll if there are fewer than four paper rolls in the eight
  # adjacent positions (including diagonals).
  #
  # @example Input format
  #   ..@@.@@@@.
  #   @@@.@.@.@@
  #   @@@@.@.@@
  #   @.@@@@..@.
  #   @@.@@@@.@@
  #   .@@@@@@@.@
  #   .@.@.@.@@@
  #   @.@@@.@@@@
  #   .@@@@@@@@.
  #   @.@.@@@.@.
  class Day04
    ParseError = Class.new(StandardError)

    # @return [Array<Array<string>>] parse grid as array of arrays
    attr_reader :grid

    # Initialize the solver with input data
    #
    # @param input [string, IO] the puzzle input as a string or IO object
    # @raise [ParseError] if the input contains invalid characters
    def initialize(input)
      @input = input.is_a?(String) ? StringIO.new(input) : input
      @grid = parse_lines
    end

    def solve_part1
      calculate_accessible_rolls(@grid)
    end

    def solve_part2
      total_removable_rolls = 0
      loop do
        accessible_rolls = find_accessible_roll_positions(@grid)
        break if accessible_rolls.empty?

        accessible_rolls.each { |row, col| @grid[row][col] = nil }
        total_removable_rolls += accessible_rolls.size
      end
      total_removable_rolls
    end

    private

    # Find positions of accessible paper rolls
    #
    # A paper roll is accessible if it has fewer than 4 adjacent paper rolls
    # (including diagonals). This method returns the positions of such rolls.
    #
    # @param grid [Array<Array<String>>] the grid of paper rolls and empty spaces
    # @return [Array<Array<Integer>>] array of [row, col] positions
    def find_accessible_roll_positions(grid)
      return [] if grid.empty?

      grid_positions(grid).select do |row, col|
        grid[row][col] == '@' && count_adjacent_rolls(grid, row, col) < 4
      end
    end

    # Generate all grid positions
    #
    # @param grid [Array<Array<String>>] the grid
    # @return [Array<Array<Integer>>] array of [row, col] positions
    def grid_positions(grid)
      (0...grid.length).flat_map { |row| (0...grid[0].length).map { |col| [row, col] } }
    end

    # Calculate the number of accessible paper rolls
    #
    # A paper roll is accessible if it has fewer than 4 adjacent paper rolls
    # (including diagonals). This method counts such rolls in the grid.
    #
    # @param grid [Array<Array<String>>] the grid of paper rolls and empty spaces
    # @return [Integer] number of accessible paper rolls
    def calculate_accessible_rolls(grid)
      find_accessible_roll_positions(grid).size
    end

    # Count the number of adjacent paper rolls for a given position
    #
    # Checks all 8 adjacent positions (including diagonals) for paper rolls (@)
    #
    # @param grid [Array<Array<String>>] the grid of paper rolls and empty spaces
    # @param row [Integer] the row index of the current position
    # @param col [Integer] the column index of the current position
    # @return [Integer] number of adjacent paper rolls
    def count_adjacent_rolls(grid, row, col)
      adjacent_positions(row, col).count do |new_row, new_col|
        valid_position?(grid, new_row, new_col) && grid[new_row][new_col] == '@'
      end
    end

    # Generate all adjacent positions for a given cell
    #
    # @param row [Integer] the row index
    # @param col [Integer] the column index
    # @return [Array<Array<Integer>>] array of [row, col] adjacent positions
    def adjacent_positions(row, col)
      (-1..1).flat_map do |dr|
        (-1..1).map do |dc|
          next if dr.zero? && dc.zero?

          [row + dr, col + dc]
        end
      end.compact
    end

    # Check if a position is within grid bounds
    #
    # @param grid [Array<Array<String>>] the grid
    # @param row [Integer] the row index
    # @param col [Integer] the column index
    # @return [Boolean] true if position is valid
    def valid_position?(grid, row, col)
      row >= 0 && row < grid.length && col >= 0 && col < grid[0].length
    end

    # parse all lines from input into grip
    #
    # @return [Array<Array<string>>] array of rows, each containing characters
    def parse_lines
      @input.each_line.map(&:strip).reject(&:empty?).map(&:chars)
    end
  end
end
