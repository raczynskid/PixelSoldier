extends State

@export
var chase_state : State
@export
var die_state : State
var attack_hit : bool = false

func process_physics(delta: float) -> State:
	if parent.hp <= 0:
		return die_state
	
	var collider = parent.raycast_attack.get_collider()
	if collider:
		if (parent.animations.get_frame() == 2) and (!attack_hit):
			if collider.is_in_group("Player"):
				attack_hit = true
				Signals.player_hit.emit(parent.damage)
	
	if is_done:
		return chase_state
	return null

func exit() -> void:
	is_done = false
	attack_hit = false

func _on_animated_sprite_2d_animation_finished():
	is_done = true
