class_name NpcAgent
extends RefCounted

signal action_changed(agent: NpcAgent, action: NpcAction)

const MAX_ENERGY := 100.0
const SLEEP_THRESHOLD := 15.0

var id: StringName
var display_name: String
var energy := MAX_ENERGY
var current_action: NpcAction
var rng := RandomNumberGenerator.new()


func _init(p_id: StringName, p_display_name: String, p_energy := MAX_ENERGY) -> void:
	id = p_id
	display_name = p_display_name
	energy = clampf(p_energy, 0.0, MAX_ENERGY)
	rng.seed = hash(String(p_id))


func tick() -> void:
	if current_action == null or current_action.is_finished(self) or _needs_sleep():
		_set_action(_choose_action())
	current_action.tick(self)


func change_energy(amount: float) -> void:
	energy = clampf(energy + amount, 0.0, MAX_ENERGY)


func is_sleeping() -> bool:
	return current_action is SleepAction


func get_status_text() -> String:
	if current_action == null:
		return "Idling"
	return current_action.get_status_text(self)


func _needs_sleep() -> bool:
	return energy <= SLEEP_THRESHOLD and not is_sleeping()


func _choose_action() -> NpcAction:
	if energy <= SLEEP_THRESHOLD:
		return SleepAction.new()
	var work_chance := remap(energy, SLEEP_THRESHOLD, MAX_ENERGY, 0.2, 0.8)
	if rng.randf() < work_chance:
		return WorkAction.new(rng.randi_range(6, 18))
	return IdleAction.new(rng.randi_range(2, 6))


func _set_action(action: NpcAction) -> void:
	current_action = action
	action_changed.emit(self, action)
