class_name NpcBrain
extends RefCounted
## Utility-AI decision maker. Every behavior scores how much the NPC wants to do it right now.
## A score at or above URGENT_SCORE wins outright and may interrupt the current action;
## otherwise a behavior is picked at random, weighted by score.

const URGENT_SCORE := 1.0

var behaviors: Array[NpcBehavior] = []


func add_behavior(behavior: NpcBehavior) -> void:
	behaviors.append(behavior)


func remove_behavior(behavior_id: StringName) -> void:
	for i in range(behaviors.size() - 1, -1, -1):
		if behaviors[i].id == behavior_id:
			behaviors.remove_at(i)


func get_behavior(behavior_id: StringName) -> NpcBehavior:
	for behavior in behaviors:
		if behavior.id == behavior_id:
			return behavior
	return null


## Returns null when no behavior wants to run.
func choose(agent: NpcAgent) -> NpcBehavior:
	var scores: Array[float] = []
	var total := 0.0
	var best: NpcBehavior = null
	var best_score := -INF
	for behavior in behaviors:
		var score := maxf(behavior.score(agent), 0.0)
		scores.append(score)
		total += score
		if score > best_score:
			best = behavior
			best_score = score

	if best_score >= URGENT_SCORE:
		return best
	if total <= 0.0:
		return null

	var roll := agent.rng.randf() * total
	for i in behaviors.size():
		roll -= scores[i]
		if roll < 0.0:
			return behaviors[i]
	return behaviors.back()


## Returns the highest-scoring urgent behavior, or null if nothing is urgent.
func choose_urgent(agent: NpcAgent) -> NpcBehavior:
	var best: NpcBehavior = null
	var best_score := URGENT_SCORE
	for behavior in behaviors:
		var score := behavior.score(agent)
		if score >= best_score:
			best = behavior
			best_score = score
	return best
