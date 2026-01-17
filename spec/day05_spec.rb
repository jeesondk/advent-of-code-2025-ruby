# frozen_string_literal: true

require 'rspec'
require 'spec_helper'
require 'day05'
require 'stringio'

RSpec.describe AOC2025::Day05 do
  describe '#initialize' do
    it 'parses fresh ingredient ID ranges correctly' do
      input = "3-5\n10-14\n16-20\n12-18"
      solver = described_class.new(input)
      expect(solver.fresh_ranges).to eq([[3, 5], [10, 14], [16, 20], [12, 18]])
    end
  end

  describe '#fresh?' do
    let(:input) { "3-5\n10-14\n16-20\n12-18" }
    let(:solver) { described_class.new(input) }

    it 'returns true for fresh ingredient IDs' do
      expect(solver.fresh?(5)).to be true
      expect(solver.fresh?(17)).to be true
    end

    it 'returns false for spoiled ingredient IDs' do
      expect(solver.fresh?(1)).to be false
      expect(solver.fresh?(8)).to be false
      expect(solver.fresh?(32)).to be false
    end
  end

  describe '#solve_part1' do
    let(:input) { "3-5\n10-14\n16-20\n12-18\n\n1\n5\n8\n11\n17\n32" }
    let(:solver) { described_class.new(input) }

    it 'counts the number of fresh ingredient IDs correctly' do
      expect(solver.solve_part1).to eq(3)
    end
  end

  describe '#solve_part2' do
    context 'with the example from the requirements' do
      let(:input) { "3-5\n10-14\n16-20\n12-18" }
      let(:solver) { described_class.new(input) }

      it 'counts total unique fresh ingredient IDs across all ranges' do
        # Ranges: 3-5, 10-14, 16-20, 12-18
        # Unique IDs: 3,4,5,10,11,12,13,14,15,16,17,18,19,20 = 14
        expect(solver.solve_part2).to eq(14)
      end
    end

    context 'with a single range' do
      let(:input) { '5-10' }
      let(:solver) { described_class.new(input) }

      it 'counts IDs in the single range' do
        # Range 5-10 contains: 5,6,7,8,9,10 = 6 IDs
        expect(solver.solve_part2).to eq(6)
      end
    end

    context 'with overlapping ranges' do
      let(:input) { "1-5\n3-7\n6-10" }
      let(:solver) { described_class.new(input) }

      it 'counts each unique ID only once' do
        # Ranges: 1-5, 3-7, 6-10
        # Unique IDs: 1,2,3,4,5,6,7,8,9,10 = 10 IDs
        expect(solver.solve_part2).to eq(10)
      end
    end

    context 'with non-overlapping ranges' do
      let(:input) { "1-3\n10-12\n20-22" }
      let(:solver) { described_class.new(input) }

      it 'counts all IDs from separate ranges' do
        # Ranges: 1-3, 10-12, 20-22
        # IDs: 1,2,3,10,11,12,20,21,22 = 9 IDs
        expect(solver.solve_part2).to eq(9)
      end
    end

    context 'with a single-value range' do
      let(:input) { '5-5' }
      let(:solver) { described_class.new(input) }

      it 'counts the single value' do
        expect(solver.solve_part2).to eq(1)
      end
    end
  end
end
