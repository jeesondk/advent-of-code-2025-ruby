# frozen_string_literal: true

require "minitest/autorun"
require "stringio"

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "day01"

class TESTAOC2025Day01 < Minitest::Test
  Day01 = AOC2025::Day01
end