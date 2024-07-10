extends CharacterBody3D


# exports.
@export var mouse_sensitivity : Vector2 = Vector2(1.0, 1.0)

@export var walk_speed    : float =  4.0
@export var sprint_speed  : float =  7.0
@export var jump_velocity : float =  4.5
@export var acceleration  : float =  5.0
@export var friction      : float = 15.0
@export var air_friction  : float =  1.0
@export var gravity       : float = ProjectSettings.get_setting("physics/3d/default_gravity", 9.8)

@export var breath_max   : float = 12.0
@export var static_start : float =  5.0
@export var static_max   : float =  7.0


# ui.
var window_focus : bool :
	get:
		return get_window().has_focus()


# player.
var current_speed := walk_speed
var phyvel : Vector3 = Vector3.ZERO
var breath_dir : bool = false ## True == IN, False == OUT


func _ready() -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if game.paused:
		return
	
	if event is InputEventMouseMotion:
		%Neck.rotate_y(-event.relative.x * mouse_sensitivity.x / 1000)
		%Camera.rotate_x(-event.relative.y * mouse_sensitivity.y / 1000)
		%Camera.rotation.x = clamp(%Camera.rotation.x, deg_to_rad(-85), deg_to_rad(90))
	else:
		breath_dir = Input.is_action_pressed("breathe")

func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if game.paused:
		return
	
	# handle gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# handle sprint.
	if Input.is_action_pressed("sprintward"):
		current_speed = sprint_speed
	else:
		current_speed = walk_speed
	
	# handle jump.
	if Input.is_action_just_pressed("jumpward") and is_on_floor():
		velocity.y = jump_velocity
	
	var input_dir = Input.get_vector("leftward", "rightward", "forward", "backward")
	var direction = (%Neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = lerp(velocity.x, direction.x * current_speed, acceleration * delta)
		velocity.z = lerp(velocity.z, direction.z * current_speed, acceleration * delta)
	elif is_on_floor():
		velocity.x = lerp(velocity.x, phyvel.x, friction * delta)
		velocity.z = lerp(velocity.z, phyvel.z, friction * delta)
	else:
		velocity.x = lerp(velocity.x, phyvel.x, air_friction * delta)
		velocity.z = lerp(velocity.z, phyvel.z, air_friction * delta)
	
	# print(Vector2(velocity.x, velocity.z).length())
	
	move_and_slide()
