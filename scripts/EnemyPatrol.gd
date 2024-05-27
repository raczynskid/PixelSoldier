extends State

@export
var idle_state : State
@export
var chase_state : State
@export
var patrol_speed : int = 30

var target : Vector2
var direction : Vector2
	
func player_detected() -> bool:
	var collider = parent.raycast_nav.get_collider()
	if collider:
		if collider.is_in_group("Player"):
			return true
	return false
	
func wall_detected() -> bool:
	# check for upcoming wall
	var wall_collider = parent.raycast_attack.get_collider()
	# check for upcoming fall
	var ground_collider = parent.raycast_ground.get_collider()
	# if getting close to wall or cliff, turn around
	if wall_collider or !ground_collider:
		return true
	return false

func enter() -> void:
	super()
	direction.x = patrol_speed

func exit() -> void:
	return

func process_input(event: InputEvent) -> State:
	return null

func process_physics(delta: float) -> State:
	# check raycast if closing in to a wall
	if wall_detected():
		# flip direction if near a wall
		direction *=-1
	# flip sprite
	parent.scale.x = parent.scale.y * (1 if direction.x <0 else -1)
	
	parent.velocity.x = direction.x * patrol_speed * delta
	# if player detected by the long raycast
	# transition to follow state
	if player_detected():
		return chase_state

	return null
