# frozen_string_literal: true

require 'spec_helper'
require 'day02'
require 'stringio'

RSpec.describe AOC2025::Day02 do
  def solve_part1(str)
    described_class.new(StringIO.new(str)).solve_part1
  end

  def solve_part2(str)
    described_class.new(StringIO.new(str)).solve_part2
  end

  describe '#parse_ranges' do
    let(:solver) { described_class.new("11-22\n") }

    it 'parses comma-separated ranges' do
      ranges = solver.parse_ranges("11-22,95-115,998-1012\n")
      expect(ranges).to eq([[11, 22], [95, 115], [998, 1012]])
    end

    it 'ignores whitespace' do
      ranges = solver.parse_ranges("  1-2 ,  10-20  ,300-300 \n")
      expect(ranges).to eq([[1, 2], [10, 20], [300, 300]])
    end

    it 'rejects bad format' do
      expect { solver.parse_ranges("11-22,BOGUS\n") }
        .to raise_error(described_class::ParseError)
      expect { solver.parse_ranges("11--22\n") }
        .to raise_error(described_class::ParseError)
      expect { solver.parse_ranges("11-22,\n") }
        .to raise_error(described_class::ParseError)
    end
  end

  describe '#invalid_part1?' do
    let(:solver) { described_class.new("11-22\n") }

    it 'returns true for numbers with repeated halves' do
      expect(solver.invalid_part1?(55)).to be true
      expect(solver.invalid_part1?(6464)).to be true
      expect(solver.invalid_part1?(123_123)).to be true
    end

    it 'returns false for numbers without repeated halves' do
      expect(solver.invalid_part1?(54)).to be false
      expect(solver.invalid_part1?(6454)).to be false
      expect(solver.invalid_part1?(123_124)).to be false
    end

    it 'requires even number of digits' do
      expect(solver.invalid_part1?(5)).to be false
      expect(solver.invalid_part1?(123)).to be false
      expect(solver.invalid_part1?(12_312)).to be false
    end

    it 'handles multi-digit repeated halves' do
      expect(solver.invalid_part1?(10_10)).to be true
      expect(solver.invalid_part1?(999_999)).to be true
      expect(solver.invalid_part1?(12_121_212)).to be true
    end

    it 'handles numbers without leading zeros' do
      expect(solver.invalid_part1?(101)).to be false
      expect(solver.invalid_part1?(10_10)).to be true
    end
  end

  describe '#solve_part1' do
    it 'returns correct sum for example input' do
      input = <<~TXT
        11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124
      TXT
      expect(solve_part1(input)).to eq(1_227_775_554)
    end

    it 'counts only invalid IDs in small range' do
      expect(solve_part1("11-22\n")).to eq(11 + 22)
    end

    it 'handles single point ranges' do
      expect(solve_part1("7-7\n")).to eq(0)
      expect(solve_part1("88-88\n")).to eq(88)
    end

    it 'handles multiple lines' do
      expect(solve_part1("11-22\n95-115\n")).to eq((11 + 22) + 99)
    end
  end

  describe '#invalid_part2?' do
    let(:solver) { described_class.new("11-22\n") }

    it 'returns true for sequences repeated at least twice' do
      expect(solver.invalid_part2?(12_341_234)).to be true
      expect(solver.invalid_part2?(123_123_123)).to be true
      expect(solver.invalid_part2?(1_212_121_212)).to be true
      expect(solver.invalid_part2?(1_111_111)).to be true
    end

    it 'returns true for single digit repeated' do
      expect(solver.invalid_part2?(11)).to be true
      expect(solver.invalid_part2?(22)).to be true
      expect(solver.invalid_part2?(99)).to be true
      expect(solver.invalid_part2?(111)).to be true
      expect(solver.invalid_part2?(222_222)).to be true
      expect(solver.invalid_part2?(999)).to be true
    end

    it 'returns true for two digit sequences repeated' do
      expect(solver.invalid_part2?(1010)).to be true
      expect(solver.invalid_part2?(565_656)).to be true
      expect(solver.invalid_part2?(824_824_824)).to be true
      expect(solver.invalid_part2?(2_121_212_121)).to be true
    end

    it 'returns true for specific examples from problem' do
      expect(solver.invalid_part2?(1_188_511_885)).to be true
      expect(solver.invalid_part2?(446_446)).to be true
      expect(solver.invalid_part2?(38_593_859)).to be true
    end

    it 'returns false for numbers without repeated patterns' do
      expect(solver.invalid_part2?(12)).to be false
      expect(solver.invalid_part2?(123)).to be false
      expect(solver.invalid_part2?(1234)).to be false
      expect(solver.invalid_part2?(1_698_522)).to be false
      expect(solver.invalid_part2?(1_698_528)).to be false
    end
  end

  describe '#solve_part2' do
    it 'correctly counts invalid IDs for single ranges' do
      expect(solve_part2("11-22\n")).to eq(11 + 22)
      expect(solve_part2("95-115\n")).to eq(99 + 111)
      expect(solve_part2("998-1012\n")).to eq(999 + 1010)
      expect(solve_part2("1188511880-1188511890\n")).to eq(1_188_511_885)
      expect(solve_part2("222220-222224\n")).to eq(222_222)
      expect(solve_part2("1698522-1698528\n")).to eq(0)
      expect(solve_part2("446443-446449\n")).to eq(446_446)
      expect(solve_part2("38593856-38593862\n")).to eq(38_593_859)
      expect(solve_part2("565653-565659\n")).to eq(565_656)
      expect(solve_part2("824824821-824824827\n")).to eq(824_824_824)
      expect(solve_part2("2121212118-2121212124\n")).to eq(2_121_212_121)
    end

    it 'correctly sums all invalid IDs from the full example' do
      input = <<~TXT
        11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124
      TXT
      expect(solve_part2(input)).to eq(4_174_379_265)
    end
  end
end
