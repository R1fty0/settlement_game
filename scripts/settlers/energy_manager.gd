extends Node
class_name SettlerEnergyManager

signal energy_depleted
signal energy_recharged


@export var max_energy: float = 100
@export var energy_recharge_time: float = 10.0 
@export_category("References")
@export var recharge_timer: Timer
@export var settler_state_machine: StateMachine
@export var settler_energy_recharge_state: SettlerEnergyRecharge

var current_energy: float = 100

func _ready() -> void:
	# Connect timeout signal from recharge timer. 
	if recharge_timer:
		recharge_timer.timeout.connect(_on_recharge_timer_timeout)
	current_energy = max_energy
	recharge_timer.wait_time = energy_recharge_time

func drain_energy(amount: float):
	if current_energy <= 0:
		energy_depleted.emit()
		# Switch to energy recharge state when settler runs out of energy. 
		settler_state_machine._change_state(settler_state_machine.current_state, "EnergyRecharge")
	else:
		current_energy -= amount
		
func start_energy_recharge():
	recharge_timer.start()
	
func _on_recharge_timer_timeout():
	energy_recharged.emit()
	current_energy = max_energy
