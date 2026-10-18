class_name NpcAgent
extends RefCounted

signal action_changed(agent: NpcAgent, action: NpcAction)
signal died(agent: NpcAgent)

const HEALTH := &"health"
const HUNGER := &"hunger"
const ENERGY := &"energy"

const FOOD := &"food"

var id: StringName
var display_name: String
var is_alive := true
var stats: Dictionary[StringName, NpcStat] = {}
var inventory: Dictionary[StringName, int] = {}
var systems: Array[NpcSystem] = []
var brain := NpcBrain.new()
var current_action: NpcAction
## The behavior that produced `current_action`; null for fallback actions.
var current_behavior: NpcBehavior
var rng := RandomNumberGenerator.new()


func _init(p_id: StringName, p_display_name: String) -> void:
	id = p_id
	display_name = p_display_name
	rng.seed = hash(String(p_id))


func tick() -> void:
	if not is_alive:
		return
	for system in systems:
		system.tick(self)
	_update_action()
	current_action.tick(self)
	if has_stat(HEALTH) and get_stat(HEALTH) <= 0.0:
		_die()


#region Stats

func add_stat(stat: NpcStat) -> void:
	stats[stat.id] = stat


func has_stat(stat_id: StringName) -> bool:
	return stats.has(stat_id)


func get_stat(stat_id: StringName) -> float:
	var stat: NpcStat = stats.get(stat_id)
	return stat.value if stat else 0.0


func get_stat_max(stat_id: StringName) -> float:
	var stat: NpcStat = stats.get(stat_id)
	return stat.max_value if stat else 0.0


func set_stat(stat_id: StringName, value: float) -> void:
	var stat: NpcStat = stats.get(stat_id)
	if stat:
		stat.set_value(value)


func change_stat(stat_id: StringName, amount: float) -> void:
	set_stat(stat_id, get_stat(stat_id) + amount)

#endregion


#region Inventory

func get_item_count(item_id: StringName) -> int:
	return inventory.get(item_id, 0)


func add_item(item_id: StringName, amount := 1) -> void:
	inventory[item_id] = get_item_count(item_id) + amount


## Returns false (and removes nothing) if the NPC doesn't have enough.
func remove_item(item_id: StringName, amount := 1) -> bool:
	var count := get_item_count(item_id)
	if count < amount:
		return false
	if count == amount:
		inventory.erase(item_id)
	else:
		inventory[item_id] = count - amount
	return true

#endregion


func add_system(system: NpcSystem) -> void:
	systems.append(system)


func get_status_text() -> String:
	if not is_alive:
		return "Dead"
	if current_action == null:
		return "Idling"
	return current_action.get_status_text(self)


func _update_action() -> void:
	if current_action != null and current_action.is_finished(self):
		_end_action(true)
	if current_action == null:
		_start_behavior(brain.choose(self))
	elif current_action.interruptible:
		var urgent := brain.choose_urgent(self)
		if urgent != null and urgent != current_behavior:
			_end_action(false)
			_start_behavior(urgent)


func _start_behavior(behavior: NpcBehavior) -> void:
	var action: NpcAction = behavior.create_action(self) if behavior else null
	if action == null:
		behavior = null
		action = IdleAction.new(1)
	current_behavior = behavior
	current_action = action
	action.enter(self)
	action_changed.emit(self, action)


func _end_action(completed: bool) -> void:
	current_action.exit(self, completed)
	current_action = null
	current_behavior = null


func _die() -> void:
	is_alive = false
	if current_action != null:
		_end_action(false)
	died.emit(self)
