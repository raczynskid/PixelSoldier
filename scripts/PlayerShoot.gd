extends Node

var parent


func shoot(called_from_node : String):
	parent.animations.play("Shoot" + called_from_node)
	if parent.raycast_shoot.is_colliding():
		spawn_particles()

func spawn_particles() -> void:
	var collider = parent.raycast_shoot.get_collider()
	var particles : Resource = load("res://scenes/HitEffect.tscn")
	var spark_point = particles.instantiate()
	collider.add_child(spark_point)
	var point = parent.raycast_shoot.get_collision_point()
	spark_point.global_transform.origin = point
	spark_point.get_node("GPUParticles2D").process_material.direction.x = -1 if point.x > parent.global_transform.origin.x else 1
