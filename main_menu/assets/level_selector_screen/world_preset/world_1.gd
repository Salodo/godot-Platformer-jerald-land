extends Control

var lvl_dat:Dictionary = {}
var lvl_path:String = ""

signal reload_map_screen
signal delete_world
signal rename_world

func change_destination(path:String):
	var file = FileAccess.open(path, FileAccess.READ)
	lvl_dat = file.get_var()
	file = null
	lvl_path = path
	get_node("Label").text = lvl_dat["t"]

func _on_play_pressed():
	Bigscripts.editor_mode = false
	Bigscripts.change_map(lvl_dat)
	get_tree().change_scene_to_file("res://level_loader/main.tscn")
	

func _on_editor_pressed():
	Bigscripts.editor_mode = true
	Bigscripts.change_map(lvl_dat)
	Bigscripts.loaded_level_path = lvl_path
	get_tree().change_scene_to_file("res://level_builder/level_builder.tscn")

func _on_delete_pressed():
	emit_signal("delete_world",lvl_path)
	#DirAccess.remove_absolute(lvl_path)
	#emit_signal("reload_map_screen")


func _on_rename_pressed():
	emit_signal("rename_world",lvl_path,true,lvl_dat["t"])
