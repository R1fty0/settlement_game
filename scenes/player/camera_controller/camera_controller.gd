extends Node3D
class_name CameraController

# NOTE:
# Credit: https://www.youtube.com/watch?v=LpmphY0WYFQ
# This script assumes the camera position reference is itself. 

@export var mouse_sens: float = 0.2
@export_category("Speeds")
## How fast the camera move horizontally
@export var move_speed: float = 0.6
## How fast the camera rotates when using the rotate keys 
@export var rotate_keys_speed: float = 1.5
@export var zoom_speed: float = 0.3
@export_category("Zoom Limits")
@export var min_zoom: float = -10.0
@export var max_zoom: float = 30.0
@export_category("References")
@export var rotation_x: Node3D 
@export var camera_zoom_pivot: Node3D 
@export var camera: Camera3D
@export_category("Edge Scrolling")
@export var edge_scrolling_enabled: bool = true
@export var edge_size: float = 5.0
@export var scroll_speed: float = 0.6

var move_target: Vector3
var rotate_keys_target: float
var zoom_target: float 

func _ready() -> void:
	move_target = position
	rotate_keys_target = rotation_degrees.y
	zoom_target = camera.position.z
	camera.look_at(position)
	
func _unhandled_input(event: InputEvent) -> void:
	# Rotate the camera using the mouse.
	if event is InputEventMouseMotion and Input.is_action_pressed("rotate_camera"):
		rotate_keys_target -= event.relative.x * mouse_sens
		rotation_x.rotation_degrees.x -= event.relative.y * mouse_sens
		rotation_x.rotation_degrees.x = clamp(rotation_x.rotation_degrees.x, min_zoom, max_zoom)
	
func _process(delta: float) -> void:
	if edge_scrolling_enabled:
		# Edge scrolling 
		var mouse_pos = get_viewport().get_mouse_position()
		var viewport_size = get_viewport().get_visible_rect().size
		var scroll_direction = Vector3.ZERO
		if mouse_pos.x < edge_size:
			scroll_direction.x = -1
		elif mouse_pos.x > viewport_size.x - edge_size:
			scroll_direction.x = 1
		if mouse_pos.y < edge_size:
			scroll_direction.z = -1
		elif mouse_pos.y > viewport_size.y - edge_size:
			scroll_direction.z = 1
		move_target += transform.basis * scroll_direction * scroll_speed
	# Hide mouse cursor if the player is using the mouse to rotate the camera
	if Input.is_action_just_pressed("rotate_camera"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if Input.is_action_just_released("rotate_camera"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	# Get input direction
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var movement_direction = (transform.basis * Vector3(input_direction.x, 0.0, input_direction.y).normalized())
	var rotate_keys = Input.get_axis("rotate_camera_left", "rotate_camera_right")
	var zoom_direction = (int(Input.is_action_just_released("zoom_camera_out")) - 
						  int(Input.is_action_just_released("zoom_camera_in")))
	# Set movement targets
	move_target += move_speed * movement_direction
	rotate_keys_target += rotate_keys * rotate_keys_speed
	zoom_target += zoom_direction * zoom_speed
	# Lerp movement to target 
	position = lerp(position, move_target, 0.10)
	rotation_degrees.y = lerp(rotation_degrees.y, rotate_keys_target, 0.10)
	camera.position.z = lerp(camera.position.z, zoom_target, 0.10)
