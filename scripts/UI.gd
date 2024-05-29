extends Control

@onready
var player = get_tree().get_nodes_in_group("Player")[0]

@onready
var ammo_bar = $HBoxContainer/AmmoBar
@onready
var health_bar = $HBoxContainer/HealthBar

func _ready():
	ammo_bar.max_value = player.max_ammo
	health_bar.max_value = player.max_hp

func _physics_process(delta):
	ammo_bar.value = player.ammo
	health_bar.value = player.hp
	health_bar.set_tint_progress(Color(1,health_bar.value/100,health_bar.value/100))
