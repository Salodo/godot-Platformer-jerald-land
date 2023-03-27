extends StaticBody2D

var block_dat = {}
var default_block_dat = {}
var block_id = 0

const CELL_SIZE = 16

func _init():
	default_block_dat = block_dat

func position_to_grid(pos:Vector2):
	return (pos / CELL_SIZE).floor()

func grid_to_position(pos:Vector2):
	return pos*CELL_SIZE

func get_dat():
	var grid_pos = position_to_grid(global_position)
	#p = position
	#i = block_id
	#b = block_data
	if block_dat==default_block_dat:
		return {"p":[grid_pos.x,grid_pos.y],"i":block_id}
	else:
		return {"p":[grid_pos.x,grid_pos.y],"i":block_id,"d":block_dat}

func set_dat(dat:Dictionary):
	if dat.has("p"):
		var pos = Vector2(dat["p"][0], dat["p"][1])
		global_position = grid_to_position(pos)
	if dat.has("d"):
		block_dat = dat["d"]

func set_block_dat(dat:Dictionary):
	block_dat = dat
