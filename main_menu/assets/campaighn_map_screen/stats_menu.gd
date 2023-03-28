extends Control

@onready var stats_label = $outline/inline/stats

func open(stat_name:String):
	var stats = Bigscripts.load_stats(stat_name)
	var display_text = ""
	if stats.has("deaths"):
		display_text += "Deaths : "+str(stats["deaths"])
	else:
		display_text += "Deaths : "+"0"
	
	display_text += "\n"
	
	if stats.has("jumps"):
		display_text += "Jumps : "+str(stats["jumps"])
	else:
		display_text += "Jumps : "+"0"
	
	stats_label.text = display_text
	
	show()

func close():
	hide()
