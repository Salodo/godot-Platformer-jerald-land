extends "block.gd"

func _init():
	block_id = "2"

@onready var texture = $texture

func set_texture_state(state:int):
	match state:
		0:
			texture.region_rect = Rect2(0,0,16,16)
		1:
			texture.region_rect = Rect2(0,16,16,16)
		
func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		Bigscripts.spawn_pos = global_position
		set_texture_state(1)

func _on_visible_on_screen_notifier_2d_screen_entered():
	if Bigscripts.spawn_pos == global_position:
		set_texture_state(1)
	else:
		set_texture_state(0)
