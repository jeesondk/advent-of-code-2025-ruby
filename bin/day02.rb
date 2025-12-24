#!/usr/bin/env ruby
# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path('../lib', __dir__))
require 'day02'

part = ARGV[0] == '2' ? 2 : 1
path = part == 2 ? ARGV[1] : ARGV[0]
input = path ? File.open(path, 'r') : $stdin

solver = AOC2025::Day02.new(input)

solution_method = part == 2 ? :solve_part2 : :solve_part1
puts solver.public_send(solution_method)
