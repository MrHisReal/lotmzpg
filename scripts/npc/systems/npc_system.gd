class_name NpcSystem
extends RefCounted
## Passive simulation that runs on an NPC every tick regardless of what it's doing.
## To add one, extend this, override `tick`, and register it in NpcManager.systems
## (or `agent.add_system`).


func tick(_agent: NpcAgent) -> void:
	pass
