extends State

@export
var chase_state : State

func process_physics(delta: float) -> State:
	if is_done:
		return chase_state
	return null

func exit() -> void:
	is_done = false

func _on_animated_sprite_2d_animation_finished():
	is_done = true
