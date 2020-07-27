module Qi
  # Position class.
  class Position
    # The list of squares of on the board.
    #
    # @!attribute [r] squares
    #   @return [Array] The list of squares.
    getter :squares

    # The list of pieces in hand owned by the bottomside player.
    #
    # @!attribute [r] bottomside_in_hand_pieces
    #   @return [Array] The list of bottomside's pieces in hand.
    getter :bottomside_in_hand_pieces

    # The list of pieces in hand owned by the topside player.
    #
    # @!attribute [r] topside_in_hand_pieces
    #   @return [Array] The list of topside's pieces in hand.
    getter :topside_in_hand_pieces

    @squares : Array(String?)
    @is_turn_to_topside : Bool
    @bottomside_in_hand_pieces : Array(String)
    @topside_in_hand_pieces : Array(String)

    # Initialize a position.
    #
    # @param squares [Array] The list of squares of on the board.
    # @param is_turn_to_topside [Boolean] The player who must play.
    # @param bottomside_in_hand_pieces [Array] The list of bottom-side's pieces in hand.
    # @param topside_in_hand_pieces [Array] The list of top-side's pieces in hand.
    #
    # @example Chess's starting position
    #   Position.new([
    #     "♜", "♞", "♝", "♛", "♚", "♝", "♞", "♜",
    #     "♟", "♟", "♟", "♟", "♟", "♟", "♟", "♟",
    #     null, null, null, null, null, null, null, null,
    #     null, null, null, null, null, null, null, null,
    #     null, null, null, null, null, null, null, null,
    #     null, null, null, null, null, null, null, null,
    #     "♙", "♙", "♙", "♙", "♙", "♙", "♙", "♙",
    #     "♖", "♘", "♗", "♕", "♔", "♗", "♘", "♖"
    #   ])
    #
    # @example Shogi's starting position
    #   Position.new([
    #     "l", "n", "s", "g", "k", "g", "s", "n", "l",
    #     nil, "r", nil, nil, nil, nil, nil, "b", nil,
    #     "p", "p", "p", "p", "p", "p", "p", "p", "p",
    #     nil, nil, nil, nil, nil, nil, nil, nil, nil,
    #     nil, nil, nil, nil, nil, nil, nil, nil, nil,
    #     nil, nil, nil, nil, nil, nil, nil, nil, nil,
    #     "P", "P", "P", "P", "P", "P", "P", "P", "P",
    #     nil, "B", nil, nil, nil, nil, nil, "R", nil,
    #     "L", "N", "S", "G", "K", "G", "S", "N", "L"
    #   ])
    #
    # @example Xiangqi's starting position
    #   Position.new([
    #     "車", "馬", "象", "士", "將", "士", "象", "馬", "車",
    #     nil, nil, nil, nil, nil, nil, nil, nil, nil,
    #     nil, "砲", nil, nil, nil, nil, nil, "砲", nil,
    #     "卒", nil, "卒", nil, "卒", nil, "卒", nil, "卒",
    #     nil, nil, nil, nil, nil, nil, nil, nil, nil,
    #     nil, nil, nil, nil, nil, nil, nil, nil, nil,
    #     "兵", nil, "兵", nil, "兵", nil, "兵", nil, "兵",
    #     nil, "炮", nil, nil, nil, nil, nil, "炮", nil,
    #     nil, nil, nil, nil, nil, nil, nil, nil, nil,
    #     "俥", "傌", "相", "仕", "帥", "仕", "相", "傌", "俥"
    #   ])
    def initialize(@squares, *, @is_turn_to_topside = false, @bottomside_in_hand_pieces = [] of String, @topside_in_hand_pieces = [] of String)
    end

    # Apply a move in PMN (Portable Move Notation) format.
    #
    # @param move [Array] The move to play.
    # @see https://developer.sashite.com/specs/portable-move-notation
    # @return [Position] The new position.
    def call(move)
      updated_squares = squares.dup
      updated_bottomside_in_hand_pieces = bottomside_in_hand_pieces.dup
      updated_topside_in_hand_pieces = topside_in_hand_pieces.dup

      actions = move.each_slice(4).to_a

      actions.each do |action|
        src_square_id = action[0].as(Int32?)
        dst_square_id = action[1].as(Int32)
        moved_piece_name = action[2].as(String)
        captured_piece_name = action.fetch(3, nil).as(String?)

        if src_square_id.nil?
          if turn_to_topside?
            piece_in_hand_id = updated_topside_in_hand_pieces.index(moved_piece_name)
            updated_topside_in_hand_pieces.delete_at(piece_in_hand_id) unless piece_in_hand_id.nil?
          else
            piece_in_hand_id = updated_bottomside_in_hand_pieces.index(moved_piece_name)
            updated_bottomside_in_hand_pieces.delete_at(piece_in_hand_id) unless piece_in_hand_id.nil?
          end
        else
          updated_squares[src_square_id] = nil
        end

        updated_squares[dst_square_id] = moved_piece_name

        unless captured_piece_name.nil?
          if turn_to_topside?
            updated_topside_in_hand_pieces.push(captured_piece_name)
          else
            updated_bottomside_in_hand_pieces.push(captured_piece_name)
          end
        end
      end

      self.class.new(updated_squares,
        is_turn_to_topside: !turn_to_topside?,
        bottomside_in_hand_pieces: updated_bottomside_in_hand_pieces,
        topside_in_hand_pieces: updated_topside_in_hand_pieces)
    end

    # The list of pieces in hand owned by the current player.
    #
    # @return [Array] Topside's pieces in hand if turn to topside, bottomside's
    #   ones otherwise.
    def in_hand_pieces
      turn_to_topside? ? topside_in_hand_pieces : bottomside_in_hand_pieces
    end

    # The side who must play.
    #
    # @return [Boolean] True if it is turn to topside, false otherwise.
    def turn_to_topside?
      @is_turn_to_topside
    end
  end
end
