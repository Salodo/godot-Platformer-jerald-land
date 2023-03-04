extends Node2D

const path = "user://"
const levels_path = path+"levels"
const campaign_levels_path = path+"campaign_levels"

func _ready():
	if not DirAccess.dir_exists_absolute(levels_path):
		DirAccess.make_dir_absolute(levels_path)
	if not DirAccess.dir_exists_absolute(campaign_levels_path):
		DirAccess.make_dir_absolute(campaign_levels_path)
		
	var file = FileAccess.open(levels_path+"/default.dat", FileAccess.WRITE)
	file.store_var(Bigscripts.map_data)
	
	file = FileAccess.open(levels_path+"/default.dat", FileAccess.READ)
	print(file.get_var())
	
	
	
func _on_play_pressed():
	get_tree().change_scene_to_file("res://level_loader/main.tscn")

func _on_edit_pressed():
	get_tree().change_scene_to_file("res://level_builder/level_builder.tscn")
