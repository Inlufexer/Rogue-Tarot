extends CharacterBody2D


const  SPEED = 50.0
var moveDir = Vector2.ZERO
var player_instance : Node2D
var attacking = false
const STOP_THRESHOLD = 4.0
@onready var health = $HealthComponent

func _ready():
	# Replace the path with the actual path to your player node in the scene
	player_instance = get_node("/root/main/fedora_guy")

func _physics_process(_delta):
	if player_instance != null:
		if health.stun_timer > 0:
			$AnimationPlayer.play($AnimationPlayer.current_animation)
			$AnimationPlayer.pause()
			moveDir = Vector2.ZERO
			velocity = Vector2.ZERO
			return
		elif attacking == false:
			movement()
	elif player_instance == null:
		$AnimationPlayer.play("walk_forward")
	
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
	
		moveDir = moveDir.normalized()

func movement():
	direction()
	velocity.x = moveDir.x * SPEED
	velocity.y = moveDir.y * SPEED
	move_and_slide()
	
	
	





func _on_player_detection_area_entered(_area: Area2D) -> void:
	attacking = true
	velocity = Vector2.ZERO


func _on_player_detection_area_exited(_area: Area2D) -> void:
	attacking = false
