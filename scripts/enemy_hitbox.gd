extends Area2D

var attack_damage = 1
var knockback_force = 100




func _on_area_entered(area: Area2D) -> void:
	if area is HurtboxComponent:
		var hurtbox : HurtboxComponent = area
		
		var attack = Attack.new()
		attack.attack_damage = attack_damage
		attack.knockback_force = knockback_force
		attack.attack_position = global_position
		
		hurtbox.damage(attack)
		print("punch")
