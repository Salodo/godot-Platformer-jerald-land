extends Control

var campaighn_lvl_path = "res://campaighn_levels/"

var levels = DirAccess.get_files_at(campaighn_lvl_path)
var levels_dat:Array = []

var max_levels = levels.size()
var current_index = 0

@onready var title = $outline/inline/title

@onready var left_arrow = $outline/inline/left
@onready var right_arrow = $outline/inline/right
@onready var completed_icon = $outline/inline/completed
@onready var stats_menu = $outline/inline/stats_menu

func _ready():
	for i in levels:
		var tmp_path = campaighn_lvl_path+i
		var file = FileAccess.open(tmp_path, FileAccess.READ)
		var dat = file.get_var()
		levels_dat.append(dat)
		file = null

func open():
	update()
	self.show()

func close():
	current_index = 0
	self.hide()

func update():
	title.text = levels_dat[current_index]["t"]
	if Bigscripts.load_stats(levels_dat[current_index]["t"]).has("completions"):
		completed_icon.show()
	else:
		completed_icon.hide()
	
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
	Bigscripts.change_map(levels_dat[current_index], true)
	get_tree().change_scene_to_file("res://level_loader/main.tscn")


func _on_info_pressed():
	stats_menu.open(levels_dat[current_index]["t"])

#STATS
func _on_close_pressed():
	stats_menu.close()
