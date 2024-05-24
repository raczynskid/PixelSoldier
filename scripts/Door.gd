extends Node2D

@onready
var area = $Area2D

@onready
var label = $Label

@onready
var interactable = false

@export
var target : String

func _ready():
	Signals.interact.connect(_on_interaction)

func _on_area_2d_body_entered(body):
	label.visible = true
	interactable = true

func _on_area_2d_body_exited(body):
	label.visible = false
	interactable = false

func _on_interaction():
	if interactable:
		Signals.swap_level.emit(target)
	
