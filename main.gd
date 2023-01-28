extends Node2D

var block_id_to_scene = {
	"0":"res://source/block_scenes/default_block/block.tscn",
	"1":"res://source/block_scenes/spike/block.tscn",
}

@onready var block_folder = $block_folder

# Called when the node enters the scene tree for the first time.
func _ready():
	#print(JSON.parse_string('{"hello":5}')["hello"])
	load_map(Bigscripts.map_data["m"])

func load_map(map_code):
	for block_dat in map_code:
		var new_block = load(block_id_to_scene[block_dat["i"]]).instantiate()
		new_block.set_dat(block_dat)
		
		block_folder.add_child(new_block)

