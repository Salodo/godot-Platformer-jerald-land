extends "block.gd"

@onready var text = $Node2D/label

func _init():
	block_id = 4
	block_dat["t"] = "[Insert Text]"
	super._init()
	
func _ready():
	text.text = block_dat["t"]

func set_block_dat(dat:Dictionary):
	super.set_block_dat(dat)
	$Node2D/label.text = block_dat["t"]
