class_name WorkBehavior
extends NpcBehavior

const NO_FOOD_BONUS := 0.4
## Work is never urgent, so it can't interrupt sleeping or eating.
const MAX_SCORE := 0.95


func _init() -> void:
	id = &"work"


func score(agent: NpcAgent) -> float:
	var energy := agent.get_stat(NpcAgent.ENERGY)
	var desire := remap(energy, SleepBehavior.TIRED_THRESHOLD, agent.get_stat_max(NpcAgent.ENERGY), 0.2, 0.8)
	if agent.get_item_count(NpcAgent.FOOD) <= 0:
		desire += NO_FOOD_BONUS
	return minf(desire, MAX_SCORE)


func create_action(agent: NpcAgent) -> NpcAction:
	return WorkAction.new(agent.rng.randi_range(6, 18))
