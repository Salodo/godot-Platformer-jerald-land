extends Node2D

const path = "user://"
const levels_path = path+"levels"
const campaign_levels_path = path+"campaign_levels"

@onready var animation = $CanvasLayer/main_ui/animation
@onready var jerald_animation = $jerald_animation

@onready var main_ui = $CanvasLayer/main_ui
@onready var campaign_ui = $CanvasLayer/campaign_ui

func change_state(state:int):
	match state:
		0:
			spawn_jerald()
			campaign_ui.close()
			campaign_ui.hide()
			main_ui.show()
		1:
			campaign_ui.open()
			campaign_ui.show()
			main_ui.hide()

func spawn_jerald():
	var new_spinning_jerald = load("res://main_menu/assets/spinning_jeralds/spinning_jerald.tscn").instantiate()
	var spawn_range = 100
	new_spinning_jerald.position.y = randi_range(-spawn_range,spawn_range)
	add_child(new_spinning_jerald)

func _on_timer_timeout():
	spawn_jerald()

func _ready():
	spawn_jerald()
	animation.play("idle")
	jerald_animation.play("jumping")
	
	if not DirAccess.dir_exists_absolute(levels_path):
		DirAccess.make_dir_absolute(levels_path)
		print("making levels path")

#HANDLES BUTTONS
func _on_play_pressed():
	change_state(1)
	#get_tree().change_scene_to_file("res://level_loader/main.tscn")

func _on_edit_pressed():
	get_tree().change_scene_to_file("res://level_builder/level_builder.tscn")

func _on_back_pressed():
	change_state(0)

