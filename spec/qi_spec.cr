require "./spec_helper"
require "json"

describe Qi do
  describe ".call" do
    context "with a very short Shogi game" do
      in_hand = %w()

      square = {
         0 => "l",
         1 => "n",
         2 => "s",
         3 => "g",
         4 => "k",
         5 => "g",
         6 => "s",
         7 => "n",
         8 => "l",
        10 => "r",
        16 => "b",
        18 => "p",
        19 => "p",
        20 => "p",
        21 => "p",
        22 => "p",
        23 => "p",
        24 => "p",
        25 => "p",
        26 => "p",
        54 => "P",
        55 => "P",
        56 => "P",
        57 => "P",
        58 => "P",
        59 => "P",
        60 => "P",
        61 => "P",
        62 => "P",
        64 => "B",
        70 => "R",
        72 => "L",
        73 => "N",
        74 => "S",
        75 => "G",
        76 => "K",
        77 => "G",
        78 => "S",
        79 => "N",
        80 => "L",
      }

      starting_position_piece_set = {in_hand: in_hand, square: square}

      moves = [
        [56, 47, "P"], [3, 11, "g", nil],
        [64, 24, "+B", "P"], [5, 14, "g", nil],
        [24, 14, "+B", "G"], [4, 3, "k", nil],
        [nil, 13, "G", nil],
      ]

      last_piece_set =
        moves.reduce(starting_position_piece_set) do |piece_set, move|
          Qi.call(move, **piece_set)
        end

      it "describes the last piece set" do
        last_piece_set.should eq({
          in_hand: %w(P),
          square:  {0 => "l", 1 => "n", 2 => "s", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P", 11 => "g", 14 => "+B", 3 => "k", 13 => "G"},
        })
      end
    end

    context "with a classic Shogi problem" do
      in_hand = %w(S r r b g g g g s n n n n p p p p p p p p p p p p p p p p p)

      square = {
         3 => "s",
         4 => "k",
         5 => "s",
        22 => "+P",
        43 => "+B",
      }

      starting_position_piece_set = {in_hand: in_hand, square: square}

      moves = [
        [43, 13, "+B", nil], [5, 13, "s", "b"],
        [nil, 14, "S", nil],
      ]

      last_piece_set =
        moves.reduce(starting_position_piece_set) do |piece_set, move|
          Qi.call(move, **piece_set)
        end

      it "describes the last piece set" do
        last_piece_set.should eq({
          in_hand: %w(r r b g g g g s n n n n p p p p p p p p p p p p p p p p p b),
          square:  {3 => "s", 4 => "k", 22 => "+P", 13 => "s", 14 => "S"},
        })
      end
    end
  end
end
