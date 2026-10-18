class_name BeyonderCharacteristic
extends RefCounted

enum State {
	## Lying in the world (a corpse, an ingredient, a lost item) waiting to be found.
	FREE,
	## Absorbed by a Beyonder through a potion.
	HELD,
	## Locked inside a Sealed Artifact.
	SEALED,
}

var id: StringName
var pathway_id: StringName
var sequence: int
var origin: String
var location: String
var state: State = State.FREE
var holder_id: StringName = &""


func is_free() -> bool:
	return state == State.FREE


func to_dict() -> Dictionary:
	return {
		"id": String(id),
		"pathway_id": String(pathway_id),
		"sequence": sequence,
		"origin": origin,
		"location": location,
		"state": state,
		"holder_id": String(holder_id),
	}


static func from_dict(data: Dictionary) -> BeyonderCharacteristic:
	var characteristic := BeyonderCharacteristic.new()
	characteristic.id = StringName(data["id"])
	characteristic.pathway_id = StringName(data["pathway_id"])
	characteristic.sequence = int(data["sequence"])
	characteristic.origin = data["origin"]
	characteristic.location = data["location"]
	characteristic.state = int(data["state"]) as State
	characteristic.holder_id = StringName(data["holder_id"])
	return characteristic
