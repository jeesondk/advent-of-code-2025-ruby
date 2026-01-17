# Advent of Code 2025 — Ruby

Solve Advent of Code 2025 in Ruby. This repository is a small, test‑driven playground to get familiar with Ruby while working through the daily puzzles.

## Project layout
- `bin/` — command‑line entry points for each day
  - `bin/day01.rb` — runs Day 1 (parts 1 and 2)
  - `bin/day02.rb` — runs Day 2 (parts 1 and 2)
  - `bin/day03.rb` — runs Day 3 (part 1)
  - `bin/dayXX_input.txt` — input files for each day
- `lib/` — implementation code
  - `lib/day01.rb` — Day 1 solution and helpers
  - `lib/day02.rb` — Day 2 solution and helpers
  - `lib/day03.rb` — Day 3 solution and helpers
  - `lib/day04.rb` — Day 4 solution and helpers
- `spec/` — RSpec tests
  - `spec/day01_spec.rb` — tests for Day 1
  - `spec/day02_spec.rb` — tests for Day 2
  - `spec/day03_spec.rb` — tests for Day 3
  - `spec/day04_spec.rb` — tests for Day 4

## Requirements
- Ruby (3.x recommended)
- Bundler for managing gems
- RSpec for testing

## Usage
You can pipe input via STDIN or pass a file path. By default, Part 1 is executed; pass `2` to run Part 2.

### Examples
- Run Day 1 Part 1 with a file:
  ```sh
  ruby bin/day01.rb bin/day01_input.txt
  ```
- Run Day 1 Part 1 via STDIN:
  ```sh
  ruby bin/day01.rb < bin/day01_input.txt
  ```
- Run Day 1 Part 2 with a file:
  ```sh
  ruby bin/day01.rb 2 bin/day01_input.txt
  ```
- Run Day 1 Part 2 via STDIN:
  ```sh
  ruby bin/day01.rb 2 < bin/day01_input.txt
  ```

The script prints the numeric answer to stdout.

## Input formats

### Day 1
Each line contains a direction and an integer distance:
```text
L68
R7
L30
```

The Day 1 solution simulates a 100‑position dial starting at position 50:
- Part 1: apply each move and count how many times you land exactly on `0` after a move.
- Part 2: count how many times you pass through `0` during each move (including multiple times on large steps).

### Day 2
Each line contains comma-separated ranges in `lo-hi` format:
```text
11-22,95-115,998-1012
```

### Day 3
Each line contains a string of digits representing a battery bank:
```text
987654321111111
811111111111119
```

The Day 3 solution finds the maximum joltage from each battery bank:
- Part 1: for each bank, find the largest two-digit number that can be formed by selecting two batteries where the first appears before the second in the sequence.

## Running tests
This repo uses RSpec. Install dependencies and run all tests with:
```sh
bundle install
bundle exec rspec
```

Run tests for a specific day:
```sh
bundle exec rspec spec/day01_spec.rb
bundle exec rspec spec/day02_spec.rb
bundle exec rspec spec/day03_spec.rb
```

## Adding new days
1. Create an entry script at `bin/dayXX.rb`.
2. Implement the solution in `lib/dayXX.rb` as a class `AOC2025::DayXX` with:
   - `initialize(input)` — accepts String, IO, or Array input
   - `solve_part1` — returns the solution for part 1
   - `solve_part2` — returns the solution for part 2 (if applicable)
3. Add tests in `spec/dayXX_spec.rb` using RSpec.

## Notes
- The load path is set in the bin scripts so they can `require` files from `lib/` directly.
- All code freezes string literals (`# frozen_string_literal: true`).
- Solutions are implemented as classes with instance methods for better state management.

Happy hacking and good luck with AoC 2025!