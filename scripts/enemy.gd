extends CharacterBody2D

const SPEED = 100.0
var moveDir = Vector2.ZERO
var player_instance : Node2D  # You can change to your specific player type
const STOP_THRESHOLD = 4.0

func _ready():
	# Replace the path with the actual path to your player node in the scene
	player_instance = get_node("/root/main/fedora_guy")

func _physics_process(delta):
	movement(delta)

func direction():
	var diff = player_instance.global_position - global_position
	
	if abs(diff.x) > STOP_THRESHOLD:
		moveDir.x = 1 if diff.x > 0 else -1
	else:
		moveDir.x = 0

	if abs(diff.y) > STOP_THRESHOLD:
		moveDir.y = 1 if diff.y > 0 else -1
	else:
		moveDir.y = 0

func movement(d):
	direction()
	move_and_collide(moveDir.normalized() * SPEED * d)
