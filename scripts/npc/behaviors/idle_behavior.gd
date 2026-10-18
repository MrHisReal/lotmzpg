class_name IdleBehavior
extends NpcBehavior


func _init() -> void:
	id = &"idle"


func score(agent: NpcAgent) -> float:
	var energy := agent.get_stat(NpcAgent.ENERGY)
	return remap(energy, SleepBehavior.TIRED_THRESHOLD, agent.get_stat_max(NpcAgent.ENERGY), 0.8, 0.2)


func create_action(agent: NpcAgent) -> NpcAction:
	return IdleAction.new(agent.rng.randi_range(2, 6))
