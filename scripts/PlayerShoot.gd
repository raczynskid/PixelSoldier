extends Node

var parent

func shoot(called_from_node : String):
	parent.animations.play("Shoot" + called_from_node)
