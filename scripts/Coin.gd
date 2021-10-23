extends Area2D

onready var HUD = get_node("/root/Maze/HUD")
var value : int = 1

func _ready():
	$ValueLabel.text = "x" + str(value)

func _on_Coin_body_entered(body):
	global.coins_collected_in_level += value
	HUD.update_coins_in_level()
	queue_free()
