class_name EatAction
extends NpcAction
## Consumes one food item up front, then restores hunger over the meal.


func _init() -> void:
	display_name = "Eating"
	color = Color(0.55, 0.85, 0.4)
	stat_changes_per_tick = { NpcAgent.HUNGER: 15.0 }
	duration_ticks = 3
	interruptible = false


func enter(agent: NpcAgent) -> void:
	agent.remove_item(NpcAgent.FOOD, 1)
