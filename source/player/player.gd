extends CharacterBody2D


const SPEED:int = 100
const JUMP_VELOCITY:int = -200
const gravity:int = 900
const death_layer:int = 1000

var after_jump:bool = false
var was_on_ground_last_frame:bool = true
var in_ui:bool = false

var bounce_factor:float = 90
var jump_on_ground:int = 0

var on_air_velocity:Vector2 = Vector2(0,0);

@onready var default_ui = $CanvasLayer/ui
@onready var win_ui = $CanvasLayer/wim_ui
@onready var pause_ui = $CanvasLayer/pause_ui

@onready var after_timer = $jump_timer
@onready var edit = $CanvasLayer/ui/edit
@onready var texture = $Jerald

func _ready():
	global_position = Bigscripts.spawn_pos
	if Bigscripts.editor_mode == true:
		default_ui.show()
	else:
		default_ui.hide()
	
	pause_ui.connect("_on_pause_ui_close", self._on_pause_ui_close)
	
func _on_pause_ui_close():
	pause_ui.close()
	in_ui = false

func jump():
	Bigscripts.increase_stat("jumps")
	velocity.y = JUMP_VELOCITY

func _physics_process(delta):
	if in_ui:return
	#GRAFITY
	if not is_on_floor():
		on_air_velocity = velocity
		velocity.y += gravity * delta
		if global_position.y > death_layer:
			damage(999)
	
	#JUMP FRAMES
	if is_on_floor():
		if jump_on_ground >= 1:
			velocity.y = -on_air_velocity.y*(bounce_factor/100)
			if velocity.y <= 20 and velocity.y >= -20:
				velocity.y = 0
			on_air_velocity = Vector2(0,0);
		else:
			on_air_velocity = Vector2(0,0)
			
		was_on_ground_last_frame = true
	elif was_on_ground_last_frame:
		was_on_ground_last_frame = false
		after_jump = true
		after_timer.start()
	
	#PAUSE
	if Input.is_action_just_pressed("escape"):
		pause_ui.open()
	
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

func _input(_event):
	if Input.is_action_just_pressed("reset"):
		kill()

func _on_jump_timer_timeout():
	after_jump = false

func kill(force_restart:bool = false):
	if Bigscripts.has_map_changed() or force_restart:
		if force_restart:
			Bigscripts.spawn_pos = Bigscripts.default_spawn_pos
		get_tree().reload_current_scene()
	else:
		global_position = Bigscripts.spawn_pos
		velocity = Vector2(0,0)
	
	Bigscripts.increase_stat("deaths")

func damage(amount):
	if amount > 0:
		kill()

func win():
	win_ui.show()
	Bigscripts.increase_stat("completions")
	in_ui = true

#func _on_button_pressed():
#	import.release_focus()
#	Bigscripts.change_map((JSON.parse_string(DisplayServer.clipboard_get())))

func _on_edit_pressed():
	edit.release_focus()
	Bigscripts.editor_load_map = true
	Bigscripts.spawn_pos = Vector2(0,0)
	get_tree().change_scene_to_file("res://level_builder/level_builder.tscn")

#WIN UI
func _on_restart_pressed():
	kill(true)

func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")
