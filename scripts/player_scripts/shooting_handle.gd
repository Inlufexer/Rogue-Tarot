extends Node2D

@onready var timer = $Timer
const CARD = preload("res://scenes/card.tscn")
var shoot_dir = Vector2.ZERO

func _process(_delta: float) -> void:
	look_at(get_global_mouse_position())
	if timer.is_stopped():
		handle_shooting()

func handle_shooting():
	shoot_dir = Vector2.ZERO

	# Vector pointing from player to mouse
	var aim_vector = (get_global_mouse_position() - global_position).normalized()
	var angle_deg = aim_vector.angle()

	# Normalize angle to 0–360
	if angle_deg < 0:
		angle_deg += 2 * PI

	# Determine cardinal direction
	if angle_deg >= 1.75 * PI or angle_deg < 0.25 * PI:
		shoot_dir = Vector2.RIGHT
	elif angle_deg >= 0.25 * PI and angle_deg < 0.75 * PI:
		shoot_dir = Vector2.DOWN
	elif angle_deg >= 0.75 * PI and angle_deg < 1.25 * PI:
		shoot_dir = Vector2.LEFT
	elif angle_deg >= 1.25 * PI and angle_deg < 1.75 * PI:
		shoot_dir = Vector2.UP

	# Standard Shot
	if Input.is_action_just_pressed("shoot") and shoot_dir != Vector2.ZERO:
		shoot(shoot_dir)

func shoot(direction: Vector2):
	
	var card_instance = CARD.instantiate()
	card_instance.global_position = global_position
	card_instance.rotation = direction.angle()
	get_tree().root.add_child(card_instance)
	timer.start()


func _on_tarot_handler_fool_used() -> void:
	for i in range(10):
		var card_instance = CARD.instantiate()
		card_instance.global_position = global_position
		card_instance.rotation = (randf_range(0, 2*PI))
		get_tree().root.add_child(card_instance)
		await get_tree().create_timer(0.1).timeout
