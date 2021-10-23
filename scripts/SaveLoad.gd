extends Node

var savegame = "user://savegame.dat"

signal saved
signal loaded

func save_game():
	var file = File.new()
	file.open(savegame, File.WRITE)
	
	file.store_var(global.coins)
	file.store_var(global.level)
	file.store_var(global.player_color)
	file.store_var(global.player_texture)
	file.store_var(global.particle_color)
	file.store_var(global.maze_color)
	file.store_var(global.background_color)
	file.store_var(global.available_colors)
	file.store_var(global.available_player_sprites)
	
func load_game():
	var file = File.new()
	
	if file.file_exists(savegame):
		file.open(savegame, File.READ)
		
		global.coins = file.get_var()
		global.level = file.get_var()
		global.player_color = file.get_var()
		global.player_texture = file.get_var()
		global.particle_color = file.get_var()
		global.maze_color = file.get_var()
		global.background_color = file.get_var()
		global.available_colors = file.get_var()
		global.available_player_sprites = file.get_var()
		
#		print(str(global.coins))
#		print(str(global.level))
#		print(str(global.player_color))
#		print(str(global.player_texture))
#		print(str(global.particle_color))
#		print(str(global.maze_color))
#		print(str(global.background_color))
		
