extends Node

var default_spawn_pos:Vector2 = Vector2(0,0)
var spawn_pos:Vector2 = Vector2(0,0)

var campaign_stats:Dictionary = {}
var is_in_campaign_map:bool = false

#t = title
#d = description
#m = map
#s = spawnpoint
var map_data:Dictionary = {
		"t":"Default Map",
		"s":[0,0],
		"m":
		[{"p":[0,5],"i":"0"},#BLOCKS
		{"p":[1,5],"i":"0"},
		{"p":[2,5],"i":"0"},
		{"p":[3,5],"i":"0"},
		{"p":[4,5],"i":"0"},
		{"p":[5,5],"i":"0"},
		{"p":[6,5],"i":"0"},
		
		{"p":[4,4],"i":"1"},#SPIKES
		{"p":[5,4],"i":"1"},
		]
		}

var editor_load_map:bool = true

var block_id_to_scene:Dictionary = {
	"0":"res://source/block_scenes/default_block/block.tscn",
	"1":"res://source/block_scenes/spike/block.tscn",
	"2":"res://source/block_scenes/checkpoint/block.tscn",
	"3":"res://source/block_scenes/jump_pad/block.tscn",
	"4":"res://source/block_scenes/text_block/block.tscn",
}

var editor_mode:bool = false
var map_change:bool = false

const path:String = "user://"
const levels_path:String = path+"levels"
const campaign_stats_path:String = path+"campaign_stats"
const settings_path:String = path+"settings.dat"

var loaded_level_path:String

var settings:Dictionary = {
	"keybinds":{
		"left":InputMap.action_get_events("left")[0],
		"right":InputMap.action_get_events("right")[0],
		"jump":InputMap.action_get_events("jump")[0],
	},
	"customization":{
		"color":"ffffff"
	},
}

"ffff40"
#CUSTOMIZATION related

signal color_changed

func customize(nodes:Array = []):
	for i in nodes:
		i.modulate = Color(settings["customization"]["color"])

func change_color(color:String):
	settings["customization"]["color"] = color
	save_settings()
	emit_signal("color_changed")

#SAVING related


func _ready():
	
	if not DirAccess.dir_exists_absolute(levels_path):
		print("making levels path")
		DirAccess.make_dir_absolute(levels_path)
		
		var file = FileAccess.open(levels_path+"/level.dat", FileAccess.WRITE)
		file.store_var(Bigscripts.map_data, true)
		file = null
		
	if not FileAccess.file_exists(settings_path):
		print("making settings file")
		save_settings()
	else:
		load_settings()
		
	if not DirAccess.dir_exists_absolute(campaign_stats_path):
		print("making campaighn stats file")
		DirAccess.make_dir_absolute(campaign_stats_path)


func save_map():
	var file = FileAccess.open(loaded_level_path, FileAccess.WRITE)
	file.store_var(map_data)
	file = null

#STATS
func increase_stat(stat_name:String, amount:int=1):
	if is_in_campaign_map:
		if campaign_stats.has(stat_name):
			campaign_stats[stat_name] += amount
		else:
			campaign_stats[stat_name] = amount
		
		save_stats(map_data["t"], campaign_stats)
		return

func save_stats(_name:String, dat:Dictionary):
	
	var _path = campaign_stats_path+"/"+_name+".dat"
	var file = FileAccess.open(_path, FileAccess.WRITE)
	file.store_var(dat)
	file = null

func load_stats(_name:String):
	var _path = campaign_stats_path+"/"+_name+".dat"
	if FileAccess.file_exists(_path):
		var file = FileAccess.open(_path, FileAccess.READ)
		var dat = file.get_var()
		file = null
		return dat
	else:
		save_stats(_name, {})
		return {}

func save_settings():
	var file = FileAccess.open(settings_path, FileAccess.WRITE)
	file.store_var(settings, true)
	file = null

func load_settings():
	var file = FileAccess.open(settings_path, FileAccess.READ)
	settings = file.get_var(true)
	file = null
	
	for keybind in settings["keybinds"]:
		InputMap.action_erase_events(keybind)
		InputMap.action_add_event(keybind, settings["keybinds"][keybind])

#MAP RELATED

func grab_map(folder, spawn=Vector2(0,0)):
	var map_dict:Dictionary = {}
	
	#t = title
	#m = map
	#s = spawn_pos
	
	map_dict["t"] = map_data["t"]
	map_dict["s"] = [spawn.x,spawn.y]
	map_dict["m"] = []
	
	for child in folder.get_children():
		var child_dat = child.get_dat()
		map_dict["m"].append(child_dat)
	
	#COMPRESS
	var compressed_map:String = ""
	var quotes_open = false
	for i in str(map_dict):
		if i == '"':
			if quotes_open:quotes_open=false
			elif not quotes_open:quotes_open=true
		
		if not quotes_open and i == " ":
			continue
		
		compressed_map += i
	
	return compressed_map

func load_map(map_code:Array,folder:Node2D):
	for block_dat in map_code:
		var new_block = load(block_id_to_scene[str(block_dat["i"])]).instantiate()
		new_block.set_dat(block_dat)
		
		folder.add_child(new_block)

func change_map(data:Dictionary, canpaign_map:bool = false):
	is_in_campaign_map = canpaign_map
	if canpaign_map:
		campaign_stats = load_stats(data["t"])
	
	
	map_data = data
	spawn_pos = Vector2(data["s"][0],data["s"][1])*16
	default_spawn_pos = spawn_pos
	map_change = true

func has_map_changed():
	if map_change:
		map_change = false
		return true
	return false
