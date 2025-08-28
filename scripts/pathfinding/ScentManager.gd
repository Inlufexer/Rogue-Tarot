extends Node
@export var max_scents: int = 400
@export var scent_lifetime: float = 6.0
@export var scent_min_distance = 16.0
var elapsed_time: float = 0.0

var scents: Array = []


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	elapsed_time += delta
	_prune_expired()

func add_scent(world_pos: Vector2, strength : float = 1.0) -> void:
	if scents.size() > 0:
		# Optimization, only allows scent drop if player has moved far enough
		var last_pos = scents[scents.size() - 1].pos
		if last_pos.distance_to(world_pos) < scent_min_distance:
			return
	
	var s = {
		"pos": world_pos,
		"time": elapsed_time,
		"strength": strength
	}
	scents.append(s)
	# If max exceeded, pop oldest
	if scents.size() > max_scents:
		scents.pop_front()

func get_recent_scents(limit_seconds: float) -> Array:
	var cutoff = elapsed_time - limit_seconds # Find scents older than cutoff
	var out := []
	for s in scents:
		if s.time >= cutoff: # Checks if the scent is recent enough
			out.append(s)
	return out # Only gives recent scents

func _prune_expired() -> void:
	var cutoff = elapsed_time - scent_lifetime
	while scents.size() > 0 and scents[0].time < cutoff:
		scents.pop_front()

func get_scents_newest_first() -> Array:
	var copy = scents.duplicate()
	copy.reverse()
	return copy
