class_name NpcStat
extends RefCounted
## A bounded numeric value on an NPC (health, hunger, energy, ...).

var id: StringName
var display_name: String
var color: Color
var max_value: float
var value: float


func _init(p_id: StringName, p_display_name: String, p_color: Color, p_max_value := 100.0) -> void:
	id = p_id
	display_name = p_display_name
	color = p_color
	max_value = p_max_value
	value = p_max_value


func set_value(new_value: float) -> void:
	value = clampf(new_value, 0.0, max_value)
