extends Control

signal rename_world

@onready var edt_world_name = $world_rename_popup/inline/LineEdit

var path = ""
var placeholder_text = ""

func open(_path = "",_placeholder_text=""):
	placeholder_text = _placeholder_text
	path = _path
	
	show()
	#edt_world_name.text = placeholder_text
	edt_world_name.clear()
	
	edt_world_name.grab_focus()

func close():
	path = ""
	hide()

func _on_close_pressed():
	close()


func _on_apply_pressed():
	if not edt_world_name.text == "":
		if path != "":
			emit_signal("rename_world", path, false,edt_world_name.text)
		close()

