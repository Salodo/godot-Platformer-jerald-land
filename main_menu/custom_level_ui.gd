extends Control

var levels_path = Bigscripts.levels_path
@onready var main_container = $outline/inline/ScrollContainer/VBoxContainer
@onready var world_name_popup = $outline/inline/world_name_popup
@onready var confirmation_popup = $outline/inline/confirmation

func _ready():
	world_name_popup.connect("make_world", self.make_world)
	confirmation_popup.connect("_delete_world", self.delete_world)

func open():
	self.show()
	load_worlds()

func close():
	self.hide()

func clear():
	for i in main_container.get_children():
		i.queue_free()

func load_worlds():
	clear()
	
	var levels = DirAccess.get_files_at(levels_path)
	for i in levels:
		var level_path = levels_path+"/"+i
		
		var new_world_option = load("res://main_menu/assets/level_selector_screen/world_preset/world_1.tscn").instantiate()
		new_world_option.change_destination(level_path)
		new_world_option.connect("reload_map_screen", self.load_worlds)
		new_world_option.connect("delete_world", self.delete_world)
		
		main_container.add_child(new_world_option)
		
	var new_add_level_button = load("res://main_menu/assets/level_selector_screen/add_level/add_level.tscn").instantiate()
	
	new_add_level_button.connect("_add_level_button_pressed", self._add_level_button_pressed)
	main_container.add_child(new_add_level_button)

func _add_level_button_pressed():
	world_name_popup.open()

func make_world(_name:String):
	var _path = Bigscripts.levels_path+"/"+_name+".dat"
	var map_dat = {
		"t":_name,
		"s":[0,0],
		"m":[]
		}
	
	var file = FileAccess.open(_path, FileAccess.WRITE)
	file.store_var(map_dat)
	file = null
	
	load_worlds()

func delete_world(_path:String,ask=true):
	if ask:
		confirmation_popup.open(_path)
	else:
		DirAccess.remove_absolute(_path)
		load_worlds()
