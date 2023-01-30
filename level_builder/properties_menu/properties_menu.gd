extends VBoxContainer

@onready var items_container = get_node("items_container")
@onready var title = get_node("title")

var selected_node = null

func _ready():
	close()

func clear():
	for i in items_container.get_children():
		i.queue_free()

func make_property(value, _name:String):
	match typeof(value):
		2:
			var new_int_node = load("res://level_builder/properties_menu/int/int.tscn").instantiate()
			new_int_node.register(value, _name)
			items_container.add_child(new_int_node)
		4:
			var new_string_node = load("res://level_builder/properties_menu/string/string.tscn").instantiate()
			new_string_node.register(value, _name)
			items_container.add_child(new_string_node)
		1:
			var new_bool_node = load("res://level_builder/properties_menu/bool/bool.tscn").instantiate()
			new_bool_node.register(value, _name)
			items_container.add_child(new_bool_node)

func get_properties():
	var block_dat = {}
	for i in items_container.get_children():
		var setting = i.get_val()
		block_dat[setting[1]] = setting[0]
	return block_dat

func register_menu(dat:Dictionary, name:String, _selected_node):
	open()
	selected_node = _selected_node
	title.register_text(name)
	clear()
	for i in dat:
		print(typeof(dat[i]))
		make_property(dat[i], i)

func _on_button_pressed():
	if selected_node:
		selected_node.block_dat = get_properties()
	close()

func close():
	selected_node = null
	hide()

func open():
	show()
