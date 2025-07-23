extends Node2D
class_name HealthComponent

@export var MAX_HEALTH := 3
var health : int

func  _ready():
	health = MAX_HEALTH
	
	
func damage(attack: Attack):
	health -= attack.attack_damage
	
	if health <= 0:
		get_parent().queue_free()
	
	emit_signal("health_changed", health)
	print(health)
