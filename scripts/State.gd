class_name State
extends Node

@export
var animation_name: String

@export
var move_speed: float = 300
var rng = RandomNumberGenerator.new()

@onready
var is_done: bool = false

# Hold a reference to the parent so that it can be controlled by the state
var parent

func bool_randomize(max_val : int = 1) -> bool:
	rng.randomize()
	return bool(rng.randi_range(0, max_val))

func enter() -> void:
	parent.animations.play(animation_name)

func exit() -> void:
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	return null
