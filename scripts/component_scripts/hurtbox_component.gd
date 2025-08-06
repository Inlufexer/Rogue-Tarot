extends Area2D
class_name HurtboxComponent

@export var health_component: HealthComponent
@export var is_player: bool = false
@export var damage_cooldown := 1.0

var last_damaged_time := -100.0

func damage(attack: Attack):
	if not health_component:
		return
	var current_time = Time.get_ticks_msec() / 1000.0
	if is_player:
		if current_time - last_damaged_time < damage_cooldown:
			print("Damage ignored: cooldown active")
			return
		last_damaged_time = current_time

	# Apply damage
	health_component.damage(attack)
