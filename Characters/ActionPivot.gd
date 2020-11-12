extends Position2D

# set up vectors
onready var player = get_parent()
onready var hurtbox = get_node("knife_hurtbox/CollisionShape2D")
onready var hurtbox_area = get_node("knife_hurtbox")
var last_vector : Vector2
const MELEE_RANGE = 4

func _ready():
	# get last direction of player
	last_vector = player.last_vector
	# start with hurtbox disabled
	hurtbox.disabled = true

func _physics_process(_delta):
	update_pivot_angle()
	
func update_pivot_angle():
	# set direction to last facing
	last_vector = player.last_vector
	# pivot the hurtbox according to direction
	position.x = MELEE_RANGE * last_vector.x

# animation signal calls
func start_stab():
	hurtbox.disabled = false

func end_stab():
	hurtbox.disabled = true
