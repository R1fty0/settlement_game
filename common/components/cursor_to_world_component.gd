extends Node
class_name CursorToWorldComponent

@export var interaction_component: InteractionComponent
var listen: bool = false 

func _ready() -> void:
	if interaction_component:
		interaction_component.selected.connect(_on_selected)
		interaction_component.unselected.connect(_on_deselected)
		
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("left_mouse_button") and listen == true:
		# Shoot ray into world
		# Figure out if the ray hit a vaild surface for settler pathfinding 
		# Get that position if the ray hit a vaild surface
		# Send that over to the state machine, switch the state to move. 
		pass

func _on_selected():
	listen = true
	
func _on_deselected():
	listen = false
