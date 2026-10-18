class_name MetabolismSystem
extends NpcSystem
## Hunger drains over time. A starving NPC (0 hunger) loses health; a well-fed one slowly heals.

const HUNGER_PER_TICK := -0.7
const STARVATION_DAMAGE_PER_TICK := -0.5
const WELL_FED_THRESHOLD := 50.0
const HEALING_PER_TICK := 0.1


func tick(agent: NpcAgent) -> void:
	agent.change_stat(NpcAgent.HUNGER, HUNGER_PER_TICK)
	var hunger := agent.get_stat(NpcAgent.HUNGER)
	if hunger <= 0.0:
		agent.change_stat(NpcAgent.HEALTH, STARVATION_DAMAGE_PER_TICK)
	elif hunger >= WELL_FED_THRESHOLD:
		agent.change_stat(NpcAgent.HEALTH, HEALING_PER_TICK)
