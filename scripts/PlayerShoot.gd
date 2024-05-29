extends Node

var parent
@export
var reload_timer = 1.0

func shoot(called_from_node : String):
	if parent.ammo > 0:
		parent.animations.play("Shoot" + called_from_node)
		parent.ammo -= 1
		if parent.raycast_shoot.is_colliding():
			spawn_particles()
			var target = parent.raycast_shoot.get_collider().get_owner()
			if target.is_in_group("Enemies"):
				target.hp -= 1
	else:
		if parent.reload_timer.time_left == 0:
			parent.animations.play(called_from_node)
			parent.reload_timer.start()

func spawn_particles() -> void:
	var collider = parent.raycast_shoot.get_collider()
	var particles : Resource = load("res://scenes/HitEffect.tscn")
	var spark_point = particles.instantiate()
	collider.add_child(spark_point)
	var point = parent.raycast_shoot.get_collision_point()
	spark_point.global_transform.origin = point
	spark_point.get_node("GPUParticles2D").process_material.direction.x = -1 if point.x > parent.global_transform.origin.x else 1


func _on_reload_timer_timeout():
	parent.ammo = parent.max_ammo

