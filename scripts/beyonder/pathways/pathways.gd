class_name Pathways
extends RefCounted

static var _cache: Dictionary[StringName, BeyonderPathway] = {}


static func get_pathway(pathway_id: StringName) -> BeyonderPathway:
	if not _cache.has(pathway_id):
		var pathway := _create(pathway_id)
		if pathway == null:
			push_error("Unknown pathway: %s" % pathway_id)
			return null
		_cache[pathway_id] = pathway
	return _cache[pathway_id]


static func _create(pathway_id: StringName) -> BeyonderPathway:
	if pathway_id == FoolPathway.ID:
		return FoolPathway.create()
	return null
