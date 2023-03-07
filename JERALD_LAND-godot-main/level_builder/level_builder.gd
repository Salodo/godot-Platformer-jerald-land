extends Node2D

@onready var camera = $Camera2D
@onready var cursor = $Cursor
@onready var block_container = $block_folder
@onready var jerald = $jerald
@onready var properties_menu = $CanvasLayer/Control/properties/ScrollContainer/MarginContainer/VBoxContainer

var block_icons = [
{"name":"cube","icon":"res://source/block_scenes/default_block/default_block.png"},
{"name":"spike","icon":"res://source/block_scenes/spike/spike.png"},
{"name":"checkpoint","icon":"res://source/block_scenes/checkpoint/icon.png"},
{"name":"jump_pad","icon":"res://source/block_scenes/jump_pad/jump_pad.png"},
]

const CELL_SIZE:int = 16
const speed:int = 200

var on_ui_element:bool = false
var current_cursor_state:int = 0
var previous_mouse_snapped_pos:Vector2
var selected_block:int = 0
var selected_block_dat = null

var currently_hovering_block:Node2D = null
var hovering_on_jerald:bool = false
var moving_jerald:bool = false
var can_place:bool = true

func load_map(map_data):
	clear_map()
	Bigscripts.load_map(map_data["m"], block_container)
	jerald.global_position = Vector2(map_data["s"][0],map_data["s"][1])*16

func _ready():
	cursor.show()
	if Bigscripts.editor_load_map:
		load_map(Bigscripts.map_data)
	_on_reset_cam_pressed()
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
		3:
			cursor.region_rect = Rect2(16,16,16,16)

func place_grid(pos:Vector2):
	if on_ui_element:return
	if currently_hovering_block!=null:return
	
	var current_block_id = selected_block
	var new_block = load(Bigscripts.block_id_to_scene[str(current_block_id)]).instantiate()
	
	new_block.global_position = pos
	if selected_block_dat:
		new_block.block_dat = selected_block_dat
	
	block_container.call_deferred("add_child",new_block)

func _process(delta):
	#HANDLES MOVEMENT
	var dir_x:int = Input.get_axis("left", "right")
	var dir_y:int = Input.get_axis("up", "down")
	var dir:Vector2 = Vector2(dir_x, dir_y)
	camera.position += dir*speed*delta
	
	var current_mouse_snapped_pos = position_to_grid(get_global_mouse_position())
	
	for i in ["place", "delete", "pick_block"]:
		if Input.is_action_just_pressed(i):
			if not on_ui_element:
				properties_menu.close()
				break
	
	if Input.is_action_just_pressed("place") and can_place and not on_ui_element:
		cursor_state(1)
		
		if currently_hovering_block:
			
			var block_dat = currently_hovering_block.block_dat
			var block_name = block_icons[currently_hovering_block.block_id]["name"]
			
			properties_menu.register_menu(block_dat, block_name, currently_hovering_block)
		else:
			place_grid(current_mouse_snapped_pos)
	elif Input.is_action_just_pressed("delete"):
		cursor_state(2)
		if currently_hovering_block != null:
			currently_hovering_block.queue_free()
	elif Input.is_action_just_released("delete") or Input.is_action_just_released("place"):
		cursor_state(0)
	elif Input.is_action_just_pressed("place") and hovering_on_jerald:
		moving_jerald = true
		cursor_state(3)
	elif Input.is_action_just_pressed("pick_block_dat"):
		if currently_hovering_block:
			select_block(currently_hovering_block.block_id)
			selected_block_dat = currently_hovering_block.block_dat
	elif Input.is_action_just_pressed("pick_block"):
		if currently_hovering_block:
			select_block(currently_hovering_block.block_id)
			
	if Input.is_action_just_released("place") and hovering_on_jerald:
		moving_jerald = false
		can_place = true
	
	cursor.global_position = current_mouse_snapped_pos
	if moving_jerald:
		jerald.position = current_mouse_snapped_pos

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
	if body.is_in_group("player_dummy"):
		hovering_on_jerald = true
		can_place = false
		return
	
	blocks_on_cursor+=1
	if current_cursor_state == 2:
		body.queue_free()
	elif current_cursor_state == 1 and currently_hovering_block:
		currently_hovering_block.queue_free()
		currently_hovering_block = null
	currently_hovering_block = body
func _on_area_2d_body_exited(body):
	if body.is_in_group("player_dummy"):
		hovering_on_jerald = false
		can_place = true
		return
	
	currently_hovering_block = null
	blocks_on_cursor-=1
	if current_cursor_state == 1 and blocks_on_cursor==0 and can_place:
		place_grid(position_to_grid(get_global_mouse_position()))



#HANDLES EXPORT AND IMPORT
@onready var export = $CanvasLayer/Control/export
@onready var import = $CanvasLayer/Control/import

func clear_map():
	for i in block_container.get_children():
		i.queue_free()
func _on_button_pressed():
	export.release_focus()
	var s = position_to_grid(jerald.global_position)/16
	DisplayServer.clipboard_set(Bigscripts.grab_map(block_container,s))
func _on_import_pressed():
	import.release_focus()
	var map:Dictionary = JSON.parse_string(DisplayServer.clipboard_get())
	load_map(map)


#HANDLES BLOCK SELECTION
@onready var selected_block_texture = $CanvasLayer/Control/selected_block
@onready var up_button = $CanvasLayer/Control/up
@onready var down_button = $CanvasLayer/Control/down

func _input(event):
	if Input.is_action_just_pressed("block_up"):
		_on_down_pressed()
	elif Input.is_action_just_pressed("block_down"):
		_on_up_pressed()

func select_block(id):
	selected_block_texture.texture = load(block_icons[id]["icon"])
	selected_block = id
	selected_block_dat = null
func _on_down_pressed():
	down_button.release_focus()
	if selected_block > 0:
		select_block(selected_block-1)
func _on_up_pressed():
	up_button.release_focus()
	if selected_block < block_icons.size()-1:
		select_block(selected_block+1)

#HANDLES PLAYTESTING and camera reset
@onready var playtes_button = $CanvasLayer/Control/playtest

func _on_playtest_pressed():
	playtes_button.release_focus()
	var s = position_to_grid(jerald.global_position)/16
	var map_dat:Dictionary = JSON.parse_string(Bigscripts.grab_map(block_container, s))
	Bigscripts.change_map(map_dat)
	get_tree().change_scene_to_file("res://level_loader/main.tscn")
func _on_reset_cam_pressed():
	camera.global_position = jerald.global_position
