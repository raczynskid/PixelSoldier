extends State

func enter() -> void:
	super()
	parent.hitbox.disabled = true
	parent.collisions.disabled = true
	parent.gravity = 0

func process_physics(_delta) -> State:
	if parent.velocity.x:
		parent.velocity.x = lerp(parent.velocity.x, 0.0, 2 * _delta)
	return null
