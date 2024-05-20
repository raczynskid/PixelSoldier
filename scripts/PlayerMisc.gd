extends Node

var parent

@export
var deceleration_factor : float = 10

func decelerate(_delta):
	parent.velocity.x = lerp(parent.velocity.x, 0.0, deceleration_factor * _delta)
