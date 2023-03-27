extends LineEdit

func register(_value:String, _name:String):
	placeholder_text = _name
	text = _value

func get_val():
	return [text, placeholder_text]
