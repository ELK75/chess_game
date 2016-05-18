require_relative 'pieces.rb'

# clears the command prompt screen
class System
	def self.clear
		puts "\e[H\e[2J"
	end
end

class Game

	def is_game_over?
		false
	end

	def save_game 
	
	end

end



# Board class



class Board < Game

	attr_accessor :board, :player_turn

	def initialize(player_turn=1)
		@player_turn = player_turn
		@board = make_blank_board
	end

	def place_pieces(board)
		# W = White piece
		# B = Black piece
		board[7] = [Rook.new('W'), Knight.new('W'), Bishop.new('W'), 
								Queen.new('W'), King.new('W'), Bishop.new('W'), 
								Knight.new('W'), Rook.new('W')]
		board[0] = [Rook.new('B'), Knight.new('B'), Bishop.new('B'), 
								Queen.new('B'), King.new('B'), Bishop.new('B'), 
								Knight.new('B'), Rook.new('B')]
		board[6].map!{|position| Pawn.new('W')}
		board[1].map!{|position| Pawn.new('B')}
		board
	end

	def make_blank_board
		board = []
		8.times{board << Array.new([nil] * 8)}
		board = place_pieces(board)
		board
	end

	def draw_board
		# for testing purposes
		# @board.each{|row| puts row.to_s}
		@board.each_with_index do |row, row_index|
			piece_row = []

			row.each do |piece|
				if piece.nil?
					piece_row << ' '
					next
				end
				piece_in_unicode = piece.print_piece
				piece_row << piece_in_unicode
			end

			# print 8 through 1 descending on the side
			# of the board
			print "#{8 - row_index}  "
			puts piece_row.join(' ')
		end
		puts "\n   " + ('a'..'h').to_a.join(' ')
		puts
	end

	def move_piece(start_loc, end_loc)
		@board[end_loc[0]][end_loc[1]] =
			@board[start_loc[0]][start_loc[1]]
		@board[start_loc[0]][start_loc[1]] = nil
	end


	def get_piece_given_position(location)
		return @board[location[0]][location[1]]
	end

	# method is used to see whether or not
	# a piece can capture another piece
	def is_opposing_piece?(location)
		piece = get_piece_given_position(location)

		if (piece.color == 'W' && @player_turn == 2)
			return true
		elsif (piece.color == 'B' && @player_turn == 1)
			return true
		else
			return false
		end
	end
end



# play_game and user input



def draw_instructions
	puts "Instructions:"
	puts "Enter the piece you would like to move using"
	puts "coordinate notation. Example: \"c5\"."
	puts "Then, enter the coordinate you would like the"
	puts "piece to move to. Example: \"e4\"."
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

def end_input_is_valid(start_loc, end_loc, board)
	end_coords = turn_input_into_coordinates(end_loc)
	piece = board.get_piece_given_position(start_loc)
	piece.get_legal_moves(board, start_loc)
	piece.is_move_legal?(end_coords)
end

def coords_to_standard_notation(move)
	return "#{('a'..'h').to_a[move[1]]}#{8-move[0]}"
end

def prints_legal_moves_given_start(board, start_loc)
	piece = board.get_piece_given_position(start_loc)
	legal_moves = piece.get_legal_moves(board, start_loc)
	puts "\nYour legal moves: "
	legal_moves.map!{|move| coords_to_standard_notation(move)}
	puts legal_moves.join(', ')
	puts "\n\n"
end

def get_user_input(board)

	start_loc, end_loc = nil, nil

	loop do
		print "Enter piece location: "
		start_loc = gets.chomp
		break if is_start_input_valid?(start_loc, board)
		puts "Input invalid"
	end

	start_loc = turn_input_into_coordinates(start_loc)
	prints_legal_moves_given_start(board, start_loc)

	loop do
		print "Enter end location:   "
		end_loc = gets.chomp
		# change so it keeps repeating if the movement
		# is legal and it does JUST check if the input
		# is standard notation
		# end_loc cannot equal start_loc since that would
		# mean the piece would not have been moved
	  break if (end_input_is_valid(start_loc, end_loc, board) && 
	  	end_loc != start_loc)
	end

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
		start_loc, end_loc = get_user_input(board)
		board.move_piece(start_loc, end_loc)
		System.clear
		draw_instructions
		board.draw_board
		board.player_turn = board.player_turn == 1 ? 2 : 1
	end
end

play_game