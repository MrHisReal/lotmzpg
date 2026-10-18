class_name IdleAction
extends NpcAction


func _init(duration: int) -> void:
	display_name = "Idling"
	color = Color(0.75, 0.75, 0.75)
	stat_changes_per_tick = { NpcAgent.ENERGY: -0.4 }
	duration_ticks = duration
