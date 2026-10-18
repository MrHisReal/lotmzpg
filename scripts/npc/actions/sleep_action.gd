class_name SleepAction
extends NpcAction
## Forced when energy runs low; lasts until the NPC is fully rested.


func _init() -> void:
	display_name = "Sleeping"
	color = Color(0.45, 0.65, 1.0)
	energy_per_tick = 2.5


func is_finished(agent: NpcAgent) -> bool:
	return agent.energy >= NpcAgent.MAX_ENERGY
