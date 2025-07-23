extends Area2D

var attack_damage = 1
var knockback_force = 200
var stun_time = 0.5


func _on_hitbox_area_entered(area):
	if area is HurtboxComponent:
		var hitbox : HurtboxComponent = area
		
		var attack = Attack.new()
		attack.attack_damage = attack_damage
		attack.knockback_force = knockback_force
		attack.attack_position = global_position
		attack.stun_time = stun_time
		
		hitbox.damage(attack)
		
		get_parent().queue_free()
	
