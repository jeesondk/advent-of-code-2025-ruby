# frozen_string_literal: true

require "minitest/autorun"
require "stringio"

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "day01"

class TESTAOC2025Day01 < Minitest::Test
  Day01 = AOC2025::Day01

  def solve_str(str)
    AOC2025::Day01.solve(StringIO.new(str))
  end

  def test_example_password_is_3
    input = <<-TXT
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

    assert_equal 3, solve_str(input)
  end

  def test_wrap_left_from_0_to_99
    # Start at 50, L50 => 0 (hit), then L1 => 99 (no hit)
    assert_equal 1, solve_str("L50\nL1\n")
  end

  def test_wrap_right_from_99_to_0
    # Start 50, L51 => 99, then R1 => 0 (hit)
    assert_equal 1, solve_str("L51\nR1\n")
  end

  def test_large_steps_are_mod_100
    # R150 == R50 => from 50 to 0 (hit)
    assert_equal 1, solve_str("R150\n")
  end

  def test_zero_distance_is_allowed_and_counts_if_already_at_0
    # Move to 0 (hit), then R0 keeps at 0 (hit again)
    assert_equal 2, solve_str("R50\nR0\n")
  end

  def test_whitespace_is_ignored
    assert_equal 1, solve_str("  R150  \n")
  end

  def test_array_input_supported
    assert_equal 1, Day01.solve(["R150\n"])
  end

  def test_parse_line_rejects_empty
    assert_raises(Day01::ParseError) { Day01.parse_line("   \n") }
  end

  def test_parse_line_rejects_bad_direction
    err = assert_raises(Day01::ParseError) { Day01.parse_line("X10") }
    assert_match(/invalid direction/i, err.message)
  end

  def test_parse_line_rejects_missing_distance
    err = assert_raises(Day01::ParseError) { Day01.parse_line("L") }
    assert_match(/missing distance/i, err.message)
  end

  def test_parse_line_rejects_non_integer_distance
    err = assert_raises(Day01::ParseError) { Day01.parse_line("R12.5") }
    assert_match(/invalid distance/i, err.message)
  end

  def test_parse_line_rejects_negative_distance
    err = assert_raises(Day01::ParseError) { Day01.parse_line("L-1") }
    assert_match(/negative distance/i, err.message)
  end
end