extends Node

signal fool_used
signal magician_used
signal tarot_used

var tarot_charges = 2
@onready var card_order = ["the_fool", "the_magician"]
@onready var tarot_cards = {
	"the_fool": Callable(self, "_use_fool"),
	"the_magician": Callable(self, "_use_magician")
}

@onready var current_index := 0

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("tarot_ability") and tarot_charges > 0:
		var card_name = card_order[current_index]
		tarot_cards[card_name].call()
		tarot_charges -= 1
		current_index += 1
		emit_signal("tarot_used")

func _use_fool():
	emit_signal("fool_used")

func _use_magician():
	emit_signal("magician_used")
