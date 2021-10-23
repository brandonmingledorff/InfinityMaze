extends Control

onready var SaveLoad = load("res://scripts/SaveLoad.gd").new()
onready var OptionsMenu = preload("res://scenes/OptionsMenu.tscn")
onready var ShopMenu = preload("res://scenes/ShopMenu.tscn")
onready var MainMenuGuy = preload("res://scenes/MainMenuGuy.tscn")
onready var Play = $HBoxContainer/VBoxContainer/Play
onready var Shop = $HBoxContainer/VBoxContainer/Shop
onready var Options = $HBoxContainer/VBoxContainer2/Options
onready var Quit = $HBoxContainer/VBoxContainer2/Quit

var screen_size

func _ready():
	$LoadingScreen.show()
	Play.disabled = true
	Shop.disabled = true
	Options.disabled = true
	Quit.disabled = true
	
	screen_size = get_viewport_rect().size
	
	if global.first_load == false:
		SaveLoad.load_game()
		global.first_load = true
		
		# May need to be longer or changed to wait for execution completion
		yield(get_tree().create_timer(1.0), "timeout")
		
	VisualServer.set_default_clear_color(global.background_color)
	
	var options = OptionsMenu.instance()
	var shop = ShopMenu.instance()
	var guy = MainMenuGuy.instance()
	add_child(options)
	add_child(shop)
	add_child(guy)
	
	options.hide()
	shop.hide()
	
	Play.disabled = false
	Shop.disabled = false
	Options.disabled = false
	Quit.disabled = false
	$LoadingScreen.hide()

func _on_Play_pressed():
	#print("play pressed")
	get_tree().change_scene("res://scenes/GameModeMenu.tscn")

func _on_Quit_pressed():
	SaveLoad.save_game()
	yield(get_tree().create_timer(1.0), "timeout")
	get_tree().quit()

func _on_Options_pressed():
	$OptionsMenu.show()

func _on_Shop_pressed():
	$ShopMenu.show()

