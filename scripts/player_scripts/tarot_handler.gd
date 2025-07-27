extends Node

signal fool_used

@onready var card_order = ["The Fool", "Magician", "Tower"]
@onready var tarot_cards = {
	"The Fool": Callable(self, "_use_fool")
}

@onready var current_index := 0

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("tarot_ability"):
		var card_name = card_order[current_index]
		tarot_cards[card_name].call()

func _use_fool():
	print(tarot_cards.find_key(Callable(self, "_use_fool")))
	emit_signal("fool_used")
