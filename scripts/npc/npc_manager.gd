extends Node
## Owns every NPC agent and advances them once per TimeSystem tick.

signal npc_added(agent: NpcAgent)
signal npc_removed(agent: NpcAgent)
signal npc_died(agent: NpcAgent)
signal npcs_ticked(tick: int)

## Every spawned NPC gets one instance of each of these.
var systems: Array[GDScript] = [MetabolismSystem]
var behaviors: Array[GDScript] = [SleepBehavior, EatBehavior, WorkBehavior, IdleBehavior]

var _agents: Array[NpcAgent] = []
var _by_id: Dictionary[StringName, NpcAgent] = {}


func _ready() -> void:
	TimeSystem.ticked.connect(_on_ticked)


## The stats every NPC starts with, in display order.
func create_stats() -> Array[NpcStat]:
	return [
		NpcStat.new(NpcAgent.HEALTH, "Health", Color(0.9, 0.3, 0.3)),
		NpcStat.new(NpcAgent.HUNGER, "Hunger", Color(0.55, 0.85, 0.4)),
		NpcStat.new(NpcAgent.ENERGY, "Energy", Color(0.45, 0.65, 1.0)),
	]


func spawn(display_name: String) -> NpcAgent:
	var id := _make_unique_id(display_name)
	var agent := NpcAgent.new(id, display_name)
	for stat in create_stats():
		agent.add_stat(stat)
	for system_script in systems:
		agent.add_system(system_script.new())
	for behavior_script in behaviors:
		agent.brain.add_behavior(behavior_script.new())

	# Randomized so NPCs don't all get tired or hungry at the same moment.
	agent.set_stat(NpcAgent.ENERGY, agent.rng.randf_range(30.0, agent.get_stat_max(NpcAgent.ENERGY)))
	agent.set_stat(NpcAgent.HUNGER, agent.rng.randf_range(40.0, agent.get_stat_max(NpcAgent.HUNGER)))
	agent.add_item(NpcAgent.FOOD, agent.rng.randi_range(1, 3))

	agent.died.connect(npc_died.emit)
	_agents.append(agent)
	_by_id[id] = agent
	npc_added.emit(agent)
	return agent


func remove(id: StringName) -> void:
	var agent: NpcAgent = _by_id.get(id)
	if agent == null:
		return
	_agents.erase(agent)
	_by_id.erase(id)
	npc_removed.emit(agent)


func get_agent(id: StringName) -> NpcAgent:
	return _by_id.get(id)


func get_agents() -> Array[NpcAgent]:
	return _agents.duplicate()


func _on_ticked(tick: int) -> void:
	for agent in _agents:
		agent.tick()
	npcs_ticked.emit(tick)


func _make_unique_id(display_name: String) -> StringName:
	var base := display_name.strip_edges().to_lower().replace(" ", "_")
	var id := base
	var suffix := 2
	while _by_id.has(StringName(id)):
		id = "%s_%d" % [base, suffix]
		suffix += 1
	return StringName(id)
