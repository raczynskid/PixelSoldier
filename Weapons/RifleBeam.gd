extends Node2D

# set signals
signal _on_hit_by_rifle(object)

# set max length of raycast
const MAX_LENGTH = 500

# load raycast nodes
onready var beam = get_node("Beam")
onready var end = get_node("End")
onready var ray = get_node("RayCast2D")
onready var player = get_parent()
onready var shot_direction = Vector2(1,0)
var max_cast_to = Vector2.ZERO
var current_collider = null

# recieve signals from AnimationPlayer
func shoot_up():
	shot_direction = Vector2(0, -1)

func shoot_left():
	shot_direction = Vector2(-1, 0)

func shoot_right():
	shot_direction = Vector2(1, 0)

func get_shot_direction():
	return shot_direction 

func _physics_process(_delta):

	# make sure that first shot after pivoting
	# is based on last character position,
	# not animation sprite
	if player.current_state != "shoot":
		shot_direction.x = player.last_vector.x

	# set length of raycast and randomize in axis to add spread
	if shot_direction.y != 0:
		# horizontal spread when shooting up
		max_cast_to = (get_shot_direction() * MAX_LENGTH) + Vector2(rand_range(-10,10),0)
	else:
		# vertical spread when shooting sideways
		max_cast_to = (get_shot_direction() * MAX_LENGTH) + Vector2(0, rand_range(-10,10))
	
	# send the raycast to max length looking for collisions
	ray.cast_to = max_cast_to
	
	# check for collisions with raycast
	if ray.is_colliding():
		# set ray endpoint at first collision
		end.global_position = ray.get_collision_point()

		# if player is in firing mode check
		# what object is being collided with
		if player.current_state == "shoot":
			# set ray endpoint at first collision
			current_collider = ray.get_collider()
		
			# check if collision target is in enemies group
			if current_collider.is_in_group("enemies"):

				# check if player has ammo
				if player.ammo > 0:
					# emit signal if enemy was hit
					emit_signal("_on_hit_by_rifle", current_collider) 
			
			# destructible environment objects
			elif current_collider.is_in_group("destructibles"):
				# emit signal if destructible was hit
				emit_signal("_on_hit_by_rifle", current_collider) 
			
			else:
				pass
		
		# placeholder for enemies or objects reacting 
		# to being aimed at
		else:
			pass
	
	# if no collision set endpoint at max raycast length
	# (max weapon range)
	else:
		end.global_position = ray.cast_to
	
	# rotate sprite to match raycast
	beam.rotation = ray.cast_to.angle()

	# match sprite length to first ray collision
	beam.region_rect.end.x = end.position.length()
