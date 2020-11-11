extends Position2D

# set up vectors
onready var player = get_parent()
onready var hurtbox = get_node("knife_hurtbox/CollisionShape2D")
onready var hurtbox_area = get_node("knife_hurtbox")
var last_vector : Vector2
const MELEE_RANGE = 4

func _ready():
	last_vector = player.last_vector
	hurtbox.disabled = true

func _physics_process(_delta):
	update_pivot_angle()
	

func update_pivot_angle():
	last_vector = player.last_vector
	position.x = MELEE_RANGE * last_vector.x

func start_stab():
	hurtbox.disabled = false

func end_stab():
	hurtbox.disabled = true
