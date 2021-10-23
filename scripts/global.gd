extends Node

var tile_size = 64
var player_speed = 125
var disable_movement = false
var collision_disabled = false
var inside_sf = false
var can_pause = true
var first_load = false

var stage : int = 1

var level = {
	"relaxed": 1,
	"classic": 1,
	"hardcore": 1
}

var num_stages : int = 1
var coins : int = 100
var coins_collected_in_level : int = 0
var prizes_to_select : int = 0
var num_bombs : int = 0
var lives : int = 3
var gamemode : String = "classic"

var shop_colors = {
	Color(0.2, 0.3, 0.4): ["New Color", 15],
	Color(1, 0, 0): ["Red", 10], 
	Color(0, 1, 0): ["Green", 10], 
	Color(0, 0, 1): ["Blue", 10],
	Color(0.4, 0, 0.8): ["Purple", 10],
	Color(0, 0, 0): ["Black", 10],
	Color(1, 1, 1): ["White", 10],
	Color(1, 1, 0): ["Yellow", 10], 
	Color(0, 1, 1): ["Cyan", 10], 
	Color(1, 0, 1): ["Magenta", 10],
	Color(0.5, 0.1, 0.1): ["Maroon", 10], 
	Color(0.5, 1, 0.7): ["Mint", 10], 
	Color(0, 1.3, 1.3): ["Glowing Cyan", 10]
}

var shop_sprites = {
	"test-basketball.png": ["Basketball", 20],
	"test-basketball2.png": ["Basketball2", 200]
}

var available_colors = {
	Color(1, 0, 0): "Red", 
	Color(0, 1, 0): "Green",
	Color(0, 0, 1): "Blue",
	Color(0.4, 0, 0.8): "Purple",
	Color(0, 0, 0): "Black",
	Color(1, 1, 1): "White"
}

# In the form color: [name, weight]
# weight is the chance out of unlock_weight to unlock the color
var unlockable_colors = {
	Color(0.1, 0.2, 0.3): ["Unlock1", 4000],
	Color(0.9, 0.8, 0.7): ["Unlock2", 4000]
}
var unlockable_sprites = {
	"smiley.png": ["Smiley", 8000]
}
var unlock_weight = 10000

var available_player_sprites = {}

var sprite_path = "res://assets/sprites/"
var default_texture = "maze-guy2.png"

var background_color = Color(0.4, 0, 0.8)
var maze_color = Color(1, 1, 1)
var particle_color = Color(1, 1, 1)
var player_color = Color(1, 1, 1, 1)
var player_texture = "maze-guy2.png"

var default_button_texture = "color-picker.png"
