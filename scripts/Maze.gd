extends Node2D

const N = 1
const E = 2
const S = 4
const W = 8

const TEST_HEIGHT = 6

onready var StageFinish = preload("res://scenes/StageFinish.tscn")
onready var LevelComplete = preload("res://scenes/LevelFinishScreen.tscn")
onready var GameOver = preload("res://scenes/GameOverScreen.tscn")
onready var Enemy = preload("res://scenes/Enemy.tscn")
onready var Coin = preload("res://scenes/Coin.tscn")
onready var Gift = preload("res://scenes/Gift.tscn")
onready var BombCollect = preload("res://scenes/BombCollect.tscn")
onready var MazeGenerator = load("res://scripts/Maze_Generator.gd").new()
onready var LevelCalculator = load("res://scripts/LevelCalculator.gd").new()
onready var HUD = $HUD
onready var Map = $TileMap
onready var Cam = $Camera2D
onready var Player = $Player

var screen_size
var mazes_generated
var s

var curr_maze_start
var curr_maze_end
var curr_maze_height
var curr_maze_width
var coords = Vector2()

var next_maze_start
var next_maze_end
var next_maze_height
var next_maze_width
var next_maze_coords = Vector2()

var gen_maze_start
var gen_maze_end
var gen_maze_height
var gen_maze_width
var gen_maze_coords = Vector2()

func _ready():
	
	randomize()
	global.tile_size = Map.cell_size.x
	screen_size = get_viewport_rect()
	
	#global.lives = 3
	global.stage = 1
	global.num_stages = LevelCalculator.get_stages_at_level(global.level[global.gamemode])
	global.coins_collected_in_level = 0
	global.prizes_to_select = 0
	global.num_bombs = 5
	
	global.lives = 1 if global.gamemode == "hardcore" else 3
	
	HUD.update_lives()
	HUD.update_stage(false)
	HUD.change_level()
	HUD.update_coins_in_level()
	HUD.update_bombs()
	HUD.update_gifts()
	
	update_tile_color()
	
	coords = Vector2(0, 0)
	
	curr_maze_width = LevelCalculator.get_size_at_stage(1, global.level[global.gamemode]) #TEST_HEIGHT
	curr_maze_height = LevelCalculator.get_size_at_stage(1, global.level[global.gamemode]) #TEST_HEIGHT
	
	Cam.position.x = global.tile_size * curr_maze_width / 2
	Cam.position.y = global.tile_size * curr_maze_height / 2
	Cam.zoom.x = (global.tile_size * curr_maze_height / screen_size.size.y) * Cam.ZOOM_FACTOR
	Cam.zoom.y = (global.tile_size * curr_maze_height / screen_size.size.y) * Cam.ZOOM_FACTOR
	#Cam.bounce() # Uncomment here and in move_camera to enable
	
	curr_maze_start = randi() % curr_maze_width
	curr_maze_end = randi() % curr_maze_width
	MazeGenerator.make_maze(coords.x, coords.y, curr_maze_width, curr_maze_height, Map)
	populate_collectables(coords.x, coords.y, curr_maze_width, curr_maze_height, curr_maze_start, curr_maze_end)
	populate_enemies(coords.x, coords.y, curr_maze_width, curr_maze_height)
	yield(get_tree(), "idle_frame")
	
	# Add new maze after current one
	next_maze_width = LevelCalculator.get_size_at_stage(2, global.level[global.gamemode]) #TEST_HEIGHT
	next_maze_height = LevelCalculator.get_size_at_stage(2, global.level[global.gamemode]) #TEST_HEIGHT
	next_maze_start = randi() % next_maze_width
	next_maze_end = randi() % next_maze_width
	
	next_maze_coords.x = coords.x + (curr_maze_end - next_maze_start)
	next_maze_coords.y = coords.y - next_maze_height
	MazeGenerator.make_maze(next_maze_coords.x, next_maze_coords.y, next_maze_width, next_maze_height, Map)
	populate_collectables(next_maze_coords.x, next_maze_coords.y, next_maze_width, next_maze_height, next_maze_start, next_maze_end)
	populate_enemies(next_maze_coords.x, next_maze_coords.y, next_maze_width, next_maze_height)
	
	mazes_generated = 2
	
	# Add first stage finish marker
	s = StageFinish.instance()
	add_child(s)
	s.position.x = (global.tile_size * (coords.x + curr_maze_end)) + (global.tile_size / 2)
	s.position.y = (global.tile_size * coords.y) + (global.tile_size / 2)
	
	#p = Player.instance()
	#add_child(p)
	Player.position.x = (global.tile_size * (coords.x + curr_maze_start)) + (global.tile_size / 2)
	Player.position.y = (global.tile_size * (coords.y + curr_maze_height)) - (global.tile_size / 2)
	
	global.can_pause = true
	HUD.countdown()

