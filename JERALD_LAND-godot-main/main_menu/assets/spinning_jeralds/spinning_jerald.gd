extends Node2D

var spinning_speed:int = 2
var speed:int = 500

@onready var jerald = $JeraldSpinning

func randomize_jerald():
	var scale_factor = randi_range(5,10)
	jerald.scale = Vector2(scale_factor,scale_factor)
	
func calculate_based_on_size():
	spinning_speed = (1/jerald.scale.x)*50
	speed = (1/jerald.scale.x)*5000

func _ready():
	randomize_jerald()
	calculate_based_on_size()

func _process(delta):
	calculate_based_on_size()
	
	jerald.position.x += speed*delta
	jerald.rotate(delta*spinning_speed)
	
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()

var was_on_screen = false
func _on_visible_on_screen_notifier_2d_screen_exited():
	if was_on_screen == true:
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_entered():
	was_on_screen = true
