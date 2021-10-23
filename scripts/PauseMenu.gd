extends Control

func _on_ContinueButton_pressed():
	get_tree().paused = false
	hide()

func _on_MainMenuButton_pressed():
	#global.coins_collected_in_level = 0
	#get_tree().paused = false
	#get_tree().change_scene("res://scenes/MainMenu.tscn")
	$WarningScreen.show()

func _on_OptionsButton_pressed():
	get_parent().find_node("OptionsMenu").show()

func _on_BackButton_pressed():
	$WarningScreen.hide()

func _on_WarningMenuButton_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://scenes/MainMenu.tscn")