func stage_finish():
	
	var cell_to_get
	var cell_to_set
	
	if global.stage < global.num_stages:
		Cam.move_camera(next_maze_coords, next_maze_width, next_maze_height)
	
	global.disable_movement = true
	global.collision_disabled = true
	
	gen_maze_width = LevelCalculator.get_size_at_stage(global.stage + 2, global.level[global.gamemode]) #30
	gen_maze_height = LevelCalculator.get_size_at_stage(global.stage + 2, global.level[global.gamemode]) #30
	gen_maze_start = randi() % gen_maze_width
	gen_maze_end = randi() % gen_maze_width
	
	gen_maze_coords.x = next_maze_coords.x + (next_maze_end - gen_maze_start)
	gen_maze_coords.y = next_maze_coords.y - gen_maze_height
	
	cell_to_get = Map.get_cellv(Vector2(coords.x + curr_maze_end, coords.y))
	cell_to_set = Vector2(coords.x + curr_maze_end, coords.y)
	Map.set_cellv(cell_to_set, cell_to_get - N)
	
	cell_to_get = Map.get_cellv(Vector2(next_maze_coords.x + next_maze_start, coords.y - 1))
	cell_to_set = Vector2(next_maze_coords.x + next_maze_start, coords.y - 1)
	Map.set_cellv(cell_to_set, cell_to_get - S)
	
	s.queue_free()
	
	if mazes_generated < global.num_stages:
		MazeGenerator.make_maze(gen_maze_coords.x, gen_maze_coords.y, gen_maze_width, gen_maze_height, Map)
		populate_collectables(gen_maze_coords.x, gen_maze_coords.y, gen_maze_width, gen_maze_height, gen_maze_start, gen_maze_end)
		populate_enemies(gen_maze_coords.x, gen_maze_coords.y, gen_maze_width, gen_maze_height)
	
	if global.stage >= global.num_stages:
		level_finish()
	else:
		global.stage += 1
		HUD.update_stage(true)
		
		s = StageFinish.instance()
		call_deferred("add_child", s)
		
		s.position.x = (global.tile_size * (next_maze_coords.x + next_maze_end)) + (global.tile_size / 2)
		s.position.y = (global.tile_size * next_maze_coords.y) + (global.tile_size / 2)
		
		yield(get_tree().create_timer(1.5), "timeout")
		Player.initial_movement()
		global.disable_movement = false
		start_enemy_movement(next_maze_coords, Vector2(next_maze_width, next_maze_height))
		global.collision_disabled = false
		
		free_old_enemies(coords, Vector2(curr_maze_width, curr_maze_height))
		
		cell_to_get = Map.get_cellv(Vector2(coords.x + curr_maze_end, coords.y))
		cell_to_set = Vector2(coords.x + curr_maze_end, coords.y)
		Map.set_cellv(cell_to_set, cell_to_get + N)
		
		cell_to_get = Map.get_cellv(Vector2(next_maze_coords.x + next_maze_start, coords.y - 1))
		cell_to_set = Vector2(next_maze_coords.x + next_maze_start, coords.y - 1)
		Map.set_cellv(cell_to_set, cell_to_get + S)
		
		curr_maze_width = next_maze_width
		curr_maze_height= next_maze_height
		curr_maze_start = next_maze_start
		curr_maze_end = next_maze_end
		coords = next_maze_coords
		
		next_maze_width = gen_maze_width
		next_maze_height = gen_maze_height
		next_maze_start = gen_maze_start
		next_maze_end = gen_maze_end
		next_maze_coords = gen_maze_coords
		
		mazes_generated += 1
		
