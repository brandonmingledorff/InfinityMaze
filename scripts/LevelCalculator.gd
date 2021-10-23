extends Node

# 1 in gift_odds chance for a maze to have a gift
var gift_odds = 3

# Gift has coins_chance% chance of having coins inside
# Chances are relative to each other
var coins_chance = 10
var color_chance = 20
var sprite_chance = 70
var apg = 15

# Area per coin
var min_apc = 35
var max_apc = 15

# Area per enemy
# Range of number of tiles per enemy spawn. 
var min_ape = 100
var max_ape = 40
var max_num_enemies = 5

#Area per collectable bomb
var min_apb = 50
var max_apb = 25
var max_num_bombs = 4

# LOOK INTO using randfn() for this stuff

func get_stages_at_level(level : int):
	return 3
	
func get_size_at_stage(stage : int, level : int):
	return (stage + 3) + (randi() % 2)
	
func get_coin_value_at_level(level : int):
	pass
	
# api = area per item (area in tiles)
func get_num_items(width : int, height : int, min_api : int, max_api : int, max_num_items : int):
	randomize()
	var area = width * height
	
	var max_items : int = area / min_api
	var min_items : int = area / max_api
	var num_items = (min_items + (randi() % (max_items + 1 - min_items)))
	
	if num_items > max_num_items: num_items = max_num_items
	
	return num_items

func get_num_gifts(width : int, height : int):
	randomize()
	var num_gifts = 0
	var max_num_gifts = (width * height) / apg
	
	for i in max_num_gifts:
		if randi() % gift_odds == 0:
			num_gifts += 1
		
	return num_gifts

# May change to return a dictionary instead of array
func select_prize(level : int):
	randomize()
	var unlock_weight
	var total_weight
	var total_chance = coins_chance + color_chance + sprite_chance
	var coins = 100
	
	var random = randi() % total_chance
	print("random: " + str(random))
	
	if random < coins_chance:
		return ["coins", coins]
	elif random < (coins_chance + color_chance): # Select a color as a prize
		unlock_weight = randi() % global.unlock_weight
		total_weight = 0
		
		print(str(unlock_weight))
		
		for color in global.unlockable_colors:
			total_weight += global.unlockable_colors[color][1]

			if unlock_weight < total_weight:
				var color_name = global.unlockable_colors[color][0]
				if not color in global.available_colors:
					return ["color", color, color_name]
				else:
					return ["coins", coins]
				
		return ["coins", coins]
		
	else: # Select a sprite as a prize
		unlock_weight = randi() % global.unlock_weight
		total_weight = 0
		
		print(str(unlock_weight))
		
		for sprite in global.unlockable_sprites:
			total_weight += global.unlockable_sprites[sprite][1]

			if unlock_weight < total_weight:
				var sprite_name = global.unlockable_sprites[sprite][0]
				if not sprite in global.available_player_sprites:
					return ["sprite", sprite, sprite_name]
				else:
					return ["coins", coins]
		
		return["coins", coins]
