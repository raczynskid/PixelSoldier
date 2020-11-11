extends Area2D
onready var hit_object = null

func _on_knife_hurtbox_area_entered(body):
	hit_object = body.get_parent()
	if hit_object.is_in_group("enemies"):
		hit_object.hit_by_melee()
