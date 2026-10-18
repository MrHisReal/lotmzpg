class_name SleepAction
extends NpcAction
## Lasts until the NPC is fully rested.


func _init() -> void:
	display_name = "Sleeping"
	color = Color(0.45, 0.65, 1.0)
	stat_changes_per_tick = { NpcAgent.ENERGY: 2.5 }


func is_finished(agent: NpcAgent) -> bool:
	return agent.get_stat(NpcAgent.ENERGY) >= agent.get_stat_max(NpcAgent.ENERGY)
