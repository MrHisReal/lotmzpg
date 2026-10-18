class_name WorkAction
extends NpcAction
## Pays wages in food, but only for a completed shift.

const FOOD_WAGE := 1


func _init(duration: int) -> void:
	display_name = "Working"
	color = Color(1.0, 0.7, 0.3)
	stat_changes_per_tick = { NpcAgent.ENERGY: -1.2 }
	duration_ticks = duration


func exit(agent: NpcAgent, completed: bool) -> void:
	if completed:
		agent.add_item(NpcAgent.FOOD, FOOD_WAGE)
