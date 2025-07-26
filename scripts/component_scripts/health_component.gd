extends Node2D
class_name HealthComponent

@export var MAX_HEALTH := 3
var health : int

signal health_changed(current_health)

var knockback_velocity = Vector2.ZERO
const KNOCKBACK_DECAY = 800.0
var stun_timer = 0.0

func  _ready():
	health = MAX_HEALTH

func _physics_process(delta):
	apply_knockback(delta)
	
	if stun_timer > 0:
		stun_timer -= delta

func apply_knockback(delta):
	if knockback_velocity.length() > 0:
		var parent = get_parent()
		
		if parent is CharacterBody2D:
			parent.move_and_collide(knockback_velocity * delta)
		else:
			parent.position += knockback_velocity * delta
		# Reduce knockback over time
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, KNOCKBACK_DECAY * delta)
	
func damage(attack: Attack):
	health -= attack.attack_damage
	
	if health <= 0:
		get_parent().call_deferred("queue_free")
	
	var dir = (get_parent().global_position - attack.attack_position).normalized()
	knockback_velocity = dir * attack.knockback_force
	
	stun_timer = attack.stun_time
	
	emit_signal("health_changed", health)
