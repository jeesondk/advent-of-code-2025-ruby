# frozen_string_literal: true

require 'spec_helper'
require 'day01'
require 'stringio'

RSpec.describe AOC2025::Day01 do
  def solve_part1(str)
    described_class.new(StringIO.new(str)).solve_part1
  end

  def solve_part2(str)
    described_class.new(StringIO.new(str)).solve_part2
  end

  describe '#parse_line' do
    it 'rejects empty lines' do
      expect { described_class.new("   \n") }
        .to raise_error(described_class::ParseError)
    end

    it 'rejects invalid direction' do
      expect { described_class.new('X10') }
        .to raise_error(described_class::ParseError, /invalid direction/i)
    end

    it 'rejects missing distance' do
      expect { described_class.new('L') }
        .to raise_error(described_class::ParseError, /missing distance/i)
    end

    it 'rejects non-integer distance' do
      expect { described_class.new('R12.5') }
        .to raise_error(described_class::ParseError, /invalid distance/i)
    end

    it 'rejects negative distance' do
      expect { described_class.new('L-1') }
        .to raise_error(described_class::ParseError, /negative distance/i)
    end
  end

  describe '#solve_part1' do
    let(:example_input) do
      <<~TXT
        L68
        L30
        R48
        L5
        R60
        L55
        L1
        L99
        R14
        L82
      TXT
    end

    it 'returns 3 for the example input' do
      expect(solve_part1(example_input)).to eq(3)
    end

    it 'handles wrapping left from 0 to 99' do
      # Start at 50, L50 => 0 (hit), then L1 => 99 (no hit)
      expect(solve_part1("L50\nL1\n")).to eq(1)
    end

    it 'handles wrapping right from 99 to 0' do
      # Start 50, L51 => 99, then R1 => 0 (hit)
      expect(solve_part1("L51\nR1\n")).to eq(1)
    end

    it 'treats large steps as mod 100' do
      # R150 == R50 => from 50 to 0 (hit)
      expect(solve_part1("R150\n")).to eq(1)
    end

    it 'allows zero distance and counts if already at 0' do
      # Move to 0 (hit), then R0 keeps at 0 (hit again)
      expect(solve_part1("R50\nR0\n")).to eq(2)
    end

    it 'ignores whitespace' do
      expect(solve_part1("  R150  \n")).to eq(1)
    end

    it 'supports array input' do
      expect(described_class.new(["R150\n"]).solve_part1).to eq(1)
    end
  end

  describe '#solve_part2' do
    let(:example_input) do
      <<~TXT
        L68
        L30
        R48
        L5
        R60
        L55
        L1
        L99
        R14
        L82
      TXT
    end

    it 'returns 6 for the example input' do
      expect(solve_part2(example_input)).to eq(6)
    end

    it 'counts R1000 from 50 as hitting zero 10 times' do
      # From 50, R1000 crosses 0 ten times and returns to 50
      expect(solve_part2("R1000\n")).to eq(10)
    end
  end
end
