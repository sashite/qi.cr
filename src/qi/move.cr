require "./action"

module Qi
  # The Move abstraction.
  class Move
    @actions : Array(Tuple(Int32?, Int32, String, String?))

    # Initialize a move instance.
    #
    # @param move [Array] The move to apply.
    #
    # @example Initialize a promoted bishop move from 43 to 13
    #   new([43, 13, "+B"])
    #
    # @see https://developer.sashite.com/specs/portable-move-notation
    def initialize(move : Array(String | Int32 | Nil))
      @actions = move.each_slice(4).to_a.map do |action_params|
        action_params += [nil] if action_params.size == 3
        Tuple(Int32?, Int32, String, String?).from(action_params)
      end
    end

    # Apply a move to the piece set of a position.
    #
    # @param in_hand [Array] The list of pieces in hand.
    # @param square [Hash] The index of each piece on the board.
    #
    # @example Apply a move to a classic Shogi problem
    #   call(
    #     [43, 13, "+B"],
    #     in_hand: %w[S r r b g g g g s n n n n p p p p p p p p p p p p p p p p p],
    #     square: {
    #        3 => "s",
    #        4 => "k",
    #        5 => "s",
    #       22 => "+P",
    #       43 => "+B"
    #     }
    #   )
    #   # => {:in_hand=>["S", "r", "r", "b", "g", "g", "g", "g", "s", "n", "n", "n", "n", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p"], :square=>{3=>"s", 4=>"k", 5=>"s", 22=>"+P", 13=>"+B"}}
    #
    # @return [Hash] The piece set of the next position.
    def call(*, in_hand : Array(String), square : Hash(Int32, String))
      @actions.reduce({in_hand: in_hand, square: square}) do |last_piece_set, attrs|
        Action.new(*attrs).call(**last_piece_set)
      end
    end
  end
end
