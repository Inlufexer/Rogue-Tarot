extends AnimatedSprite2D

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
		play("Walk Right")
	if character_movement_dir.x == -1 and character_movement_dir.y == 0:
		play("Walk Left")
	if character_movement_dir.y == 1 and character_movement_dir.x == 0:
		play("Walk Forward")
	if character_movement_dir.y == -1 and character_movement_dir.x == 0:
		play("Walk Backwards")
		
	#Handle diagonals
	
	if character_movement_dir.x == 1 and character_movement_dir.y == 1:
		play("Walk Right")
	if character_movement_dir.x == -1 and character_movement_dir.y == 1:
		play("Walk Left")
	
	#Handle stopping
	if character_movement_dir.x == 0 and character_movement_dir.y == 0:
		stop()
