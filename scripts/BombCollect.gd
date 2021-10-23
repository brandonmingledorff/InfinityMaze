extends Area2D

onready var HUD = get_node("/root/Maze/HUD")

func _on_BombCollect_body_entered(body):
	global.num_bombs += 1
	HUD.update_bombs()
	queue_free()