func populate_collectables(x : int, y : int, width : int, height : int, start : int, end : int):
	
	var pos = Vector2()
	var used = []
	var valid = false
	
	var num_coins = LevelCalculator.get_num_items(width, height, 15, 35, 10)
	#var num_coins = LevelCalculator.get_num_coins(width, height)
	var num_bombs = LevelCalculator.get_num_items(width, height, 25, 50, 5)
	#var num_bombs = LevelCalculator.get_num_bombs(width, height)
	var num_gifts = LevelCalculator.get_num_gifts(width, height)
	
	var new_max : int = abs(y)
	var new_min : int = abs(y + height - 1)
	
	for i in range(num_coins):
		valid = false
		while not valid:
			pos.x = x + (randi() % width)
			if y < 0:
				pos.y = new_min + (randi() % (new_max - new_min))
				pos.y *= -1
			else:
				pos.y = y + (randi() % height)

			if not (pos in used):
				if (not pos == Vector2(x + end, y)) and (not pos == Vector2(x + start, y + height - 1)): 
					valid = true
					used.append(pos)
					var c = Coin.instance()
					call_deferred("add_child", c)
					
					c.position.x = (pos.x) * global.tile_size + (global.tile_size / 2)
					c.position.y = (pos.y) * global.tile_size + (global.tile_size / 2)
					
	for i in range(num_bombs):
			valid = false
			while not valid:
				pos.x = x + (randi() % width)
				if y < 0:
					pos.y = new_min + (randi() % (new_max - new_min))
					pos.y *= -1
				else:
					pos.y = y + (randi() % height)

				if not (pos in used):
					if (not pos == Vector2(x + end, y)) and (not pos == Vector2(x + start, y + height - 1)): 
						valid = true
						used.append(pos)
						var b = BombCollect.instance()
						call_deferred("add_child", b)
						
						b.position.x = (pos.x) * global.tile_size + (global.tile_size / 2)
						b.position.y = (pos.y) * global.tile_size + (global.tile_size / 2)
						
	for i in range(num_gifts):
				valid = false
				while not valid:
					pos.x = x + (randi() % width)
					if y < 0:
						pos.y = new_min + (randi() % (new_max - new_min))
						pos.y *= -1
					else:
						pos.y = y + (randi() % height)

					if not (pos in used):
						if (not pos == Vector2(x + end, y)) and (not pos == Vector2(x + start, y + height - 1)): 
							valid = true
							used.append(pos)
							var g = Gift.instance()
							call_deferred("add_child", g)
							
							g.position.x = (pos.x) * global.tile_size + (global.tile_size / 2)
							g.position.y = (pos.y) * global.tile_size + (global.tile_size / 2)

func populate_enemies(x : int, y : int, width : int, height : int):
	
	if global.gamemode == "relaxed": return
	
	var pos = Vector2()
	var num_enemies = LevelCalculator.get_num_items(width, height, 40, 100, 5)
	#var num_enemies = LevelCalculator.get_num_enemies(width, height)
	
	var new_max : int = abs(y)
	var new_min : int = abs(y + height / 2)
	
	for i in range(num_enemies):
		pos.x = x + (randi() % width)
		if y < 0:
			pos.y = new_min + (randi() % (new_max - new_min))
			pos.y *= -1
		else:
			pos.y = y + (randi() % (height / 2))
			
		var e = Enemy.instance()
		call_deferred("add_child", e)
		e.position.x = (pos.x) * global.tile_size + (global.tile_size / 2)
		e.position.y = (pos.y) * global.tile_size + (global.tile_size / 2)

func free_old_enemies(topleft, size):
	var enemies = get_tree().get_nodes_in_group("enemies")
	#print("topleft: " + str(topleft) + " bottomright: " + str(bottomright))
	var new_tl = topleft * global.tile_size
	var new_size = size * global.tile_size
	
	for enemy in enemies:
		#print("TL: " + str(topleft) + " SZ: " + str(size))
		#print("enemy position: " + str(enemy.position / global.tile_size))
		if Rect2(new_tl, new_size).has_point(enemy.position):
			#print("freed")
			enemy.queue_free()

func start_enemy_movement(topleft, size):
	var enemies = get_tree().get_nodes_in_group("enemies")
	
	var new_tl = topleft * global.tile_size
	var new_size = size * global.tile_size
	
	for enemy in enemies:
		if Rect2(new_tl, new_size).has_point(enemy.position):
			enemy.local_disable_movement = false

func respawn():
	global.collision_disabled = true
	Player.position.x = (global.tile_size * (coords.x + curr_maze_start)) + (global.tile_size / 2)
	Player.position.y = (global.tile_size * (coords.y + curr_maze_height)) - (global.tile_size / 2)
	Player.blink()
	yield(get_tree().create_timer(1.0), "timeout")
	global.collision_disabled = false
	Player.initial_movement()
	
func level_finish():
	global.can_pause = false
	HUD.find_node("HBox").hide()
	Cam.level_end_camera()
	
	var l = LevelComplete.instance()
	HUD.add_child(l)
	
	# Might need to yield
	global.level[global.gamemode] += 1
	global.coins += global.coins_collected_in_level
	#global.coins_collected_in_level = 0

func game_over():
	global.can_pause = false
	Player.explode()
	yield(get_tree().create_timer(1.0), "timeout")
	Cam.level_end_camera()
	
	var g = GameOver.instance()
	HUD.add_child(g)

func update_tile_color():
	# Use to change color of tileset
	for i in range(0, 31):
		Map.tile_set.tile_set_modulate(i, global.maze_color)
