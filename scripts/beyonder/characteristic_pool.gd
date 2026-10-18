extends Node
## World-wide registry of every Beyonder characteristic in existence.
##
## Characteristics follow the Law of Conservation: the pool is generated once from a
## fixed seed and is never added to or removed from. Characteristics only move between
## being free in the world, held by a Beyonder, or sealed in an artifact.

signal characteristic_claimed(characteristic: BeyonderCharacteristic, holder_id: StringName)
signal characteristic_released(characteristic: BeyonderCharacteristic)
signal characteristic_sealed(characteristic: BeyonderCharacteristic)

const POOL_SEED := 0x4C4F544D

## Number of characteristics that exist per pathway and sequence.
const POOL_SIZES := {
	&"fool": {9: 40, 8: 20, 7: 10, 6: 5, 5: 3},
}

const ORIGINS: Array[String] = [
	"Tingen City",
	"Backlund",
	"Bayam",
	"Pritz Harbor",
	"Lenburg",
	"Feysac",
	"Intis",
	"Sonia Sea",
	"Berserk Sea",
	"Southern Continent",
]

var _by_id: Dictionary[StringName, BeyonderCharacteristic] = {}
var _by_slot: Dictionary[String, Array] = {}


func _ready() -> void:
	reset()


## Rebuilds the pool from the fixed seed, discarding all ownership state.
func reset() -> void:
	_by_id.clear()
	_by_slot.clear()
	for pathway_id: StringName in POOL_SIZES:
		var sizes: Dictionary = POOL_SIZES[pathway_id]
		for sequence: int in sizes:
			_generate_slot(pathway_id, sequence, sizes[sequence])


func get_characteristic(characteristic_id: StringName) -> BeyonderCharacteristic:
	return _by_id.get(characteristic_id)


func get_all(pathway_id: StringName, sequence: int) -> Array[BeyonderCharacteristic]:
	var result: Array[BeyonderCharacteristic] = []
	result.assign(_by_slot.get(_slot_key(pathway_id, sequence), []))
	return result


func get_free(pathway_id: StringName, sequence: int) -> Array[BeyonderCharacteristic]:
	var result: Array[BeyonderCharacteristic] = []
	result.assign(get_all(pathway_id, sequence).filter(
		func(c: BeyonderCharacteristic) -> bool: return c.is_free()))
	return result


func get_held_by(holder_id: StringName) -> Array[BeyonderCharacteristic]:
	var result: Array[BeyonderCharacteristic] = []
	for characteristic: BeyonderCharacteristic in _by_id.values():
		if characteristic.state == BeyonderCharacteristic.State.HELD and characteristic.holder_id == holder_id:
			result.append(characteristic)
	return result


func count_total(pathway_id: StringName, sequence: int) -> int:
	return get_all(pathway_id, sequence).size()


func count_free(pathway_id: StringName, sequence: int) -> int:
	return get_free(pathway_id, sequence).size()


## Gives a specific free characteristic to a Beyonder. Returns false if it is unavailable.
func claim(characteristic_id: StringName, holder_id: StringName) -> bool:
	var characteristic := get_characteristic(characteristic_id)
	if characteristic == null or not characteristic.is_free():
		return false
	characteristic.state = BeyonderCharacteristic.State.HELD
	characteristic.holder_id = holder_id
	characteristic.location = ""
	characteristic_claimed.emit(characteristic, holder_id)
	return true


## Gives the first free characteristic of a slot to a Beyonder, or null if the slot is exhausted.
func claim_any(pathway_id: StringName, sequence: int, holder_id: StringName) -> BeyonderCharacteristic:
	var free := get_free(pathway_id, sequence)
	if free.is_empty():
		return null
	var characteristic: BeyonderCharacteristic = free[0]
	claim(characteristic.id, holder_id)
	return characteristic


## Returns a characteristic to the world, e.g. when its holder dies or loses control.
func release(characteristic_id: StringName, location := "") -> bool:
	var characteristic := get_characteristic(characteristic_id)
	if characteristic == null or characteristic.is_free():
		return false
	characteristic.state = BeyonderCharacteristic.State.FREE
	characteristic.holder_id = &""
	characteristic.location = location
	characteristic_released.emit(characteristic)
	return true


## Releases every characteristic a Beyonder holds, leaving them at `location`.
func release_all_held_by(holder_id: StringName, location := "") -> Array[BeyonderCharacteristic]:
	var released := get_held_by(holder_id)
	for characteristic in released:
		release(characteristic.id, location)
	return released


func seal(characteristic_id: StringName, artifact_id: StringName) -> bool:
	var characteristic := get_characteristic(characteristic_id)
	if characteristic == null or characteristic.state == BeyonderCharacteristic.State.SEALED:
		return false
	characteristic.state = BeyonderCharacteristic.State.SEALED
	characteristic.holder_id = artifact_id
	characteristic_sealed.emit(characteristic)
	return true


func to_save_data() -> Array[Dictionary]:
	var data: Array[Dictionary] = []
	for characteristic: BeyonderCharacteristic in _by_id.values():
		data.append(characteristic.to_dict())
	return data


## Restores ownership state on top of the fixed pool. Unknown ids are ignored so that
## saves cannot create characteristics out of nothing.
func load_save_data(data: Array) -> void:
	reset()
	for entry: Dictionary in data:
		var saved := BeyonderCharacteristic.from_dict(entry)
		var characteristic := get_characteristic(saved.id)
		if characteristic == null:
			push_warning("Ignoring unknown characteristic in save data: %s" % saved.id)
			continue
		characteristic.state = saved.state
		characteristic.holder_id = saved.holder_id
		characteristic.location = saved.location


func _generate_slot(pathway_id: StringName, sequence: int, count: int) -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = POOL_SEED ^ hash("%s:%d" % [pathway_id, sequence])
	var slot: Array[BeyonderCharacteristic] = []
	for i in count:
		var characteristic := BeyonderCharacteristic.new()
		characteristic.id = StringName("%s_s%d_%03d" % [pathway_id, sequence, i + 1])
		characteristic.pathway_id = pathway_id
		characteristic.sequence = sequence
		characteristic.origin = ORIGINS[rng.randi_range(0, ORIGINS.size() - 1)]
		characteristic.location = characteristic.origin
		slot.append(characteristic)
		_by_id[characteristic.id] = characteristic
	_by_slot[_slot_key(pathway_id, sequence)] = slot


func _slot_key(pathway_id: StringName, sequence: int) -> String:
	return "%s:%d" % [pathway_id, sequence]
