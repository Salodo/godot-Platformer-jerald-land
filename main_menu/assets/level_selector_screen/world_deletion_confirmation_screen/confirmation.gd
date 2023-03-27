extends Control

func open():
	show()

func close():
	hide()

signal _delete_world

func _on_yes_pressed():
	close()
	emit_signal("_delete_world")

func _on_no_pressed():
	close()
