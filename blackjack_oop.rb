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

	def includeA?
		@countA
	end
end

class Dealer

	attr_accessor :cardarray, :status

	def initialize
		@cardarray = CardArray.new
		@status = "none"
		# @cards.push(card1,card2)
	end

	def set_close_card(card)
		@closeCard = card
		@cardarray.push(card)
	end

	def add_card(card)
		@cardarray.push(card)
	end
	
	def get_all_cards
		@cardarray.get
	end
end

class Player < Dealer

	attr_accessor :name
	
	def turn
		
	end
end


class Deck
	attr_accessor :dealer

	@@number = 0

	def initialize
		# @round = n
		@@number += 1
		@players = []
		@dealer = Dealer.new
		@cardmanager = CardsManager.new(1)
	end

	def add_player(name)
		player = Player.new
		player.name = name
		# binding.pry
		@players.push(player)
	end

	def get_first_two_cards
		#先發暗牌
		@players.each do |p|
			p.closeCard = @cardmanager.take_card
		end
		@dealer.closeCard = @cardmanager.take_card
		#再發明牌
		@players.each do |p|
			p.add_card(@cardmanager.take_card)
		end
		@dealer.add_card(@cardmanager.take_card)
	end

	def status?
		
	end

	def round
		# "Round " + @@round.to_s
	end
end


#how many cards
#set Deck
deck1 = Deck.new
deck1.add_player("Giselle")
deck1.add_player("David")
deck1.get_first_two_cards
puts deck1.round?

deck1.dealer.get_all_cards.each do |c|
	puts c.to_s
end
#how many Player?
#start? round 1
