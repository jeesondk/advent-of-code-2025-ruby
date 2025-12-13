# frozen_string_literal: true

# frozen_string_literal: true

require "minitest/autorun"
require "stringio"

# Adjust if your file name differs
$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "day02"

class TestAOC2025Day02 < Minitest::Test
  Day02 = AOC2025::Day02

  def solve_str(str)
    Day02.solve_part1(StringIO.new(str))
  end

  def test_invalid_id_basic_examples_from_prompt
    # 55 = "5" twice, 6464 = "64" twice, 123123 = "123" twice :contentReference[oaicite:1]{index=1}
    assert Day02.invalid_id?(55)
    assert Day02.invalid_id?(6464)
    assert Day02.invalid_id?(123_123)

    refute Day02.invalid_id?(54)
    refute Day02.invalid_id?(6454)
    refute Day02.invalid_id?(123_124)
  end

  def test_invalid_id_requires_even_number_of_digits
    refute Day02.invalid_id?(5)
    refute Day02.invalid_id?(123)
    refute Day02.invalid_id?(12_312) # 5 digits
  end

  def test_invalid_id_repeated_half_can_have_multiple_digits
    assert Day02.invalid_id?(10_10)     # "10" + "10"
    assert Day02.invalid_id?(999_999)   # "999" + "999"
    assert Day02.invalid_id?(12_1212)   # "1212" + "1212"
  end

  def test_invalid_id_no_leading_zeros_means_numbers_like_101_are_valid
    # The prompt: 0101 isn't an ID; 101 is valid and should be ignored. :contentReference[oaicite:2]{index=2}
    refute Day02.invalid_id?(101)
    assert Day02.invalid_id?(10_10)
  end

  def test_parse_ranges_single_line
    ranges = Day02.parse_ranges("11-22,95-115,998-1012\n")
    assert_equal [[11, 22], [95, 115], [998, 1012]], ranges
  end

  def test_parse_ranges_ignores_whitespace
    ranges = Day02.parse_ranges("  1-2 ,  10-20  ,300-300 \n")
    assert_equal [[1, 2], [10, 20], [300, 300]], ranges
  end

  def test_parse_ranges_rejects_bad_format
    assert_raises(Day02::ParseError) { Day02.parse_ranges("11-22,BOGUS\n") }
    assert_raises(Day02::ParseError) { Day02.parse_ranges("11--22\n") }
    assert_raises(Day02::ParseError) { Day02.parse_ranges("11-22,\n") }
  end

  def test_part1_example_sum_matches_prompt
    # Example from prompt; wrapped here for legibility (input is one long line). :contentReference[oaicite:3]{index=3}
    input = <<~TXT
      11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124
    TXT

    assert_equal 1_227_775_554, solve_str(input)
  end

  def test_part1_small_range_counts_only_invalid_ids
    # 11-22 contains invalid 11 and 22 per prompt. :contentReference[oaicite:4]{index=4}
    assert_equal 11 + 22, solve_str("11-22\n")
  end

  def test_part1_single_point_range
    assert_equal 0, solve_str("7-7\n")         # 7 isn't invalid
    assert_equal 88, solve_str("88-88\n")       # 88 is invalid
  end

  def test_part1_handles_multiple_lines_by_treating_each_as_ranges
    # If your implementation supports multi-line inputs (common AoC style),
    # this verifies it sums across all lines.
    assert_equal (11 + 22) + 99, solve_str("11-22\n95-115\n")
  end
end
