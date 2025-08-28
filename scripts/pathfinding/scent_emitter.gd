extends Node2D

@export var emit_interval: float = 0.2
@export var emit_on_movemnt_distance: float = 6.0
@export var scent_strength: float = 1.0

var _timer: float = 0.0
var _last_emit_pos: Vector2

func _ready() -> void:
	_timer = 0.0
	_last_emit_pos = global_position

func _process(delta: float) -> void:
	_timer += delta
	if _timer >= emit_interval:
		_timer = 0.0
		ScentManager.add_scent(global_position, scent_strength)
		_last_emit_pos = global_position
		return
