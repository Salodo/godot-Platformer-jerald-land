extends Node

var spawn_pos:Vector2 = Vector2(0,0)

#t = title
#d = description
#m = map

var map_data:Dictionary = {
		"t":"COOL MAP",
		"d":"MADE BY SALPO",
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

func grab_map(folder):
	var map_dict:Dictionary = {}
	
	#t = title
	#d = description
	#m = map
	
	map_dict["t"] = "demo"
	map_dict["d"] = ""
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
