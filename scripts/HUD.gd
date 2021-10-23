extends CanvasLayer

#onready var GoLabel = $Control/GoLabel
#onready var StageLabel = $Control/VBoxContainer/StageLabel
#onready var LevelLabel = $Control/VBoxContainer/LevelLabel
#onready var CoinsLabel = $Control/VBoxContainer/HBoxContainer/CoinsLabel
#onready var BombLabel = $Control/VBoxContainer/HBoxContainer2/BombLabel
#onready var PauseMenu = $PauseMenu

onready var GoLabel = $GoLabel
onready var StageLabel = $Main/HBox/StageLevelContainer/StageLabel
onready var LevelLabel = $Main/HBox/StageLevelContainer/LevelLabel
onready var LivesContainer = $Main/HBox/LivesContainer
onready var Life = preload("res://scenes/Life.tscn")
onready var CoinsLabel = $Main/HBox/CoinBombContainer/CoinContainer/CoinsLabel
onready var BombLabel = $Main/HBox/CoinBombContainer/BombContainer/BombLabel
onready var GiftLabel = $Main/HBox/CoinBombContainer/GiftContainer/GiftLabel
onready var PauseMenu = $PauseMenu
onready var Maze = find_parent("Maze")

var counting_down : bool = false

func _process(delta):
	if counting_down:
		GoLabel.text = str(stepify($GoTimer.time_left, 0.1))
	if Input.is_action_just_pressed("p") or Input.is_action_just_pressed("esc"):
		if global.can_pause:
			if PauseMenu.visible == false:
				get_tree().paused = true
				PauseMenu.show()
			else:
				get_tree().paused = false
				PauseMenu.hide()

func update_stage(play_animation : bool):
	#if play_animation:
		#$StageLabel/AnimationPlayer.play("stage_finished")
		#$StageLabel.text = "Stage: " + str(global.stage) + " / " + str(global.num_stages)
	#else:
		change_stage()

func change_stage():
	StageLabel.text = "Stage: " + str(global.stage) + " / " + str(global.num_stages)

func change_level():
	LevelLabel.text = "Level: " + str(global.level[global.gamemode])
	
# May change this to only include coins in level, total coins may take up too much space
func update_coins_in_level():
	CoinsLabel.text = ": " + str(global.coins) + " (+" + str(global.coins_collected_in_level) + ")"

func update_bombs():
	BombLabel.text = str(global.num_bombs)

func update_gifts():
	GiftLabel.text = str(global.prizes_to_select)

func update_lives():
	for child in LivesContainer.get_child_count():
		LivesContainer.get_child(child).queue_free()
	
	if global.lives > 0:
		for life in global.lives:
			var l = Life.instance()
			LivesContainer.add_child(l)

func countdown():
	counting_down = true
	global.disable_movement = true
	GoLabel.show()
	$GoTimer.start()

func _on_GoTimer_timeout():
	counting_down = false
	global.disable_movement = false
	Maze.start_enemy_movement(Maze.coords, Vector2(Maze.curr_maze_width, Maze.curr_maze_height))
	get_parent().find_node("Player").initial_movement()
	GoLabel.text = "Go!"
	yield(get_tree().create_timer(1.0), "timeout")
	GoLabel.hide()
	#get_parent().initial_movement()
