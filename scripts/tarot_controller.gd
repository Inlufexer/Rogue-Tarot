extends Control

func _ready() -> void:
	material.set_shader_parameter("dissolve_tex_size", Vector2(256, 256))
	material.set_shader_parameter("sprite_pixel_size", Vector2(30.0, 48.0))

func dissolve():
	$TarotCard.use_parent_material = true

	print($TarotCard.get_instance_shader_parameter("dissolve_value"))
	
	for i in range(0, 100):
		var t = 1.0 - (i / 100.0)
		material.set_shader_parameter("dissolve_value", t)
		print(get_instance_shader_parameter("dissolve_value"))
		await get_tree().process_frame
