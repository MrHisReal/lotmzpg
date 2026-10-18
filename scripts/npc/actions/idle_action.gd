class_name IdleAction
extends NpcAction


func _init(duration: int) -> void:
	display_name = "Idling"
	color = Color(0.75, 0.75, 0.75)
	energy_per_tick = -0.4
	duration_ticks = duration
