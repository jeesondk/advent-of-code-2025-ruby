# frozen_string_literal: true
require "stringio"

module AOC2025
  module Day02

    def self.parse_ranges(line)
      s = line.strip
      raise ParseError, "empty input" if s.empty?

      s.split(",").map do |chunk|
        chunk = chunk.strip
        m = chunk.match(/\A(\d+)-(\d+)\z/)
        raise ParseError, "bad range: #{chunk.inspect}" unless m
        lo = Integer(m[1], 10)
        hi = Integer(m[2], 10)
        raise ParseError, "lo>hi: #{chunk.inspect}" if lo > hi
        [lo, hi]
      end
    end

    def self.invalid_part1?(n)
      s = n.to_s
      return false unless s.length.even?
      half = s.length / 2
      s[0, half] == s[half, half]
    end

    def self.solve_part1(input)
      if input.respond_to?(:each_line)
        input.each_line
      else
        input.each
      end

      sum = 0
      lines.each do |line|
        parse_ranges(line) do |lo, hi|
          (lo..hi).each { |n| sum +=n if invalid_part1?(n) }
        end
      end
      sum
    end

  end
end