extends Control

@onready var settings = $settings_ui
@onready var main = $outline/inline/main

signal _on_pause_ui_close

func open():
	self.show()

func close():
	self.hide()

func _ready():
	settings.connect("_on_settings_ui_close", self._on_settings_ui_close)

func _on_back_pressed():
	emit_signal("_on_pause_ui_close")

func _on_settings_ui_close():
	settings.close()

func _on_settings_pressed():
	settings.open()

func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")
