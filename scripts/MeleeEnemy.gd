class_name MeleeEnemy
extends CharacterBody2D

@export
var max_speed = 400
@export
var hp : int = 3
@onready
var animations = $AnimatedSprite2D
@onready
var state_machine = $StateMachine
@onready
var raycast_nav = $NavigationRaycast
@onready
var raycast_attack = $AttackRaycast
@onready
var raycast_ground = $GroundRaycast
@onready
var hitbox = $Hitbox/CollisionShape2D
@onready
var collisions = $CollisionShape2D

@onready
var player_target = get_tree().get_nodes_in_group("Player")[0]

var orientation = 0

@onready
var debug = $Debug
@onready
var debug2 = $Debug2

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	# Initialize the state machine, passing a reference of the player to the states,
	# that way they can move and react accordingly
	state_machine.init(self)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	debug.text = state_machine.current_state.get_name()
	debug2.text = str(hp)
	state_machine.process_physics(delta)
	velocity.y += gravity * delta
	move_and_slide()

func _process(delta: float) -> void:
	state_machine.process_frame(delta)
