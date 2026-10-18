class_name EatBehavior
extends NpcBehavior

const HUNGRY_THRESHOLD := 60.0
const STARVING_THRESHOLD := 15.0
## Above URGENT_SCORE so a starving NPC eats before going to sleep.
const STARVING_SCORE := 1.2


func _init() -> void:
	id = &"eat"


func score(agent: NpcAgent) -> float:
	if agent.get_item_count(NpcAgent.FOOD) <= 0:
		return 0.0
	var hunger := agent.get_stat(NpcAgent.HUNGER)
	if hunger <= STARVING_THRESHOLD:
		return STARVING_SCORE
	if hunger >= HUNGRY_THRESHOLD:
		return 0.0
	return remap(hunger, HUNGRY_THRESHOLD, STARVING_THRESHOLD, 0.2, 0.9)


func create_action(_agent: NpcAgent) -> NpcAction:
	return EatAction.new()
