extends Node2D

@onready var timer = $Timer
@onready var main = get_node("/root/main/")
const CARD = preload("res://scenes/card.tscn")
var shoot_dir = Vector2.ZERO
var card_type = "default_card"



func _process(_delta: float) -> void:
	look_at(get_global_mouse_position())
	if timer.is_stopped():
		handle_shooting()

func handle_shooting():
	var shoot_dir = Vector2.ZERO
	var aim_vector = Vector2.ZERO
	var deadzone = 0.2  # ignore tiny stick movement
	if main.input_type == "controller":
		# Get right stick input (controller 0 by default)
		var x = Input.get_joy_axis(0, JOY_AXIS_RIGHT_X)
		var y = Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)
		aim_vector = Vector2(x, y)

		# Deadzone check
		if aim_vector.length() < deadzone:
			return  # keep last direction
	else:
		# Mouse aiming
		aim_vector = (get_global_mouse_position() - global_position)

	# Normalize aim vector
	if aim_vector != Vector2.ZERO:
		aim_vector = aim_vector.normalized()
	else:
		return

	# --- Cardinal Direction Selection ---
	if abs(aim_vector.x) > abs(aim_vector.y):
		# Horizontal wins
		if aim_vector.x > 0:
			shoot_dir = Vector2.RIGHT
		else:
			shoot_dir = Vector2.LEFT
	else:
		# Vertical wins
		if aim_vector.y > 0:
			shoot_dir = Vector2.DOWN
		else:
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
	print("Fool")
	for i in range(10):
		var card_instance = CARD.instantiate()
		card_instance.global_position = global_position
		card_instance.rotation = (randf_range(0, 2*PI))
		get_tree().root.add_child(card_instance)
		await get_tree().create_timer(0.1).timeout


func _on_tarot_handler_magician_used() -> void:
	handle_shooting()
	for i in range(10):
		var card_instance = CARD.instantiate()
		card_instance.global_position = global_position
		card_instance.rotation = shoot_dir.angle()
		get_tree().root.add_child(card_instance)
		await get_tree().create_timer(0.1).timeout
