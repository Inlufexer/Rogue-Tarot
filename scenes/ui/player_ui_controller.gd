extends Control
var player_instance : Node2D

func _ready():
	player_instance = get_node("fedora_guy")

func _player_health_change(current_health):
	update_hearts(current_health)

func update_hearts(current_health):
	for i in range($HeartContainer.get_child_count()):
		var heart = $HeartContainer.get_child(i)
		heart.visible = i < current_health
