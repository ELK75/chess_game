class Piece

	attr_accessor :color, :legal_moves

	def initialize(color)
		@color = color
		@legal_moves = []
	end

	# TODO
	# puts this in the board class
	def print_piece
		# returns the class name the piece was initialized
		# with. So if the piece was made with "Rook.new" piece
		# would equal Rook
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

	def is_coords_legal?(coords)
		return (is_legal?(coords[0]) && is_legal?(coords[1]))
	end

	def is_legal?(loc)
		return false if loc > 7 || loc < 0
		true
	end

	def remove_out_of_bounds
		return @legal_moves if @legal_moves.size == 1
		@legal_moves.each do |loc|
			unless is_legal?(loc.first) && is_legal?(loc.last)
				@legal_moves -= loc
			end
		end
	end

	def is_move_legal?(loc)
		return @legal_moves.include?(loc)
	end

end

class Pawn < Piece

	def get_moves_given_color(board, start_loc, color)
		change_in_row = color == 'W' ? -1 : 1
		starting_row = color == 'W' ? 6 : 1

		two_moves_up = board[start_loc[0]+(change_in_row*2)][start_loc[1]]
		if two_moves_up.nil? && start_loc[0] == starting_row
			@legal_moves << [start_loc[0]+(change_in_row*2), start_loc[1]]
		end

		position_in_front = board[start_loc[0]+change_in_row][start_loc[1]]
		@legal_moves << [start_loc[0]+change_in_row, start_loc[1]] if position_in_front.nil?
			
		first_diagonal = board[start_loc[0]+change_in_row][start_loc[1]-1]
		if !first_diagonal.nil? && first_diagonal.color != color
			@legal_moves << [start_loc[0]+change_in_row, start_loc[1]-1]
		end

		second_diagonal = board[start_loc[0]+change_in_row][start_loc[1]+1]
		if !second_diagonal.nil? && second_diagonal.color != color
			@legal_moves << [start_loc[0]+change_in_row, start_loc[1]+1]
		end
	end

	def get_legal_moves(board, start_loc)
		@legal_moves = []
		get_moves_given_color(board.board, start_loc, @color)
		remove_out_of_bounds
		@legal_moves
	end

end

class Rook < Piece

	def is_in_bounds?(loc)
		return (loc >= 0 && loc <= 7)
	end

	def add_on_one_side(board, start_loc, change_in_col)
		row = board.board[start_loc[0]]
		# + change_in_col since it has to start on the
		# left or right side of the rook to find all the
		# valid positions
		column = start_loc[1] + change_in_col
		while is_in_bounds?(column)
			# breaks when the rook hits a piece
			break if (!row[column].nil?)
			@legal_moves << [start_loc[0], column]
			column += change_in_col
		end

		# adds the last piece if the it is an opposing
		# piece
		loc = [start_loc[0], column]
		if is_in_bounds?(column) && board.is_opposing_piece?(loc)
			@legal_moves << loc
		end
	end

	def add_horizontal(board, start_loc)
		# adds on left side
		add_on_one_side(board, start_loc, -1)
		# adds on right side
		add_on_one_side(board, start_loc, 1)
	end

	def add_in_one_direction(board, start_loc, change_in_row)
		row = start_loc[0] + change_in_row
		col = start_loc[1]
		while is_in_bounds?(row)
			# breaks when the rook hits a piece
			break if (!board.board[row][col].nil?)
			@legal_moves << [row, col]
			row += change_in_row
		end

		# adds the last piece if the it is an opposing
		# piece
		loc = [row, col]
		if is_in_bounds?(row) && board.is_opposing_piece?(loc)
			@legal_moves << loc
		end
	end

	def add_verticle(board, start_loc)
		# adds all elements downward
		add_in_one_direction(board, start_loc, -1)
		# adds all elements upward
		add_in_one_direction(board, start_loc, 1)
	end

	def get_legal_moves(board, start_loc)
		add_horizontal(board, start_loc)
		add_verticle(board, start_loc)
		@legal_moves
	end

end

class Knight < Piece

	def get_legal_moves(board, start_loc)
		@legal_moves = []
		move_array = [[2, 1], [2, -1], [-2, 1], [-2, -1],
								  [1, 2], [1, -2], [-1, 2], [-1, -2]]
		move_array.each do |move|
			possible_move = [start_loc[0] + move[0], start_loc[1] + move[1]] 
			if is_coords_legal?(possible_move)
				unless board.get_piece_given_position(possible_move).nil?
					next unless board.is_opposing_piece?(possible_move)
				end
				@legal_moves << possible_move
			end
		end
		@legal_moves
	end
end

class Bishop < Piece

end

class Queen < Piece

end

class King < Piece

end