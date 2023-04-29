extends Control

var path = ""

func open(_path=""):
	path=_path
	show()

func close():
	hide()
	path = ""

signal _delete_world

func _on_yes_pressed():
	if path != "":
		emit_signal("_delete_world",path,false)
	close()

func _on_no_pressed():
	close()
