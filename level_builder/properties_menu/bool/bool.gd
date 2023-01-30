extends CheckBox

func register(value:bool, _name:String):
	text = _name
	button_pressed = value

func get_val():
	return [button_pressed, text]
