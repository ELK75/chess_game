require_relative 'board.rb'

# play_game and user input

def draw_instructions
	puts "Instructions:"
	puts "Enter moves like so: \"d2,d4\""
	puts "Or like so: \"d2, d4\""
	puts
end

def turn_input_into_coordinates(input)
	coords = []
	# take the second part of the input since
	# the location used by the rest of the program
	# uses row, col notation
	coords << 8-(input[1].to_i)
	# turns the letter into a coordinate
	coords << ('a'..'h').to_a.index(input[0])
	return coords
end

def is_piece_valid?(input, board)
	coords = turn_input_into_coordinates(input)
	piece = board.get_piece_given_position(coords)
	return false if piece.nil?
	# checks if player is moving their piece and not
	# the other players
	players_color = board.player_turn == 1 ? 'W' : 'B'
	return piece.color == players_color
end

def is_standard_notation?(input)
	return true if (input.size == 2 &&
		('a'..'h').to_a.include?(input[0]) &&
		(1..8).to_a.include?(input[1].to_i))
	false
end

def is_start_input_valid?(input, board)
	if (is_standard_notation?(input) && 
		is_piece_valid?(input, board))
		return true
	end
	false
end

def is_end_input_valid?(start_loc, end_loc, board)
	start_loc = turn_input_into_coordinates(start_loc)
	end_coords = turn_input_into_coordinates(end_loc)
	piece = board.get_piece_given_position(start_loc)
	piece.get_legal_moves(board, start_loc)
	piece.is_move_legal?(end_coords)
end

def is_input_valid?(start_loc, end_loc, board)
	return false if start_loc.nil? || end_loc.nil?
	return false if start_loc == end_loc
	return (is_start_input_valid?(start_loc, board) &&
		is_end_input_valid?(start_loc, end_loc, board))
end

def prints_legal_moves_given_start(game, board, start_loc)
	piece = board.get_piece_given_position(start_loc)
	legal_moves = piece.get_legal_moves(board, start_loc)
	puts "\nYour legal moves: "
	legal_moves.map!{|move| game.coords_to_standard_notation(move)}
	puts legal_moves.join(', ')
	puts "\n\n"
end

def get_user_input(game, board)

	start_loc, end_loc = nil, nil

	loop do
		print "Enter move: "
		move = gets.chomp.delete(' ').split(',')
		start_loc = move[0]
		end_loc = move[1]
		break if is_input_valid?(start_loc, end_loc, board)
		puts "Input invalid"
	end

	start_loc = turn_input_into_coordinates(start_loc)
	end_loc = turn_input_into_coordinates(end_loc)

	puts
	return start_loc, end_loc

end

def play_game
	game = Game.new
	board = Board.new
	System.clear
	draw_instructions
	board.draw_board
	while (!game.is_game_over?)
		puts "Player #{board.player_turn}'s turn"
		start_loc, end_loc = get_user_input(game, board)
		board.move_piece(start_loc, end_loc)
		System.clear
		game.is_in_check?(board)
		draw_instructions
		board.draw_board
		board.player_turn = board.player_turn == 1 ? 2 : 1
	end
end

play_game