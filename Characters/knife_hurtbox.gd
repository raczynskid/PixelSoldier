extends Area2D
onready var hit_object = null

# called when hurtbox area entered signal
func _on_knife_hurtbox_area_entered(body):
	# body : Area2D
	# get parent of the hitbox
	# that intersects with melee hurbox
	if body.name == "Hurtbox":
		hit_object = body.get_parent()

		# check if intersecting object is in enemies group
		if hit_object.is_in_group("enemies"):

			# if hit object is enemy, call melee damage method
			hit_object.hit_by_melee()
