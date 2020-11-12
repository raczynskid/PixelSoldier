extends Area2D
var hit_object = null

func _on_DamageArea_body_entered(body):
	if body.is_in_group("player"):
		print("player entered dmg area")

func _physics_process(delta):
	for body in get_overlapping_bodies():
		body.hp -= 1
