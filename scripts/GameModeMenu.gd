extends Control

onready var ClassicLevelLabel = $ClassicMode/Level
onready var RelaxedLevelLabel = $RelaxedMode/Level
onready var HardcoreLevelLabel = $HardcoreMode/Level

func _ready():
	ClassicLevelLabel.text = "Level: " + str(global.level["classic"])
	RelaxedLevelLabel.text = "Level: " + str(global.level["relaxed"])
	HardcoreLevelLabel.text = "Level: " + str(global.level["hardcore"])

func _on_BackButton_pressed():
	get_tree().change_scene("res://scenes/MainMenu.tscn")

func _on_PlayClassic_pressed():
	global.gamemode = "classic"
	get_tree().change_scene("res://scenes/Maze.tscn")

func _on_PlayRelaxed_pressed():
	global.gamemode = "relaxed"
	get_tree().change_scene("res://scenes/Maze.tscn")

func _on_PlayHardcore_pressed():
	global.gamemode = "hardcore"
	get_tree().change_scene("res://scenes/Maze.tscn")
