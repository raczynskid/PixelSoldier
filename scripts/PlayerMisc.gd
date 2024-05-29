extends Node

var parent

@export
var deceleration_factor : float = 10

func decelerate(_delta):
	parent.velocity.x = lerp(parent.velocity.x, 0.0, deceleration_factor * _delta)

func interact():
	Signals.interact.emit()

func die():
	parent.is_dead = true
	parent.animations.play("Die")
	parent.velocity = Vector2.ZERO
