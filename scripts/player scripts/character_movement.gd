extends CharacterBody2D


const SPEED = 150.0
var moveDir = Vector2.ZERO



func _physics_process(_delta):
	update_moveDir()
	apply_movement()


func update_moveDir():
	#Cardinal direction movement
	if Input.is_action_pressed("right"):
		moveDir.x = 1
	
	if Input.is_action_pressed("left"):
		moveDir.x = -1
	
	if Input.is_action_pressed("up"):
		moveDir.y = -1
	
	if Input.is_action_pressed("down"):
		moveDir.y = 1
	#Prevent errors from moving in both directions
	if !Input.is_action_pressed("right") and !Input.is_action_pressed("left"):
		moveDir.x = 0
	
	if !Input.is_action_pressed("up") and !Input.is_action_pressed("down"):
		moveDir.y = 0
	
	moveDir = moveDir.normalized()

func apply_movement():
	velocity.x = moveDir.x * SPEED
	velocity.y = moveDir.y * SPEED
	
	move_and_slide()
