extends "block.gd"

func _init():
	block_id = 2
	block_dat["w"] = false

@onready var texture = $texture

func set_texture_state(state:int):
	match state:
		0:
			texture.play("blank")
		1:
			texture.play("activated")
		2:
			texture.play("end")
		
func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		if block_dat["w"] == false:
			Bigscripts.spawn_pos = global_position
			set_texture_state(1)
		else:
			body.win()

func _on_visible_on_screen_notifier_2d_screen_entered():
	if block_dat["w"] == true:
		set_texture_state(2)
	elif  Bigscripts.spawn_pos == global_position:
		set_texture_state(1)
	else:
		set_texture_state(0)
