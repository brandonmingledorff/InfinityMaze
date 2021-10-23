extends Area2D

onready var HUD = get_node("/root/Maze/HUD")

func _on_Gift_body_entered(body):
	global.prizes_to_select += 1
	HUD.update_gifts()
	queue_free()
