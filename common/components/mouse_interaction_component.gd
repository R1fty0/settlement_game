extends Area3D
class_name MouseInteractionComponent

# NOTE: All meshes that use this component require a weighted normals modifier in Blender. 
# Credit: https://www.youtube.com/watch?v=CG0TMH8D8kY

@export var mesh: MeshInstance3D
@export var outline_material: Material
@export var selection_material: Material
@export var collision_body: CollisionObject3D

var selected: bool = false

func _ready() -> void:
	# Connect relevant signals. 
	if collision_body:
		collision_body.mouse_entered.connect(_on_mouse_entered)
		collision_body.mouse_exited.connect(_on_mouse_exited)
		collision_body.input_event.connect(_on_input_event)
	else:
		push_error("Missing collision body for outline component: " + str(name))

func _on_mouse_entered() -> void:
	# Enable the hover outline. 
	if not selected:
		mesh.material_overlay = outline_material

func _on_mouse_exited() -> void:
	# Disable the hover outline. 
	if not selected:
		mesh.material_overlay = null

func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	# Select/Deselect Object Outline 
	if event.is_action_pressed("left_mouse_button"):
		selected = not selected
		if selected:
			mesh.material_overlay = selection_material
		else:
			mesh.material_overlay = outline_material
