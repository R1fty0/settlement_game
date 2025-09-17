extends State
class_name SettlerMove

@export var speed: float = 2.0
@export var npc: NPC

func _ready() -> void:
	npc.speed = speed
