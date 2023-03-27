extends Control

signal make_world

@onready var edt_world_name = $world_name_popup/inline/LineEdit

func open():
	show()
	edt_world_name.clear()

func close():
	hide()

func _on_close_pressed():
	close()


func _on_apply_pressed():
	if not edt_world_name.text == "":
		close()
		emit_signal("make_world", edt_world_name.text)

