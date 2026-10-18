class_name BeyonderAbility
extends Resource

@export var id: StringName
@export var display_name: String
@export_multiline var description: String
@export var is_passive: bool = false
@export var spirituality_cost: float = 0.0
@export var cooldown: float = 0.0
@export var range_meters: float = 0.0


static func make(
	p_id: StringName,
	p_name: String,
	p_description: String,
	p_passive := false,
	p_cost := 0.0,
	p_cooldown := 0.0,
	p_range := 0.0,
) -> BeyonderAbility:
	var ability := BeyonderAbility.new()
	ability.id = p_id
	ability.display_name = p_name
	ability.description = p_description
	ability.is_passive = p_passive
	ability.spirituality_cost = p_cost
	ability.cooldown = p_cooldown
	ability.range_meters = p_range
	return ability
