extends Area2D

var inside : bool = false
var p

func _process(delta):
	if inside == true:
		if Input.is_action_just_pressed("next_stage"):
			p.position = position
			p.velocity = Vector2.UP * 40
			p.next_stage()
			get_parent().stage_finish()

func _on_StageFinish_body_entered(body):
	if body.name == "Player":
		p = body
		inside = true
		modulate.a = 0.5
		global.inside_sf = true
	
#	if body.name == "Player":
#		body.position = position
#		body.velocity = Vector2.UP * 40
#
#	if body.has_method("next_stage"):
#		body.next_stage()
		
	#get_parent().stage_finish()
	
func _on_StageFinish_body_exited(body):
	if body.name == "Player":
		inside = false
		modulate.a = 1.0
		global.inside_sf = false
