class_name NpcAction
extends RefCounted
## Something an NPC spends ticks doing. A new instance is created each time an action starts.

var display_name := "Idling"
var color := Color.WHITE
## Applied to the agent's stats every tick, e.g. `{ NpcAgent.ENERGY: -1.0 }`.
var stat_changes_per_tick: Dictionary[StringName, float] = {}
## How many ticks the action lasts. 0 means it runs until `is_finished` says otherwise.
var duration_ticks := 0
## Whether an urgent behavior (see NpcBrain.URGENT_SCORE) may cut this action short.
var interruptible := true
var ticks_elapsed := 0


func enter(_agent: NpcAgent) -> void:
	pass


## `completed` is false when the action was interrupted or the NPC died.
func exit(_agent: NpcAgent, _completed: bool) -> void:
	pass


func tick(agent: NpcAgent) -> void:
	ticks_elapsed += 1
	for stat_id in stat_changes_per_tick:
		agent.change_stat(stat_id, stat_changes_per_tick[stat_id])


func is_finished(_agent: NpcAgent) -> bool:
	return duration_ticks > 0 and ticks_elapsed >= duration_ticks


func get_status_text(_agent: NpcAgent) -> String:
	return display_name
