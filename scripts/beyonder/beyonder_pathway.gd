class_name BeyonderPathway
extends Resource

@export var id: StringName
@export var display_name: String
@export_multiline var description: String
@export var uniqueness: String
@export var sefirah: String
@export var neighboring_pathways: Array[StringName] = []
@export var sequences: Array[BeyonderSequence] = []


func get_sequence(number: int) -> BeyonderSequence:
	for sequence in sequences:
		if sequence.number == number:
			return sequence
	return null


## Abilities a Beyonder at `number` has, including those kept from lower sequences.
func get_abilities_up_to(number: int) -> Array[BeyonderAbility]:
	var result: Array[BeyonderAbility] = []
	for sequence in sequences:
		if sequence.number >= number:
			result.append_array(sequence.abilities)
	return result


func get_cumulative_stat(stat: StringName, number: int) -> float:
	var total := 0.0
	for sequence in sequences:
		if sequence.number >= number:
			total += sequence.stat_bonuses.get(stat, 0.0)
	return total
