extends Control

signal _add_level_button_pressed

func _on_add_level_pressed():
	emit_signal("_add_level_button_pressed")
