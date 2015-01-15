#encoding: utf-8
require 'pry'
require 'pp'

class ShoppingCart
	def initialize
		# Items will be a Hash containing each item name as a key, and the quantity we have as a value
		@items = {}
		# We are assuming seasons as: 1 - Winter / 2 - Spring / 3 - Summer / 4 - Autumn
		@season = Date.today.season
	end

	def add(item_name)
		@items[item_name] ||= 0
		@items[item_name] += 1
	end

	def cost
		total_cost = 0
		@items.each do |actual_item, quantity|
			total_cost += Pricer.check_price(actual_item, @season) * DiscountGrouper.check_group_discount(actual_item, quantity)
		end
		
		# Now start banana's party
		if (@items.include? "grape") && (@items["grape"] >= 4)
			(@items["grape"]/4).to_i.times do |x|
				@items["banana"] ||= 0
				@items["banana"] += 1
			end
		end
		total_cost
	end

	def show_cart
		pp @items
	end
end

# We are adding a new method to class Date
class Date
	def season
		day_hash = month * 100 + mday
		case day_hash
		when 101..401 then 1
		when 402..630 then 2
		when 701..930 then 3
		when 1001..1231 then 4
		end
	end
end

# Buy 2 apples and pay just one!
# Buy 3 oranges and pay just 2!
# Buy 4 grapes you get one banana for free if you want!
class DiscountGrouper
	def self.check_group_discount(item, quantity)
		case item
		when "apple"
			quantity > 1 ? (return (quantity / 2)) : (return quantity)
		when "orange"
			quantity > 3 ? (return (quantity / 3)) : (return quantity)
		else
			return quantity
		end
	end
end

class Pricer
	def self.check_price(item_type, season)
		case item_type
		when "apple"
			return Apple.get_price(season)
		when "orange"
			return Orange.get_price(season)
		when "grape"
			return Grape.get_price(season)
		when "banana"
			return Banana.get_price(season)
		when "watermelon"
			return Watermelon.get_price(season)
		else
			return 0
		end
	end
end

#            Spring(2) Summer(3) Autumn(4) Winter(1)
# apples          10$       10$       15$      12$
# oranges          5$        2$        5$       5$
# grapes          15$       15$       15$      15$
# banana          20$       20$       20$      21$

# apples     10$
class Apple
	def self.get_price(season)
		case season
		when 1 then 12
		when 2, 3 then 10
		else
			15
		end
	end
end

# oranges     5$
class Orange
	def self.get_price(season)
		case season
		when 3
			2
		else
			5
		end
	end
end

# grapes     15$
class Grape
	def self.get_price(season)
		15
	end
end

# banana     20$
class Banana
	def self.get_price(season)
		case season
		when 1
			21
		else
			20
		end
	end
end

# watermelon 50$
class Watermelon
	def self.get_price(season)
		50
	end
end

cart = ShoppingCart.new()

cart.add("apple")
cart.add("apple")
cart.add("apple")

cart.add("grape")
cart.add("grape")
cart.add("grape")
cart.add("grape")
cart.add("grape")
cart.add("grape")
cart.add("grape")
cart.add("grape")

cart.add("orange")

puts cart.cost
cart.show_cart