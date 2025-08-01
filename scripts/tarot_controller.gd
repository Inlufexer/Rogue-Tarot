extends Control
var player_instance : Node

func _ready() -> void:
	material.set_shader_parameter("dissolve_tex_size", Vector2(512, 512))
	material.set_shader_parameter("sprite_pixel_size", Vector2(30.0, 48.0))
	player_instance = get_node("/root/main/fedora_guy/TarotHandler")

func dissolve():
	$TarotCard.use_parent_material = true

	print($TarotCard.get_instance_shader_parameter("dissolve_value"))
	
	for i in range(0, 100):
		var t = 1.0 - (i / 100.0)
		material.set_shader_parameter("dissolve_value", t)
		await get_tree().create_timer(0.01).timeout
	if player_instance.current_index < player_instance.card_order.size():
		var card_name = player_instance.card_order[player_instance.current_index]
		$TarotCard/AnimationPlayer.play(card_name)
		$TarotCard/AnimationPlayer.seek(0.0, true) 
		$TarotCard/AnimationPlayer.pause()
		for i in range(0, 100):
			var t = i / 100.0
			material.set_shader_parameter("dissolve_value", t)
			await get_tree().create_timer(0.01).timeout
