# Advent of Code 2025 — Ruby

Solve Advent of Code 2025 in Ruby. This repository is a small, test‑driven playground to get familiar with Ruby while working through the daily puzzles.

## Project layout
- `bin/` — command‑line entry points for each day
  - `bin/day01.rb` — runs Day 1 (parts 1 and 2)
  - `bin/input.txt` — example input file (you can replace it with your own)
- `lib/` — implementation code
  - `lib/day01.rb` — Day 1 solution and helpers
- `test/` — Minitest tests
  - `test/test_day01.rb` — tests for Day 1

## Requirements
- Ruby (3.x recommended)
- No external gems are required; everything uses the Ruby standard library.

## Usage
You can pipe input via STDIN or pass a file path. By default, Part 1 is executed; pass `2` to run Part 2.

### Examples
- Run Day 1 Part 1 with a file:
  ```sh
  ruby bin/day01.rb bin/input.txt
  ```
- Run Day 1 Part 1 via STDIN:
  ```sh
  ruby bin/day01.rb < bin/input.txt
  ```
- Run Day 1 Part 2 with a file:
  ```sh
  ruby bin/day01.rb 2 bin/input.txt
  ```
- Run Day 1 Part 2 via STDIN:
  ```sh
  ruby bin/day01.rb 2 < bin/input.txt
  ```

The script prints the numeric answer to stdout.

## Input format (Day 1)
Each line contains a direction and an integer distance, for example:
```text
L68
R7
L30
```

The Day 1 solution in `lib/day01.rb` simulates a 100‑position dial starting at position 50:
- Part 1: apply each move and count how many times you land exactly on `0` after a move.
- Part 2: count how many times you pass through `0` during each move (including multiple times on large steps).

## Running tests
This repo uses Minitest. You can run the tests for Day 1 with:
```sh
ruby test/test_day01.rb
```

Or run all tests (as the project grows):
```sh
ruby -Ilib -Itest -e 'Dir["test/**/*_test.rb","test/**/test_*.rb","test/test_*.rb"].each { |f| require File.expand_path(f) }'
```

## Adding new days
- Create an entry script at `bin/dayXX.rb`.
- Implement the solution in `lib/dayXX.rb` exposing `AOC2025::DayXX.solve_part1` and `solve_part2`.
- Add tests in `test/test_dayXX.rb` using Minitest and `StringIO` for input where helpful.

## Notes
- The load path is set in the bin scripts so they can `require` files from `lib/` directly.
- All code currently freezes string literals (`# frozen_string_literal: true`).

Happy hacking and good luck with AoC 2025!