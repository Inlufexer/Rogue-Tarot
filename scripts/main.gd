extends Node2D
@onready var fedora_guy_health = $fedora_guy/HealthComponent
@onready var playtime_ui = $playtime_ui/Control
@onready var tarot_player = $fedora_guy/TarotHandler
@onready var tarot_ui = $playtime_ui/Control/TarotController

func _ready():
	fedora_guy_health.health_changed.connect(playtime_ui.player_health_change)
	tarot_player.tarot_used.connect(tarot_ui.dissolve)
