extends CharacterBody3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_player: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var camera: Camera3D = $Camera3D
@onready var default_camera_position: Vector3 = camera.position

@export var invert_x_axis: bool = true
@export var invert_y_axis: bool = true
@export_range(0.1, 50.0, 0.1) var mouse_sensitivity: float = 25.0

const WALK_SPEED: float = 5.0
const SPRINT_SPEED: float = 9.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var mouse_position: Vector2 = Vector2.ZERO
var total_pitch: float = 0.0

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_position = event.relative
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	# We probably don't need jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var sprinting: bool = Input.is_action_pressed("sprint")
	var speed: float = SPRINT_SPEED if sprinting else WALK_SPEED
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		
		if is_on_floor() and not animation_player.is_playing():
			animation_player.play("sprint_bob" if sprinting else "walk_bob")
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	move_and_slide()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return
	
	mouse_position *= mouse_sensitivity * delta
	var yaw: float = mouse_position.x * (-1 if invert_x_axis else 1)
	var pitch: float = mouse_position.y * (-1 if invert_y_axis else 1)
	mouse_position = Vector2.ZERO
	
	pitch = clampf(pitch, -90 - total_pitch, 90 - total_pitch)
	total_pitch += pitch
	
	rotate_y(deg_to_rad(yaw))
	camera.rotate_x(deg_to_rad(pitch))

func _on_current_animation_changed(anim_name: String) -> void:
	print(anim_name)
