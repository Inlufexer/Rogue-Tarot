extends Node2D

const SPEED: int = 400

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += transform.x * SPEED * delta
