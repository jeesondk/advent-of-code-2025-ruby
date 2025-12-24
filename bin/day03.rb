#!/usr/bin/env ruby
# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path('../lib', __dir__))
require 'day03'

path = ARGV[0] == '2' ? 2: 1
path = path == 2 ? ARGV[1]: ARGV[0]
input = path ? File.open(path, 'r'): $stdin

solver = AOC2025::Day03.new(input)

solution_method = path == 2 ? :solve_part2 : :solve_part1
puts solver.public_send(solution_method)

