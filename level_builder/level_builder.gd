extends Node2D

@onready var camera = $Camera2D
@onready var cursor = $Cursor
@onready var block_container = $block_folder

const CELL_SIZE = 16
const speed = 200

var current_cursor_state:int = 0
var previous_mouse_snapped_pos:Vector2

func _ready():
	cursor.show()
	previous_mouse_snapped_pos = position_to_grid(get_global_mouse_position())

func cursor_state(state:int):
	current_cursor_state = state
	match state:
		0:
			cursor.region_rect = Rect2(0,0,16,16)
		1:
			cursor.region_rect = Rect2(16,0,16,16)
		2:
			cursor.region_rect = Rect2(0,16,16,16)

func place_grid(pos:Vector2):
	var new_block = load("res://source/block_scenes/default_block/block.tscn").instantiate()
	
	new_block.global_position = pos
	
	block_container.add_child(new_block)

func _process(delta):
	#HANDLES MOVEMENT
	var dir_x:int = Input.get_axis("left", "right")
	var dir_y:int = Input.get_axis("up", "down")
	var dir:Vector2 = Vector2(dir_x, dir_y)
	camera.position += dir*speed*delta
	
	#HANDLES PLACING AND BREAKING
	var current_mouse_snapped_pos = position_to_grid(get_global_mouse_position())
	
	if previous_mouse_snapped_pos != current_mouse_snapped_pos:
		if current_cursor_state == 1:
			place_grid(current_mouse_snapped_pos) 
		
	previous_mouse_snapped_pos = position_to_grid(get_global_mouse_position())
	
	#HANDLES CURSOR
	if Input.is_action_just_pressed("place"):
		cursor_state(1)
		place_grid(current_mouse_snapped_pos) 
	elif Input.is_action_just_pressed("delete"):
		cursor_state(2)
	elif Input.is_action_just_released("delete") or Input.is_action_just_released("place"):
		cursor_state(0)
	cursor.global_position = position_to_grid(get_global_mouse_position())

func position_to_grid(pos:Vector2):
	return pos.snapped(Vector2.ONE * CELL_SIZE)


func _on_button_pressed():
	DisplayServer.clipboard_set(Bigscripts.grab_map(block_container))
