extends SpinBox

func register(_value:int, _name:String):
	prefix = _name
	value = _value

func get_val():
	return [int(value), prefix]
