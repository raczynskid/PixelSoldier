extends Node2D

@export
var start_level : String

@onready
var map = $Map

func _ready():
	Signals.swap_level.connect(swap_level)
	load_level(start_level)

func load_level(level : String) -> void:
	var level_to_load = load(level).instantiate()
	map.add_child(level_to_load)

func swap_level(to_level : String) -> void:
	for child in map.get_children():
		child.queue_free()
	load_level(to_level)
	
