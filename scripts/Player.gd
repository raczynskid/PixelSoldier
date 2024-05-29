class_name Player
extends CharacterBody2D

@export
var max_speed = 400
@export
var max_hp : int = 100
@export
var hp : int = max_hp
@export
var max_ammo = 100
@onready
var ammo = max_ammo
@onready
var animations = $AnimatedSprite2D
@onready
var state_machine = $StateMachine
@onready
var raycast_shoot = $RayCast2D
@onready
var reload_timer = $ReloadTimer

var is_dead : bool = false
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
	Signals.player_hit.connect(_on_hit)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	debug.text = state_machine.current_state.get_name()
	debug2.text = str(reload_timer.time_left)
	if not is_dead:
		state_machine.process_physics(delta)
	velocity.y += gravity * delta
	move_and_slide()

func _process(delta: float) -> void:
	state_machine.process_frame(delta)

func _on_hit(damage):
	if not is_dead:
		hp -= damage
		if hp <= 0:
			$StateMachine/Misc.die()
