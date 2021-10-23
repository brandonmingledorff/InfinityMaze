extends Control

var total_coins
var coins_to_count
var num_prizes
var prize : Array
var prizes_selected : Array
var screen_size
var s_per_coin : float

onready var LevelCalculator = load("res://scripts/LevelCalculator.gd").new()
onready var SaveLoad = load("res://scripts/SaveLoad.gd").new()
onready var CoinMed = "res://assets/coin-med.png"
onready var ColorTex = "res://assets/sprites/color-picker.png"
onready var CoinLabel = $LevelFinishTexture/CoinLabel
onready var TotalCoinsLabel = $LevelFinishTexture/TotalCoinsLabel
onready var LevelLabel = $LevelFinishTexture/LevelCompleteLabel
onready var GiftTexture = $LevelFinishTexture/GiftTexture
onready var OpenGiftTexture = $LevelFinishTexture/OpenGiftTexture
onready var GiftAnimation = $LevelFinishTexture/GiftTexture/AnimationPlayer
onready var GiftLabel = $LevelFinishTexture/GiftLabel
onready var PrizeLabel = $LevelFinishTexture/OpenGiftTexture/PrizeContainer/Label
onready var PrizeTexture = $LevelFinishTexture/OpenGiftTexture/PrizeContainer/TextureRect
onready var PrizeAnimation = $LevelFinishTexture/OpenGiftTexture/PrizeContainer/AnimationPlayer

func _ready():
	screen_size = get_viewport_rect().size
	total_coins = global.coins
	coins_to_count = global.coins_collected_in_level
	num_prizes = global.prizes_to_select
	
	# Unlock prizes here so that player doesn't have to wait for prizes to open
	for i in num_prizes:
		prize = LevelCalculator.select_prize(global.level[global.gamemode])
		
		if prize[0] == "coins":
			global.coins += prize[1]
		elif prize[0] == "color":
			global.available_colors[prize[1]] = prize[2]
		elif prize[0] == "sprite":
			global.available_player_sprites[prize[1]] = prize[2]
		prizes_selected.push_back(prize)
	
	# May raise the seconds per coin for high coin quantities
	var coins_float : float = coins_to_count
	if coins_to_count > 0: s_per_coin = 1.0 / coins_float
	LevelLabel.text = "Level " + str(global.level[global.gamemode]) + " Complete!"
	$LeftConfetti.position = Vector2(0, screen_size.y / 2)
	$RightConfetti.position = Vector2(screen_size.x, screen_size.y / 2)
	$LeftConfetti.emitting = true
	$RightConfetti.emitting = true
	reveal_prizes()

func _on_NextLevelButton_pressed():
	SaveLoad.save_game()
	yield(get_tree().create_timer(0.5), "timeout")
	get_tree().reload_current_scene()
	queue_free()

func _on_MainMenuButton_pressed():
	SaveLoad.save_game()
	yield(get_tree().create_timer(0.5), "timeout")
	get_tree().change_scene("res://scenes/MainMenu.tscn")
	queue_free()
	
func reveal_prizes():
	TotalCoinsLabel.text = str(total_coins)
	CoinLabel.text = "(+" + str(coins_to_count) + ")"
	GiftLabel.text = str(num_prizes)
	yield(get_tree().create_timer(1.0), "timeout")
	
	for i in coins_to_count:
		total_coins += 1
		TotalCoinsLabel.text = str(total_coins)
		
		CoinLabel.text = "(+" + str(coins_to_count - (i + 1)) + ")"
		yield(get_tree().create_timer(s_per_coin), "timeout")
	
	for p in prizes_selected:
		num_prizes -= 1
		yield(get_tree().create_timer(0.5), "timeout")
		GiftLabel.text = str(num_prizes)
		GiftAnimation.play("shake")
		yield(get_tree().create_timer(0.1), "timeout")
		GiftTexture.show()
		yield(GiftAnimation, "animation_finished")
		GiftTexture.hide()
		
		OpenGiftTexture.show()
		
		if p[0] == "coins":
			CoinLabel.text = "(+" + str(p[1]) + ")"
			
			PrizeTexture.texture = load(CoinMed)
			PrizeLabel.text = "+" + str(p[1])
			PrizeAnimation.play("fly")
			#yield(get_tree().create_timer(1.0), "timeout")
			yield(PrizeAnimation, "animation_finished")
			OpenGiftTexture.hide()
			
			var coins_float : float = p[1]
			if coins_to_count > 0: s_per_coin = 1.0 / coins_float
			
			for j in (p[1]):
				TotalCoinsLabel.text = str(total_coins + j + 1)
				CoinLabel.text = "(+" + str(p[1] - (j + 1)) + ")"
				yield(get_tree().create_timer(s_per_coin), "timeout")
			
			total_coins += p[1]
			yield(get_tree().create_timer(0.5), "timeout")
		
		elif p[0] == "color":
			PrizeTexture.texture = load(ColorTex)
			PrizeTexture.self_modulate = p[1]
			PrizeLabel.text = p[2]
			PrizeAnimation.play("fly")
			
			yield(PrizeAnimation, "animation_finished")
			OpenGiftTexture.hide()
			
			yield(get_tree().create_timer(0.5), "timeout")
			
		elif p[0] == "sprite":
			PrizeTexture.texture = load(global.sprite_path + p[1])
			PrizeTexture.self_modulate = Color(1, 1, 1)
			PrizeLabel.text = p[2]
			PrizeAnimation.play("fly")
			
			yield(PrizeAnimation, "animation_finished")
			OpenGiftTexture.hide()
			
			yield(get_tree().create_timer(0.5), "timeout")
