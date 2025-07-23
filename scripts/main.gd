extends Node2D
@onready var fedora_guy_health = $fedora_guy/HealthComponent
@onready var playtime_ui = $playtime_ui/Control

func _ready():
	fedora_guy_health.health_changed.connect(playtime_ui.player_health_change)
