extends State

@export
var idle_state : State

@onready
var misc : Node = $"../Misc"

var roll_deceleration = 10

func exit() -> void:
	is_done = false

func process_physics(_delta: float) -> State:
	if is_done:
		return idle_state
	else:
		parent.velocity.x = lerp(parent.velocity.x, 0.0, 2 * _delta)
	return null

func _on_animated_sprite_2d_animation_finished():
	is_done = true
