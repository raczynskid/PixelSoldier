extends Position2D

# set up vectors
onready var player = get_parent()
var camera_vector = Vector2.ZERO
var last_vector = Vector2.ZERO
var shot_direction = Vector2.ZERO

func _ready():
	update_pivot_angle()

func _physics_process(_delta):
	update_pivot_angle()

# listen for animation signals when shooting
func shoot_up():
	shot_direction = Vector2(0, -1)

func shoot_left():
	shot_direction = Vector2(-1, 0)

func shoot_right():
	shot_direction = Vector2(1, 0)

func update_pivot_angle():

	# if not in shooting state,
	# pre-set camera to last player vector
	# avoids camera shake on shooting after pivot
	if player.current_state != "shoot":
		shot_direction.x = player.last_vector.x

	# update camera pivot dynamically
	# if player is in shooting state
	if player.current_state == "shoot":

		# set camera vector to current shot direction
		# based on animation method calls
		camera_vector = shot_direction

		# update player last direction according to
		# animation method calls
		# might need a rework for encapsulation
		# (affecting parent state)
		player.last_vector = camera_vector

	else:

		# if player is in movement state set camera vector
		# according to last horizontal velocity of player
		camera_vector = Vector2(player.last_vector.x, 0)
	
	# apply the rotation to camera
	rotation = camera_vector.angle()
	