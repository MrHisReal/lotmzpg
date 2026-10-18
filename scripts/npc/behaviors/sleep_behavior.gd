class_name SleepBehavior
extends NpcBehavior

const TIRED_THRESHOLD := 15.0


func _init() -> void:
	id = &"sleep"


func score(agent: NpcAgent) -> float:
	if agent.get_stat(NpcAgent.ENERGY) <= TIRED_THRESHOLD:
		return NpcBrain.URGENT_SCORE
	return 0.0


func create_action(_agent: NpcAgent) -> NpcAction:
	return SleepAction.new()
