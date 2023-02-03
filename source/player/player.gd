extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -200.0
const gravity = 900
const death_layer = 1000

var after_jump = false
var was_on_ground_last_frame = true

@onready var after_timer = $jump_timer
@onready var import = $CanvasLayer/Control/import
@onready var edit = $CanvasLayer/Control/edit
@onready var texture = $Jerald

func _ready():
	global_position = Bigscripts.spawn_pos
	$CanvasLayer.show()

func jump():
	velocity.y = JUMP_VELOCITY

func _physics_process(delta):
	#GRAFITY
	if not is_on_floor():
		velocity.y += gravity * delta
		if global_position.y > death_layer:
			damage(999)
	
	#JUMP FRAMES
	if is_on_floor():
		was_on_ground_last_frame = true
	elif was_on_ground_last_frame:
		was_on_ground_last_frame = false
		after_jump = true
		after_timer.start()
	
	#JUMP
	if Input.is_action_just_pressed("jump"):
		if is_on_floor() or after_jump:
			jump()
			after_jump = false
			
		
	#MOVE
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if direction==1:texture.scale.x = abs(texture.scale.x)
	else:texture.scale.x = -abs(texture.scale.x)
	
	if (direction*direction):
		texture.play("walk")
	else:
		texture.play("idle")

	move_and_slide()

func _input(event):
	if Input.is_action_just_pressed("reset"):
		kill()

func _on_jump_timer_timeout():
	after_jump = false

func kill():
	if Bigscripts.has_map_changed():
		get_tree().reload_current_scene()
	else:
		global_position = Bigscripts.spawn_pos
		velocity = Vector2(0,0)

func damage(amount):
	if amount > 0:
		kill()

func _on_button_pressed():
	import.release_focus()
	Bigscripts.change_map((JSON.parse_string(DisplayServer.clipboard_get())))

func _on_edit_pressed():
	edit.release_focus()
	Bigscripts.editor_load_map = true
	Bigscripts.spawn_pos = Vector2(0,0)
	get_tree().change_scene_to_file("res://level_builder/level_builder.tscn")
