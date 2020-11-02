extends Node2D

# set max length of raycast
const MAX_LENGTH = 500

# load raycast nodes
onready var beam = get_node("Beam")
onready var end = get_node("End")
onready var ray = get_node("RayCast2D")
onready var input_vector = get_parent().input_vector
onready var last_shot_direction = Vector2.ZERO
onready var shot_direction = Vector2(1,0)

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

	# set length of raycast
	var max_cast_to = get_shot_direction() * MAX_LENGTH
	ray.cast_to = max_cast_to
	
	# set ray endpoint at first collision
	if ray.is_colliding():
		end.global_position = ray.get_collision_point()
	else:
		end.global_position = ray.cast_to
	
	# rotate sprite to match raycast
	beam.rotation = ray.cast_to.angle()

	# match sprite length to first ray collision
	beam.region_rect.end.x = end.position.length()
