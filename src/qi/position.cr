module Qi
  # Position class.
  class Position
    getter :squares, :bottomside_in_hand_pieces, :topside_in_hand_pieces

    @squares : Array(String?)
    @is_turn_to_topside : Bool
    @bottomside_in_hand_pieces : Array(String)
    @topside_in_hand_pieces : Array(String)

    def initialize(@squares, *, @is_turn_to_topside = false, @bottomside_in_hand_pieces = [] of String, @topside_in_hand_pieces = [] of String)
    end

    def call(move)
      updated_squares = squares.dup
      updated_bottomside_in_hand_pieces = bottomside_in_hand_pieces.dup
      updated_topside_in_hand_pieces = topside_in_hand_pieces.dup

      actions = move.each_slice(4).to_a

      actions.each do |action|
        src_square_id       = action[0].as(Int32?)
        dst_square_id       = action[1].as(Int32)
        moved_piece_name    = action[2].as(String)
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
        is_turn_to_topside:         !turn_to_topside?,
        bottomside_in_hand_pieces:  updated_bottomside_in_hand_pieces,
        topside_in_hand_pieces:     updated_topside_in_hand_pieces)
    end

    def turn_to_topside?
      @is_turn_to_topside
    end
  end
end
