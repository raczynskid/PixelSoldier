extends Node2D

onready var ray1 = get_node("Ray1")
onready var ray2 = get_node("Ray2")
onready var ray3 = get_node("Ray3")

var collision_rays = [ray1, ray2, ray3]

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
