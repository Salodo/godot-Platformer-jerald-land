extends Control

signal _on_settings_ui_close

@onready var main = $outline/inline/main
@onready var keybinds = $outline/inline/keybinds
@onready var keybind_popup = $outline/inline/keybinds/keybind_popup

@onready var keyBind_left = $outline/inline/keybinds/ScrollContainer/VBoxContainer/left
@onready var keyBind_right = $outline/inline/keybinds/ScrollContainer/VBoxContainer/right
@onready var keyBind_jump = $outline/inline/keybinds/ScrollContainer/VBoxContainer/jump

var listening_to_keybinds:bool = false
var mouse_hover_index:int = 0

var actions = ["none", "left", "right", "jump"]

func open():
	update()
	self.show()

func close():
	self.hide()

func _on_back_pressed():
	self.emit_signal("_on_settings_ui_close")

func _on_keybinds_pressed():
	main.hide()
	keybinds.show()

func _on_to_main_pressed():
	main.show()
	keybinds.hide()

func parse_input_text(action):
	return  action+" : "+(InputMap.action_get_events(action)[0].as_text())

func update():
	keyBind_left.text = parse_input_text(actions[1])
	keyBind_right.text = parse_input_text(actions[2])
	keyBind_jump.text = parse_input_text(actions[3])

func _input(event):
	if event is InputEventMouseMotion:return
	
	if Input.is_action_just_pressed("left_click"):
		if mouse_hover_index != 0 and listening_to_keybinds == false:
			listening_to_keybinds = true
			keybind_popup.show()
			return
	
	if listening_to_keybinds:
		if Input.is_action_just_released("left_click"):return
		
		listening_to_keybinds = false
		keybind_popup.hide()
		
		if mouse_hover_index == 0:return
		if Input.is_action_just_pressed("escape"):return
		InputMap.action_erase_events(actions[mouse_hover_index])
		InputMap.action_add_event(actions[mouse_hover_index], event)
		Bigscripts.settings["keybinds"][actions[mouse_hover_index]] = InputMap.action_get_events(actions[mouse_hover_index])[0]
		Bigscripts.save_settings()
		update()

func _on_left_mouse_entered():
	mouse_hover_index = 1
func _on_left_mouse_exited():
	mouse_hover_index = 0

func _on_right_mouse_entered():
	mouse_hover_index = 2
func _on_right_mouse_exited():
	mouse_hover_index = 0


func _on_jump_mouse_entered():
	mouse_hover_index = 3
func _on_jump_mouse_exited():
	mouse_hover_index = 0
