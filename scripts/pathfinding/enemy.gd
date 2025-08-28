extends CharacterBody2D

enum State {
	IDLE,
	PATROL, # Not currently used
	TRACK_SCENT,
	DIRECT_CHASE,
	SEARCH,
	ATTACKING,
	STUNNED # IDK man, we'll reroute it to health component later
	}

@export var speed: float = 10.0
@export var chase_speed: float = 70
@export var scent_detection_radius: float = 300
@export var  scent_age_thershold: float = 4.0 # How old scents must be in seconds to track
@export var scent_line_of_sight: bool = true # Whether to require LOS to a scent
@export var sight_distance: float = 250.0 # direct vision distance to player
@export var lose_sight_time: float = 2.0 # time to start searching after direct chase
@export var nav_repath_interval: float = 0.4 # time in seconds to repath to player

# nodes
@onready var nav_agent: NavigationAgent2D = $NavAgent
@onready var ray_to_player: RayCast2D = $RayToPlayer
@onready var elapsed_time: float = 0.0

var state: State = State.IDLE

var moveDir: Vector2 = Vector2.ZERO

# Attack Vars

var attack_range = 15
var attacking = false

# internal
var _last_seen_player_time: float = -999.0
var _last_nav_repath_time: float = -999.0
var _target_scent_pos: Vector2 = Vector2.ZERO
var _patrol_points: Array = []  # Will use if patrol is implemented
var _patrol_index: int = 0

func _ready() -> void:
	if not nav_agent.is_navigation_finished():
		var next_pos = nav_agent.get_next_path_position()
		var dir = (next_pos - global_position).normalized()
		velocity = dir * chase_speed
	nav_agent.path_max_distance = 10000.0

func _physics_process(delta: float) -> void:

	_try_attack_player()

	match state:
		State.IDLE:
			_state_idle(delta)
			print("Idle")
		State.PATROL: # Not currently used
			_state_patrol(delta)
		State.TRACK_SCENT:
			_state_track_scent(delta)
			print("Tracking")
		State.DIRECT_CHASE:
			_state_direct_chase(delta)
			print("Chasing")
		State.SEARCH:
			_state_direct_chase(delta)
			print("Searching")
		State.ATTACKING:
			_state_attacking(delta)
			print("Attacking")
		State.STUNNED:
			_state_stunned(delta) # See note above
	
	elapsed_time += delta

	# Walking Animations
	if velocity.length() > 0:
		var normalized_vel = velocity.normalized()
		moveDir.x = int(round(normalized_vel.x))
		moveDir.y = int(round(normalized_vel.y))

	move_and_slide()

# ------------------------------
# State Implementations
# ------------------------------

func _state_idle(_delta: float) -> void:
	# Try to detect player
	if _can_see_player():
		_enter_direct_chase()
		return
	
	# Try to detect scents
	var scent = _find_best_scent()
	if scent:
		_target_scent_pos = scent.pos
		state = State.TRACK_SCENT
		return
	
	velocity = Vector2.ZERO

func _state_patrol(_delta:float) -> void:
	# Might add eventually
	pass

func _state_track_scent(delta:float) -> void:
	if _can_see_player():
		_enter_direct_chase()
		return
	
	var scent = _find_best_scent()
	if not scent:
		state= State.IDLE
		return
	
	var target = scent.pos
	if _is_visible(target) or global_position.distance_to(target) < 12.0:
		# Moves straight to target
		var move_dir = (target - global_position).normalized()
		velocity = move_dir * speed
	else:
		_target_scent_pos = target
		_state_search(delta)
		return

func _state_direct_chase(_delta: float) -> void:
	# Keep updating nav target to player's current pos
	var player_pos = _get_player_pos()
	if player_pos == null:
		state = State.SEARCH
		return
	
	# Set nav target periodically
	if elapsed_time - _last_nav_repath_time > nav_repath_interval:
		print("Pathing")
		nav_agent.target_position = player_pos
		_last_nav_repath_time = elapsed_time
	
	# Get next point from nav_agent and move towards it
	if nav_agent.is_navigation_finished():
		var dir = (player_pos - global_position).normalized()
		velocity = dir.normalized() * chase_speed
	else:
		velocity = Vector2.ZERO
	
	# LOS check
	if _can_see_player():
		var dir = (player_pos - global_position)
		if dir.length() > 4.0:
			velocity = dir.normalized() * chase_speed
		else:
			velocity = Vector2.ZERO

		_last_seen_player_time = elapsed_time
	else:
		if nav_agent.is_navigation_finished():
			velocity = Vector2.ZERO
		else:
			var next_pos = nav_agent.get_next_path_position()
			var dir = next_pos - global_position
			if dir.length() > 4.0:
				velocity = dir.normalized() * chase_speed
			else:
				velocity = Vector2.ZERO

func _state_search(_delta: float) -> void:
	var scent = _find_best_scent()
	if scent:
		if elapsed_time - _last_nav_repath_time > nav_repath_interval:
			nav_agent.target_position = scent.pos
			_last_nav_repath_time = elapsed_time
		
		if nav_agent.is_navigation_finished():
			# Reached the scent, player isn't here: resume idle
			state = State.IDLE
			return
	else:
		# No scents found: resume idle
		state = State.IDLE

func _state_attacking(_delta: float) -> void:
	velocity = Vector2.ZERO

	attacking = true
	

func _try_attack_player():
	var player_pos = _get_player_pos()
	if player_pos == null:
		return
	if global_position.distance_to(player_pos) < attack_range:
		if attacking == false:
			_enter_attacking()
	else:
		_enter_direct_chase()
		attacking = false

func _state_stunned(_delta: float) -> void:
	# We'll figure it out, see above
	pass

# ------------------------------
# State Transitions
# ------------------------------

func _enter_idle():
	state = State.IDLE
	velocity = Vector2.ZERO

func _enter_patrol():
	state = State.PATROL

func _enter_direct_chase():
	state = State.DIRECT_CHASE
	_last_seen_player_time = elapsed_time

func _enter_track_scent():
	state = State.TRACK_SCENT

func _enter_search():
	state = State.SEARCH

func _enter_attacking() -> void:
	state = State.ATTACKING
	attacking = true
	velocity = Vector2.ZERO

func _enter_stunned():
	state = State.STUNNED




# ------------------------------
# Utilities Used
# ------------------------------

func _get_player_pos():
	var p = get_tree().get_root().get_node_or_null("main/fedora_guy")
	if p:
		return p.global_position
	return null

func _can_see_player() -> bool:
	var player_pos = _get_player_pos()
	if player_pos == null:
		return false
	if global_position.distance_to(player_pos) >sight_distance:
		return false
	return _is_visible(player_pos)

func _is_visible(world_pos: Vector2) -> bool:
	var space = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.new()
	query.from = global_position
	query.to = world_pos
	query.exclude = [self]
	query.collision_mask = 1
	var result = space.intersect_ray(query)
	return not result.has("collider") or result["collider"] == null

func _find_best_scent():
	var list = ScentManager.get_scents_newest_first()
	for s in list:
		if global_position.distance_to(s.pos) <= scent_detection_radius:
			if scent_line_of_sight and not _is_visible(s.pos):
				continue
			if elapsed_time - s.time <= scent_age_thershold:
				return s
	return null

func _on_nav_velocity_computed(v: Vector2) -> void:
	pass
