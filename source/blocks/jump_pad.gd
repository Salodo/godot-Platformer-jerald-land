extends "block.gd"

@onready var texture = $texture

func _init():
	block_id = 3
	block_dat["s"] = 90
	default_block_dat = block_dat

func _ready():
	texture.play("default")

func _on_detector_body_entered(body):
	if body.is_in_group("player"):
		body.jump_on_ground += 1
		body.bounce_factor = block_dat["s"]
		texture.play("activated")

func _on_detector_body_exited(body):
	if body.is_in_group("player"):
		body.jump_on_ground -= 1

func _on_texture_animation_finished():
	pass
	#texture.play("default")

