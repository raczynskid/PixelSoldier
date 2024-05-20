extends State

@export
var jump_velocity : float = 400.0

@export
var jump_damping : int = 5

@export
var idle_state : State

@onready
var misc : Node = $"../Misc"

func enter() -> void:
	super()
	parent.velocity.y -= jump_velocity

func process_physics(_delta: float) -> State:
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if input_direction:
		parent.scale.x = parent.scale.y * (-1 if input_direction.x <0 else 1)
		if parent.velocity.x < parent.max_speed:
			parent.velocity.x += input_direction.x * _delta * move_speed
	if not parent.is_on_floor():
		parent.velocity.y = lerp(parent.velocity.y, 0.0, 1 * _delta)
	else:
		return idle_state
	parent.velocity.x = lerp(parent.velocity.x, 0.0, 2.0 * _delta)
	return null
