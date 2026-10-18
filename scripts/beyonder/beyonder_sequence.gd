class_name BeyonderSequence
extends Resource

enum Tier { LOW, MID, DEMIGOD, ANGEL, TRUE_GOD }

@export_range(0, 9) var number: int = 9
@export var display_name: String
@export_multiline var description: String
@export_multiline var acting_principle: String
@export var abilities: Array[BeyonderAbility] = []
## Stat bonuses granted on advancing into this sequence; they stack with lower sequences.
@export var stat_bonuses: Dictionary[StringName, float] = {}


func get_tier() -> Tier:
	return tier_of(number)


func get_ability(ability_id: StringName) -> BeyonderAbility:
	for ability in abilities:
		if ability.id == ability_id:
			return ability
	return null


static func tier_of(sequence_number: int) -> Tier:
	if sequence_number >= 8:
		return Tier.LOW
	if sequence_number >= 5:
		return Tier.MID
	if sequence_number >= 3:
		return Tier.DEMIGOD
	if sequence_number >= 1:
		return Tier.ANGEL
	return Tier.TRUE_GOD
