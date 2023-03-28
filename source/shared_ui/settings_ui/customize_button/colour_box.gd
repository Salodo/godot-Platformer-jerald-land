extends TextureButton

@onready var selector = $selector

var cl = ""

func register_colour(color:String):
	self_modulate = Color(color)
	cl = color
	Bigscripts.connect("color_changed", self.update)

func update():
	if cl == Bigscripts.settings["customization"]["color"]:
		selector.show()
	else:
		selector.hide()

func _on_pressed():
	Bigscripts.change_color(cl)
	
