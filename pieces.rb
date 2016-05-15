class Piece

	def initialize(color)
		@color = color
	end

	def print_piece
		piece = self.class.name
		if @color == 'W'
			pieces = Hash["Pawn" => "\u2659", "Rook" => "\u2656",
									  "Knight" => "\u2658", "Bishop" => "\u2657",
									  "King" => "\u2654", "Queen" => "\u2655"]
		elsif @color == 'B'
			pieces = Hash["Pawn" => "\u265F", "Rook" => "\u265C",
										"Knight" => "\u265E", "Bishop" => "\u265D",
										"King" => "\u265A", "Queen" => "\u265B"]
		end
		return pieces[piece]
	end

end

class Pawn < Piece

end

class Rook < Piece

end

class Knight < Piece

end

class Bishop < Piece

end

class Queen < Piece

end

class King < Piece

end