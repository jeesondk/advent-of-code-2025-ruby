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
end
