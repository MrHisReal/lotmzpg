extends Node
## Owns every NPC agent and advances them once per TimeSystem tick.

signal npc_added(agent: NpcAgent)
signal npc_removed(agent: NpcAgent)
signal npcs_ticked(tick: int)

var _agents: Array[NpcAgent] = []
var _by_id: Dictionary[StringName, NpcAgent] = {}


func _ready() -> void:
	TimeSystem.ticked.connect(_on_ticked)


## Creates an NPC. A negative `energy` picks a random starting value so NPCs don't all
## get tired at the same moment.
func spawn(display_name: String, energy := -1.0) -> NpcAgent:
	var id := _make_unique_id(display_name)
	var agent := NpcAgent.new(id, display_name)
	agent.energy = energy if energy >= 0.0 else agent.rng.randf_range(30.0, NpcAgent.MAX_ENERGY)
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
