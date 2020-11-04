extends Position2D

onready var player = get_parent()
var camera_vector = Vector2.ZERO
var last_vector = Vector2.ZERO
var shot_direction = Vector2.ZERO

func _ready():
	update_pivot_angle()

func _physics_process(_delta):
	update_pivot_angle()

func shoot_up():
	shot_direction = Vector2(0, -1)

func shoot_left():
	shot_direction = Vector2(-1, 0)

func shoot_right():
	shot_direction = Vector2(1, 0)

func update_pivot_angle():

	if player.current_state == "shoot":
		camera_vector = shot_direction
		player.last_vector = camera_vector
	else:
		camera_vector = Vector2(player.last_vector.x, 0)
	
		
	rotation = camera_vector.angle()

