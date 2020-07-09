require "./spec_helper"
require "json"

describe Qi::Position do
  squares = [
    "l", "n", "s", "g", "k", "g", "s", "n", "l",
    nil, "r", nil, nil, nil, nil, nil, "b", nil,
    "p", "p", "p", "p", "p", "p", "p", "p", "p",
    nil, nil, nil, nil, nil, nil, nil, nil, nil,
    nil, nil, nil, nil, nil, nil, nil, nil, nil,
    nil, nil, nil, nil, nil, nil, nil, nil, nil,
    "P", "P", "P", "P", "P", "P", "P", "P", "P",
    nil, "B", nil, nil, nil, nil, nil, "R", nil,
    "L", "N", "S", "G", "K", "G", "S", "N", "L",
  ]

  starting_position =
    Qi::Position.new(squares)

  moves = [
    [56, 47, "P"],
    [3, 11, "g"],
    [64, 24, "+B", "P"],
    [5, 14, "g"],
    [24, 14, "+B", "G"],
    [4, 3, "k"],
    [nil, 13, "G"],
  ]

  last_position =
    moves.reduce(starting_position) do |position, move|
      position.call(move)
    end

  describe "#to_s" do
    it "describes the last position" do
      last_position.topside_in_hand_pieces.should eq([] of String)

      last_position.squares.should eq(["l", "n", "s", "k", nil, nil, "s", "n", "l",
                                       nil, "r", "g", nil, "G", "+B", nil, "b", nil,
                                       "p", "p", "p", "p", "p", "p", nil, "p", "p",
                                       nil, nil, nil, nil, nil, nil, nil, nil, nil,
                                       nil, nil, nil, nil, nil, nil, nil, nil, nil,
                                       nil, nil, "P", nil, nil, nil, nil, nil, nil,
                                       "P", "P", nil, "P", "P", "P", "P", "P", "P",
                                       nil, nil, nil, nil, nil, nil, nil, "R", nil,
                                       "L", "N", "S", "G", "K", "G", "S", "N", "L"])

      last_position.bottomside_in_hand_pieces.should eq(["P"] of String)
      last_position.turn_to_topside?.should be_true
    end
  end
end
