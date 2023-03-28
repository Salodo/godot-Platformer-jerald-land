extends Control

@onready var settings = $settings_ui
@onready var main = $outline/inline/main

var settings_open:bool = false

signal _on_pause_ui_close

func _ready():
	Bigscripts.connect("color_changed", update_color)
	settings.connect("_on_settings_ui_close", self._on_settings_ui_close)

func update_color():
	if settings_open:
		modulate = Color("FFFFFF")

func open():
	self.show()

func close():
	self.hide()

func _on_back_pressed():
	emit_signal("_on_pause_ui_close")

func _on_settings_ui_close():
	settings.close()
	settings_open = false
	Bigscripts.customize([self])

func _on_settings_pressed():
	settings.open()
	settings_open = true
	modulate = Color("FFFFFF")

func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")
