extends Area3D

@export var mesh: MeshInstance3D
@export var outline_material: Material

func _on_mouse_entered() -> void:
	mesh.material_overlay = outline_material

func _on_mouse_exited() -> void:
	mesh.material_overlay = null
