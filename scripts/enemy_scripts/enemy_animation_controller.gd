extends AnimationPlayer
var enemy

func _ready():
	enemy = get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if enemy.attacking == false:
		walking()
	else:
		attacking()


#Handles Walking animation
func walking():
	match enemy.moveDir:
		Vector2(0, 0):
			stop()
		Vector2(1, 0):
			play("walk_right")
		Vector2(-1, 0):
			play("walk_left")
		Vector2(0, 1):
			play("walk_forward")
		Vector2(0, -1):
			play("walk_backwards")
		Vector2(1, 1):
			play("walk_right")
		Vector2(-1, 1):
			play("walk_left")
		

func attacking():
	var angle_deg = get_parent().moveDir.angle()
	while angle_deg < 0:
		angle_deg += 2 * PI
	
	if angle_deg >= 1.75 * PI or angle_deg < 0.25 * PI:
		play("punch_right")
	elif angle_deg >= 0.25 * PI and angle_deg < 0.75 * PI:
		play("punch_forward")
	elif angle_deg >= 0.75 * PI and angle_deg < 1.25 * PI:
		play("punch_left")
	elif angle_deg >= 1.25 * PI and angle_deg < 1.75 * PI:
		play("punch_backwards")
