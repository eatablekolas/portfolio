extends CollisionShape3D

@onready var camera: Camera3D = $Camera3D

@export var invert_x_axis: bool = true
@export var invert_y_axis: bool = true
@export_range(0.0001, 0.1, 0.0001) var mouse_sensitivity: float = 0.01
@export_range(0.0, 90.0, 0.1) var max_up_angle: float = 60
@export_range(0.0, 90.0, 0.1) var max_down_angle: float = 30

var rot_x: float = 0.0
var rot_y: float = 0.0

func _ready() -> void:
	max_up_angle = deg_to_rad(max_up_angle)
	max_down_angle = deg_to_rad(max_down_angle)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return
	
	var mouse_input = Input.get_last_mouse_velocity() * delta * mouse_sensitivity
	var euler_rotation = global_transform.basis.get_euler()
	
	euler_rotation.x += mouse_input.y * (-1 if invert_y_axis else 1)
	euler_rotation.x = clamp(euler_rotation.x, -max_up_angle, max_down_angle)
	
	euler_rotation.y += mouse_input.x * (-1 if invert_x_axis else 1)
	
	camera.global_transform.basis = Basis.from_euler(euler_rotation)
