extends AnimationPlayer

func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	walking()


#Handles Walking animation
func walking():
	var character_movement_dir = get_parent().moveDir
	
	#Cardinal direction walking
	if character_movement_dir.x == 1 and character_movement_dir.y == 0:
		play("walk_right")
	if character_movement_dir.x == -1 and character_movement_dir.y == 0:
		play("walk_left")
	if character_movement_dir.y == 1 and character_movement_dir.x == 0:
		play("walk_forward")
	if character_movement_dir.y == -1 and character_movement_dir.x == 0:
		play("walk_backwards")
		
	#Handle diagonals
	
	if character_movement_dir.x == 1 and character_movement_dir.y == 1:
		play("walk_right")
	if character_movement_dir.x == -1 and character_movement_dir.y == 1:
		play("walk_left")
	
	#Handle stopping
	if character_movement_dir.x == 0 and character_movement_dir.y == 0:
		stop()
