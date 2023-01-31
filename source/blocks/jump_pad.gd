extends "block.gd"

func _init():
	block_id = 3
	block_dat["s"] = 50
	default_block_dat = block_dat

func _on_detector_body_entered(body):
	if body.is_in_group("entity"):
		var vx = body.velocity.x
		var vy = body.velocity.y
		var dir = 0
		if vx != 0:
			dir = vx/abs(vx)
		
		vx = dir * 2
		vy = -7
		
		body.velocity += (Vector2(vx,vy))*block_dat["s"]
