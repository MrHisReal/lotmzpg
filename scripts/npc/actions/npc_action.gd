class_name NpcAction
extends RefCounted
## Something an NPC spends ticks doing. A new instance is created each time an action starts.

var display_name := "Idling"
var color := Color.WHITE
var energy_per_tick := 0.0
## How many ticks the action lasts. 0 means it runs until `is_finished` says otherwise.
var duration_ticks := 0
var ticks_elapsed := 0


func tick(agent: NpcAgent) -> void:
	ticks_elapsed += 1
	agent.change_energy(energy_per_tick)


func is_finished(_agent: NpcAgent) -> bool:
	return duration_ticks > 0 and ticks_elapsed >= duration_ticks


func get_status_text(_agent: NpcAgent) -> String:
	return display_name
