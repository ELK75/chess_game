require_relative 'pieces.rb'

# clears the command prompt screen
class System
	def self.clear
		puts "\e[H\e[2J"
	end
end

class Chess

	
	# this class is used to save games

end

class Board < Chess

	def initialize
		@board = make_blank_board
	end

	def place_pieces(board)
		# W = White
		# B = Black
		board[7] = [Rook.new('W'), Knight.new('W'), Bishop.new('W'), 
								Queen.new('W'), King.new('W'), Bishop.new('W'), 
								Knight.new('W'), Rook.new('W')]
		board[0] = [Rook.new('B'), Knight.new('B'), Bishop.new('B'), 
								Queen.new('B'), King.new('B'), Bishop.new('B'), 
								Knight.new('B'), Rook.new('B')]
		# might cause errors were affecting one pawn will
		# affect all pawns due to pointers
		board[6] = [Pawn.new('W')] * 8
		board[1] = [Pawn.new('B')] * 8
		board
	end

	def make_blank_board
		board = []
		8.times{board << Array.new([''] * 8)}
		board = place_pieces(board)
		board
	end

	def draw_board
		@board.each_with_index do |row, row_index|
			piece_row = []

			row.each do |piece|
				next if piece == ''
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
end

board = Board.new
System.clear
board.draw_board