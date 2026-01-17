# frozen_string_literal: true

require 'spec_helper'
require 'day03'
require 'stringio'

RSpec.describe AOC2025::Day03 do
  def solve_part1(str)
    solver = described_class.new(StringIO.new(str))
    solver.solve_part1
  end

  describe '#initialize' do
    it 'accepts input as a string' do
      expect { described_class.new("987654321\n") }.not_to raise_error
    end

    it 'accepts input as an IO object' do
      expect { described_class.new(StringIO.new("987654321\n")) }.not_to raise_error
    end
  end

  describe '#parse_lines' do
    let(:input) { StringIO.new("123\n4567\n890") }

    it 'parses lines correctly' do
      solver = described_class.new(input)
      expect(solver.battery_banks).to eq([[1, 2, 3], [4, 5, 6, 7], [8, 9, 0]])
    end

    it 'handles empty lines' do
      input = StringIO.new("123\n\n456\n")
      solver = described_class.new(input)
      expect(solver.battery_banks).to eq([[1, 2, 3], [4, 5, 6]])
    end

    it 'raises an error for invalid integer' do
      input = StringIO.new("abc\n")
      expect { described_class.new(input) }
        .to raise_error(described_class::ParseError, /invalid digit/)
    end
  end

  describe '#solve_part1' do
    let(:example_input) { "987654321111111\n811111111111119\n234234234234278\n818181911112111\n" }

    it 'returns the correct sum for example input' do
      # 98 + 89 + 78 + 92 = 357
      expect(solve_part1(example_input)).to eq(357)
    end

    it 'finds largest two-digit number from first two batteries' do
      # 987654321111111 => 98
      expect(solve_part1("987654321111111\n")).to eq(98)
    end

    it 'finds largest two-digit number when digits are far apart' do
      # 811111111111119 => 89 (8 at start, 9 at end)
      expect(solve_part1("811111111111119\n")).to eq(89)
    end

    it 'finds largest two-digit number from last two batteries' do
      # 234234234234278 => 78
      expect(solve_part1("234234234234278\n")).to eq(78)
    end

    it 'finds largest two-digit number with non-adjacent digits' do
      # 818181911112111 => 92 (9 followed by 2)
      expect(solve_part1("818181911112111\n")).to eq(92)
    end

    it 'handles multiple lines' do
      input = StringIO.new("123456789\n987654321\n")
      solver = described_class.new(input)
      # 123456789 => 89, 987654321 => 98
      expect(solver.solve_part1).to eq(89 + 98)
    end

    it 'handles empty input' do
      expect(solve_part1('')).to eq(0)
    end

    it 'ignores whitespace' do
      expect(solve_part1("  987654321111111 \n\n   811111111111119  ")).to eq(98 + 89)
    end

    it 'rejects invalid input' do
      input = StringIO.new("abc\n")
      expect { described_class.new(input).solve_part1 }
        .to raise_error(described_class::ParseError, /invalid digit/)
    end
  end

  describe '#solve_part2' do
    def solve_part2(str)
      described_class.new(StringIO.new(str)).solve_part2
    end

    let(:example_input) { "987654321111111\n811111111111119\n234234234234278\n818181911112111\n" }

    it 'returns the correct sum for example input' do
      # 987654321111 + 811111111119 + 434234234278 + 888911112111 = 3121910778619
      expect(solve_part2(example_input)).to eq(3_121_910_778_619)
    end

    it 'selects 12 digits keeping largest possible number from first bank' do
      # 987654321111111 => 987654321111 (drop three 1s at end)
      expect(solve_part2("987654321111111\n")).to eq(987_654_321_111)
    end

    it 'selects 12 digits keeping largest possible number from second bank' do
      # 811111111111119 => 811111111119 (keep 8, eleven 1s, and 9)
      expect(solve_part2("811111111111119\n")).to eq(811_111_111_119)
    end

    it 'selects 12 digits keeping largest possible number from third bank' do
      # 234234234234278 => 434234234278 (skip 2, 3, 2 near start)
      expect(solve_part2("234234234234278\n")).to eq(434_234_234_278)
    end

    it 'selects 12 digits keeping largest possible number from fourth bank' do
      # 818181911112111 => 888911112111 (skip some 1s near front)
      expect(solve_part2("818181911112111\n")).to eq(888_911_112_111)
    end

    it 'handles bank with exactly 12 digits' do
      expect(solve_part2("123456789012\n")).to eq(123_456_789_012)
    end

    it 'handles multiple banks' do
      input = "987654321111111\n811111111111119\n"
      expect(solve_part2(input)).to eq(987_654_321_111 + 811_111_111_119)
    end
  end
end
