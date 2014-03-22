require 'pry'

class Card
	attr_accessor :suit, :value

	def initialize(s,v)
		@suit = s
		@value = v
	end

	def get_point
		point = 0
		case @value
		when 'J','Q','K'
			point = 10
		when 'A'
			point = 1;			
		else
			point = value.to_i
		end
		point
	end

	def to_s
		"#{suit}_#{value}"
	end
end

class CardsManager
	# @cards = {['spade','A'],['heart','A'],['diamond','A'],['club','A'],}

	def initialize(d)
		@cards = []
		suits = ['spade','heart','diamond','club']
		values = ['A','1','2','3','4','5','6','7','8','9','10','J','Q','K']
		# cards = suits.product(values)
		suits.each do |s|
			values.each do |v|
				@cards << Card.new(s,v)
			end
		end
		@cards * d
		@cards.shuffle!
	end

	def take_card
		@cards.pop
	end
end

class CardArray

	attr_accessor :cards

	def initialize
		@cards = []
		@countA = 0
	end

	def push(card)
		@cards << card
		@countA += 1 if card.value == 'A'
	end

	def get
		@cards
	end

	def count
		sum = 0
		@cards.each do |c|
			sum += c.get_point
		end 

		count = self.includeA?
		while sum <= 11 && count > 0
			sum += 10
			count -= 1
		end

		sum
	end

	def total_to_s
		"(" + self.count.to_s + " points.)"
	end

	def includeA?
		@countA
	end

	def to_s
		@cards.join(",")
	end
end

class Dealer

	attr_accessor :cardarray, :status, :index

	@@member_count = 0

	def initialize
		@@member_count += 1
		@index = @@member_count
		@cardarray = CardArray.new
		@status = "none"
		# @cards.push(card1,card2)
	end

	# def set_close_card(card)
	# 	@closeCard = card
	# 	@cardarray.push(card)
	# end

	def add_card(card)
		@cardarray.push(card)
		message = "get card: " + card.to_s
		if @cardarray.count == 21
			@status = "win"
			message += " => BlackJack!"
			# binding.pry
		elsif @cardarray.count > 21
			@status = "lose"
			message += " => Busted!"
			# binding.pry
		else
			message
			# binding.pry
		end 
	end
	
	def get_all_cards
		@cardarray.get
	end

	def to_s
		"Dealer now has " + @cardarray.count.to_s + " points."
	end

	def status_to_s
		"Dealer #{status}"
	end

	def show_cards
		"Dealer => " + @cardarray.to_s
	end
end

class Player < Dealer
	attr_accessor :name		

	def to_s
		"Player #{name} now has " + @cardarray.count.to_s + " points."
	end

	def status_to_s
		"Player #{name} #{status}!"
	end

	def show_cards
		"Player #{name} => " + @cardarray.to_s
	end
end


class Deck
	attr_accessor :dealer, :status

	@@number = 0

	def initialize
		# @round = n
		@status = "none"
		@@number += 1
		@players = []
		@dealer = Dealer.new
		@cardmanager = CardsManager.new(1)
		# @winner = @dealer
		@high_point = 0
	end

	def add_player(name)
		player = Player.new
		player.name = name
		# binding.pry
		@players.push(player)
	end

	def get_first_two_cards
		#先發第一張
		@players.each do |p|
			p.add_card(@cardmanager.take_card)
		end
		@dealer.add_card(@cardmanager.take_card)
		#再發第二張
		@players.each do |p|
			p.add_card(@cardmanager.take_card)
		end
		@dealer.add_card(@cardmanager.take_card)
		#誰有什麼牌？
		@players.each {|p| puts p.show_cards}
		puts @dealer.show_cards
	end

	def get_players
		@players
	end

	def status?
		
	end

	def round?
		@@number.to_s
	end

	def call_win(p)
		puts p.status_to_s
	end

	def start

		@players.each do |p|

			puts p.to_s

			while true
				if p.status == "win"
					puts p.status_to_s
					@status = "end"
					return
				end

				puts "What's your move? 1)hit 2)pass"
				move = gets.chomp
				# puts
				if move == "1"
					puts p.add_card(@cardmanager.take_card) + " " + p.cardarray.total_to_s 
					case p.status
					when "win"
						# puts p.status_to_s
						@status = "end"
						return
					when "lose"
						# puts p.status_to_s
						break
					else
						next
					end
				elsif move == "2"
					puts "Player " + p.name + " pass! " + p.cardarray.total_to_s
					puts
					if p.cardarray.count > @high_point
						@high_point = p.cardarray.count 
						@winner = p
					end
					break
				else
					puts "Please enter 1 or 2 !"
				end	
				# puts ""		
			end
		end		
	end

	def dealer_turn
		if @status != "end"
			puts
			puts "Dealer's turn!"
			puts @dealer.to_s

			while @dealer.cardarray.count <= 17

				puts @dealer.add_card(@cardmanager.take_card)
				case @dealer.status
				when "win"
					puts @dealer.status_to_s						
					return
				when "lose"
					puts @dealer.status_to_s					
					break
				end				
			end
			puts @dealer.to_s
			#compare everyone's cards, find the winner in players
			self.who_win?

		end
	end

	def who_win?
		puts "===> Compare! <==="

		if @dealer.status != "lose" 
			if @dealer.cardarray.count > @high_point
				@dealer.status = "win"
				puts @dealer.status_to_s
			elsif @dealer.cardarray.count < @high_point
				@winner.status = "win"
				puts @winner.status_to_s
			else
				puts "no one win."
			end
		else
			@winner.status = "win"
			puts @winner.status_to_s
		end
	end
end

players = []

while true	
	puts "Enter S to start a new game."
	input = gets.chomp.upcase
	if input == "S"
		deck1 = Deck.new
		puts "=== Start Game " + deck1.round? + " ==="

		if players.count == 0
			puts "Player's name?(till Enter)"
			while true
				name = gets.chomp
				if name == ""
					break
				else
					deck1.add_player(name)
					players.push(name)
				end
			end
		else
			players.each {|p| deck1.add_player(p)}
		end
		puts "Total " + deck1.get_players.count.to_s + " players, game start!"
		puts

		puts "=>everyone gets two cards."
		deck1.get_first_two_cards
		puts
		# puts deck1.round?
		deck1.start
		puts 

		deck1.dealer_turn
		# deck1.who_win?

	else
		puts "=== End ==="
		break
	end
end



