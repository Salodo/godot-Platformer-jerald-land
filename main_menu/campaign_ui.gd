extends Control

var max_levels = CampaighnMaps.campaighn_maps.size()
var current_index = 0

@onready var title = $outline/inline/title

@onready var left_arrow = $outline/inline/left
@onready var right_arrow = $outline/inline/right

func open():
	update()

func close():
	current_index = 0

func update():
	title.text = CampaighnMaps.campaighn_maps[current_index]["t"]
	
	left_arrow.show()
	right_arrow.show()
	if current_index == 0:
		left_arrow.hide()
	elif current_index == max_levels-1:
		right_arrow.hide()
	
func _on_right_pressed():
	current_index += 1
	if current_index >= max_levels:
		current_index = max_levels - 1
	
	update()

func _on_left_pressed():
	current_index -= 1
	if current_index < 0:
		current_index = 0
	
	update()

func _on_play_pressed():
	Bigscripts.change_map(CampaighnMaps.campaighn_maps[current_index])
	get_tree().change_scene_to_file("res://level_loader/main.tscn")
