class_name NpcBehavior
extends RefCounted
## One decision an NPC can make. To add a decision, extend this, override `score` and
## `create_action`, and register it in NpcManager.behaviors (or `agent.brain.add_behavior`).

var id: StringName


## How much the NPC wants to do this right now. 0 means never; NpcBrain.URGENT_SCORE or
## higher means "drop everything and do this".
func score(_agent: NpcAgent) -> float:
	return 0.0


func create_action(_agent: NpcAgent) -> NpcAction:
	return null
