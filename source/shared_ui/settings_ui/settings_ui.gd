extends Control

signal _on_settings_ui_close

@onready var main = $outline/inline/main
@onready var keybinds = $outline/inline/keybinds
@onready var keybind_popup = $outline/inline/keybinds/keybind_popup

var listening_to_keybinds:bool = false
var mouse_hover_index:int = 0

func open():
	self.show()
	#print(InputMap.action_get_events("jump"))
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


func _input(event):
	
	if event is InputEventMouseMotion:return
	
	if Input.is_action_just_pressed("left_click"):
		if mouse_hover_index != 0 and listening_to_keybinds == false:
			listening_to_keybinds = true
			keybind_popup.show()
			return
	
	if listening_to_keybinds:
		if Input.is_action_just_released("left_click"):return
		print(event.as_text())
		listening_to_keybinds = false
		keybind_popup.hide()

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
