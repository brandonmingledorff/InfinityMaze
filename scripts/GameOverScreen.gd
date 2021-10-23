extends Control

func _on_RestartLevelButton_pressed():
	get_tree().change_scene("res://scenes/Maze.tscn")

func _on_QuitButton_pressed():
	get_tree().change_scene("res://scenes/MainMenu.tscn")
