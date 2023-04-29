extends Node2D

@onready var animation = $CanvasLayer/main_ui/animation
@onready var jerald_animation = $jerald_animation

@onready var main_ui = $CanvasLayer/main_ui
@onready var campaign_ui = $CanvasLayer/campaign_ui
@onready var settings_ui = $CanvasLayer/settings_ui
@onready var custom_level_ui = $CanvasLayer/custom_level_ui

func change_state(state:int):
	match state:
		0:
			spawn_jerald()
			campaign_ui.close()
			settings_ui.close()
			custom_level_ui.close()
			main_ui.show()
		1:
			campaign_ui.open()
			main_ui.hide()
		2:
			settings_ui.open()
			main_ui.hide()
		3:
			main_ui.hide()
			custom_level_ui.open()

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
	
	settings_ui.connect("_on_settings_ui_close", self._on_back_pressed)
	Bigscripts.connect("color_changed", self.update_color)
	update_color()

func update_color():
	Bigscripts.customize([main_ui,campaign_ui,custom_level_ui])
	


#HANDLES BUTTONS
func _on_play_pressed():
	Bigscripts.editor_mode = false
	change_state(1)

func _on_editor_pressed():
	change_state(3)
	#Bigscripts.editor_mode = true
	#get_tree().change_scene_to_file("res://level_builder/level_builder.tscn")

func _on_settings_pressed():
	change_state(2)

func _on_back_pressed():
	change_state(0)

