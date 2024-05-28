extends State

@export
var idle_state : State
@export
var attack_state : State
@export
var patrol_state : State
@export
var die_state : State
@export
var chase_speed : int = 200

var direction : Vector2

var timer_setting: float = 5.0
var timer

	
func player_position() -> Vector2:
	# calculate direction vector to player
	return parent.global_position.direction_to(parent.player_target.global_position)
	
func in_range() -> bool:
	var collider = parent.raycast_attack.get_collider()
	if collider:
		return collider.is_in_group("Player")
	return false

func enter() -> void:
	super()
	# reset follow timer
	timer = timer_setting

func exit() -> void:
	return

func process_physics(delta: float) -> State:
	
	if parent.hp <= 0:
		return die_state
	
	# when ticker elapses, return to patrol state
	
	if timer > 0:
		timer -= delta
	else:
		return patrol_state
		
	if in_range():
		return attack_state
	# establish vector to player's position
	direction = player_position()
	# rotate the sprite
	parent.scale.x = parent.scale.y * (1 if direction.x <0 else -1)
	parent.velocity.x = direction.x * chase_speed
	parent.move_and_slide()
	return null
