extends Node2D

@onready var block_folder = $block_folder

# Called when the node enters the scene tree for the first time.
func _ready():
	#print(JSON.parse_string('{"hello":5}')["hello"])
	Bigscripts.load_map(Bigscripts.map_data["m"], block_folder)


