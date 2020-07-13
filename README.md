# 棋.cr

[![Build Status](https://travis-ci.org/sashite/qi.cr.svg?branch=master)](https://travis-ci.org/sashite/qi.cr)

> Instantiate [Portable Chess Notation](https://developer.sashite.com/specs/portable-chess-notation)'s positions and apply [Portable Move Notation](https://developer.sashite.com/specs/portable-move-notation)'s moves.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     qi:
       github: sashite/qi.cr
   ```

2. Run `shards install`

## Usage

Let's replay [The Shortest Possible Game of Shogi](https://userpages.monmouth.com/~colonel/shortshogi.html):

```crystal
require "qi"

starting_position = Qi::Position.new([
  "l", "n", "s", "g", "k", "g", "s", "n", "l",
  nil, "r", nil, nil, nil, nil, nil, "b", nil,
  "p", "p", "p", "p", "p", "p", "p", "p", "p",
  nil, nil, nil, nil, nil, nil, nil, nil, nil,
  nil, nil, nil, nil, nil, nil, nil, nil, nil,
  nil, nil, nil, nil, nil, nil, nil, nil, nil,
  "P", "P", "P", "P", "P", "P", "P", "P", "P",
  nil, "B", nil, nil, nil, nil, nil, "R", nil,
  "L", "N", "S", "G", "K", "G", "S", "N", "L"
])

moves = [
  [ 56, 47, "P" ],
  [ 3, 11, "g" ],
  [ 64, 24, "+B", "P" ],
  [ 5, 14, "g" ],
  [ 24, 14, "+B", "G" ],
  [ 4, 3, "k" ],
  [ nil, 13, "G" ]
]

last_position = moves.reduce(starting_position) do |position, move|
  position.call(move)
end

last_position.topside_in_hand_pieces # => []

last_position.squares # => ["l", "n", "s", "k", nil, nil, "s", "n", "l",
                      #     nil, "r", "g", nil, "G", "+B", nil, "b", nil,
                      #     "p", "p", "p", "p", "p", "p", nil, "p", "p",
                      #     nil, nil, nil, nil, nil, nil, nil, nil, nil,
                      #     nil, nil, nil, nil, nil, nil, nil, nil, nil,
                      #     nil, nil, "P", nil, nil, nil, nil, nil, nil,
                      #     "P", "P", nil, "P", "P", "P", "P", "P", "P",
                      #     nil, nil, nil, nil, nil, nil, nil, "R", nil,
                      #     "L", "N", "S", "G", "K", "G", "S", "N", "L"]

last_position.bottomside_in_hand_pieces # => ["P"]
last_position.turn_to_topside? # => true
```

## License

This library is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## About Sashite

This library is maintained by [Sashite](https://sashite.com/).

With some [lines of code](https://github.com/sashite/), let's share the beauty of Chinese, Japanese and Western cultures through the game of chess!
