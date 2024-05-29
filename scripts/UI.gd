extends Control

@onready
var player = get_tree().get_nodes_in_group("Player")[0]

@onready
var ammo_bar = $TextureProgressBar

func _ready():
	ammo_bar.max_value = player.max_ammo

func _physics_process(delta):
	ammo_bar.value = player.ammo
