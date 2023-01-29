extends Node2D

@onready var camera = $Camera2D
@onready var cursor = $Cursor
@onready var block_container = $block_folder

var block_icons = [
{"id":"0","name":"cube","icon":"res://source/block_scenes/default_block/default_block.png"},
{"id":"1","name":"spike","icon":"res://source/block_scenes/spike/spike.png"},
{"id":"2","name":"checkpoint","icon":"res://source/block_scenes/checkpoint/icon.png"},
]

const CELL_SIZE:int = 16
const speed:int = 200

var on_ui_element:bool = false
var current_cursor_state:int = 0
var previous_mouse_snapped_pos:Vector2
var selected_block:int = 0

var currently_hovering_block:Node2D = null

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
	if on_ui_element:return
	if currently_hovering_block!=null:return
	
	var current_block_id = block_icons[selected_block]["id"]
	var new_block = load(Bigscripts.block_id_to_scene[current_block_id]).instantiate()
	
	new_block.global_position = pos
	
	block_container.call_deferred("add_child",new_block)

func _process(delta):
	#HANDLES MOVEMENT
	var dir_x:int = Input.get_axis("left", "right")
	var dir_y:int = Input.get_axis("up", "down")
	var dir:Vector2 = Vector2(dir_x, dir_y)
	camera.position += dir*speed*delta
	
	
	var current_mouse_snapped_pos = position_to_grid(get_global_mouse_position())
	#DID HANDLE PLACING AND BREAKING
	#if previous_mouse_snapped_pos != current_mouse_snapped_pos:
	#	if current_cursor_state == 1:
	#		place_grid(current_mouse_snapped_pos) 
		
	#previous_mouse_snapped_pos = position_to_grid(get_global_mouse_position())
	
	#HANDLES CURSOR
	if Input.is_action_just_pressed("place"):
		cursor_state(1)
		place_grid(current_mouse_snapped_pos) 
	elif Input.is_action_just_pressed("delete"):
		cursor_state(2)
		if currently_hovering_block != null:
			currently_hovering_block.queue_free()
	elif Input.is_action_just_released("delete") or Input.is_action_just_released("place"):
		cursor_state(0)
	cursor.global_position = position_to_grid(get_global_mouse_position())

func position_to_grid(pos:Vector2):
	return pos.snapped(Vector2.ONE * CELL_SIZE)

# STOP PLACING BLOCKS WHEN ON UI ELEMENT
func _on_control_mouse_entered():
	on_ui_element = false
func _on_control_mouse_exited():
	on_ui_element = true

#DETECT OF MOUSE HOVERING ON BLOCK
var blocks_on_cursor = 0
func _on_area_2d_body_entered(body):
	blocks_on_cursor+=1
	if current_cursor_state == 2:
		body.queue_free()
	elif current_cursor_state == 1 and currently_hovering_block:
		currently_hovering_block.queue_free()
		currently_hovering_block = null
	currently_hovering_block = body
	
func _on_area_2d_body_exited(_body):
	currently_hovering_block = null
	blocks_on_cursor-=1
	if current_cursor_state == 1 and blocks_on_cursor==0:
		place_grid(position_to_grid(get_global_mouse_position()))

#HANDLES EXPORT AND IMPORT
@onready var export = $CanvasLayer/Control/export
@onready var import = $CanvasLayer/Control/import

func clear_map():
	for i in block_container.get_children():
		i.queue_free()
func _on_button_pressed():
	export.release_focus()
	DisplayServer.clipboard_set(Bigscripts.grab_map(block_container))
func _on_import_pressed():
	import.release_focus()
	clear_map()
	var map:Dictionary = JSON.parse_string(DisplayServer.clipboard_get())
	Bigscripts.load_map(map["m"], block_container)

#HANDLES BLOCK SELECTION
@onready var selected_block_texture = $CanvasLayer/Control/selected_block
@onready var up_button = $CanvasLayer/Control/up
@onready var down_button = $CanvasLayer/Control/down

func _on_down_pressed():
	down_button.release_focus()
	if selected_block > 0:
		selected_block-=1
		selected_block_texture.texture = load(block_icons[selected_block]["icon"])
		
func _on_up_pressed():
	up_button.release_focus()
	if selected_block < block_icons.size()-1:
		selected_block+=1
		selected_block_texture.texture = load(block_icons[selected_block]["icon"])


#    #   #######   #      #      #######
#    #   #         #      #      #     #
######   #######   #      #      #     #
#    #   #         #      #      #     #
#    #   #######   ####   ####   #######
