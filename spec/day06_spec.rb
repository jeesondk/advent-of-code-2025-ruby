# frozen_string_literal: true

require 'rspec'
require 'spec_helper'
require 'day06'
require 'stringio'

RSpec.describe AOC2025::Day06 do
  describe '#initialize' do
    it 'parses the worksheet example correctly' do
      input = <<~INPUT
        123 328  51 64
        45 64  387 23
        6 98  215 314
        *   +   *   +
      INPUT

      solver = described_class.new(input)
      expect(solver.problems).to eq([
        { numbers: [123, 45, 6], operator: '*' },
        { numbers: [328, 64, 98], operator: '+' },
        { numbers: [51, 387, 215], operator: '*' },
        { numbers: [64, 23, 314], operator: '+' }
      ])
    end
  end

  describe '#solve_problem' do
    let(:input) { "1\n*" }
    let(:solver) { described_class.new(input) }

    it 'multiplies numbers with * operator' do
      expect(solver.solve_problem({ numbers: [123, 45, 6], operator: '*' })).to eq(33_210)
    end

    it 'adds numbers with + operator' do
      expect(solver.solve_problem({ numbers: [328, 64, 98], operator: '+' })).to eq(490)
    end

    it 'handles single number' do
      expect(solver.solve_problem({ numbers: [42], operator: '+' })).to eq(42)
    end
  end

  describe '#solve_part1' do
    context 'with the example from requirements' do
      let(:input) do
        <<~INPUT
          123 328  51 64
          45 64  387 23
          6 98  215 314
          *   +   *   +
        INPUT
      end
      let(:solver) { described_class.new(input) }

      it 'returns the grand total of all problem answers' do
        # 123*45*6=33210, 328+64+98=490, 51*387*215=4243455, 64+23+314=401
        # Grand total: 33210 + 490 + 4243455 + 401 = 4277556
        expect(solver.solve_part1).to eq(4_277_556)
      end
    end

    context 'with a simple case' do
      let(:input) do
        <<~INPUT
          10 20
          5  10
          +  *
        INPUT
      end
      let(:solver) { described_class.new(input) }

      it 'calculates the grand total correctly' do
        # 10+5=15, 20*10=200
        # Grand total: 15 + 200 = 215
        expect(solver.solve_part1).to eq(215)
      end
    end

    context 'with single column' do
      let(:input) do
        <<~INPUT
          5
          10
          15
          +
        INPUT
      end
      let(:solver) { described_class.new(input) }

      it 'handles a single problem' do
        # 5+10+15=30
        expect(solver.solve_part1).to eq(30)
      end
    end
  end
end
