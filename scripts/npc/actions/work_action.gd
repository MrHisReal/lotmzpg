class_name WorkAction
extends NpcAction


func _init(duration: int) -> void:
	display_name = "Working"
	color = Color(1.0, 0.7, 0.3)
	energy_per_tick = -1.2
	duration_ticks = duration
