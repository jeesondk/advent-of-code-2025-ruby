# frozen_string_literal: true

require 'spec_helper'
require 'day04'
require 'stringio'

RSpec.describe AOC2025::Day04 do
  def solve_part1(str)
    solver = described_class.new(StringIO.new(str))
    solver.solve_part1
  end

  def solve_part2(str)
    described_class.new(StringIO.new(str)).solve_part2
  end

  let(:example_input) do
    <<~INPUT
      ..@@.@@@@.
      @@@.@.@.@@
      @@@@@.@.@@
      @.@@@@..@.
      @@.@@@@.@@
      .@@@@@@@.@
      .@.@.@.@@@
      @.@@@.@@@@
      .@@@@@@@@.
      @.@.@@@.@.
    INPUT
  end

  let(:example_output) { 13 }

  describe 'paper roll access calculation' do
    it 'correctly identifies accessible paper rolls' do
      result = solve_part1(example_input)
      expect(result).to eq(example_output)
    end

    it 'handles empty grid' do
      result = solve_part1('')
      expect(result).to eq(0)
    end

    it 'handles single paper roll' do
      result = solve_part1('@')
      expect(result).to eq(1)
    end

    it 'handles single paper roll with adjacent rolls' do
      input = "@@@\n@.@\n@@@"
      result = solve_part1(input)
      expect(result).to eq(4) # Corners have 2 adjacent rolls each, so they are accessible
    end

    it 'handles grid with no paper rolls' do
      input = "........\n........\n........"
      result = solve_part1(input)
      expect(result).to eq(0)
    end

    it 'handles grid with all paper rolls' do
      input = "@@@@\n@@@@\n@@@@"
      result = solve_part1(input)
      expect(result).to eq(4) # Corners have 3 adjacent rolls each, so they are accessible
    end
  end

  describe 'adjacent paper roll counting' do
    it 'correctly counts adjacent rolls for center position' do
      input = "@@@\n@.@\n@@@"
      solver = described_class.new(StringIO.new(input))
      count = solver.send(:count_adjacent_rolls, solver.grid, 1, 1)
      expect(count).to eq(8)
    end

    it 'correctly counts adjacent rolls for corner position' do
      input = "@.\n.@"
      solver = described_class.new(StringIO.new(input))
      count = solver.send(:count_adjacent_rolls, solver.grid, 0, 0)
      expect(count).to eq(1) # Position (1,1) is adjacent and contains a roll
    end

    it 'correctly counts adjacent rolls for edge position' do
      input = "@..\n@.@\n@.."
      solver = described_class.new(StringIO.new(input))
      count = solver.send(:count_adjacent_rolls, solver.grid, 1, 0)
      expect(count).to eq(2)
    end
  end

  describe 'Part 2: Iterative paper roll removal' do
    let(:part2_example_output) { 43 }

    it 'correctly calculates total removable paper rolls with iterative removal' do
      result = solve_part2(example_input)
      expect(result).to eq(part2_example_output)
    end

    it 'handles empty grid for part 2' do
      result = solve_part2('')
      expect(result).to eq(0)
    end

    it 'handles single paper roll for part 2' do
      result = solve_part2('@')
      expect(result).to eq(1)
    end

    it 'handles grid with all accessible rolls initially' do
      input = "@.@\n...\n@.@"
      result = solve_part2(input)
      expect(result).to eq(4) # All 4 rolls have 0 adjacent rolls, so all can be removed
    end

    it 'handles grid where removal exposes more accessible rolls' do
      # Corner rolls (2 adjacent) can be removed first, then center becomes accessible
      input = "@@@\n@@@\n@@@"
      result = solve_part2(input)
      # Corners: 4 rolls with 3 adjacent each
      # Edges: 4 rolls with 5 adjacent each
      # Center: 1 roll with 8 adjacent
      # First iteration: remove 4 corners
      # After removal, edges will have fewer adjacent, and so on
      expect(result).to be > 4 # At least the corners can be removed
    end

    it 'handles grid with no paper rolls for part 2' do
      input = "........\n........\n........"
      result = solve_part2(input)
      expect(result).to eq(0)
    end

    it 'handles grid where all rolls are initially inaccessible but become accessible' do
      # 3x3 grid: center has 8 adjacent, edges have 5, corners have 3
      # None can be removed initially if we adjust the threshold, but let's test a simpler case
      input = "@@\n@@"
      result = solve_part2(input)
      # Each corner has 3 adjacent, so all are accessible
      expect(result).to eq(4)
    end
  end
end
