extends Node2D

@onready
var particle = $GPUParticles2D

func _ready():
	particle.emitting = true

func _on_timer_timeout():
	queue_free()

