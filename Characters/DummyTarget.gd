extends KinematicBody2D

# set variables
var max_hp : int = 100
var hp : int = max_hp
var dead : bool = false

# load nodes
onready var player = get_parent().get_node("Player")
onready var rifle_beam = player.get_node("RifleBeam")
onready var active_sprite = get_node("Sprite")

# preload textures
var spr_full_hp = preload("res://Sprites/Characters/Dummy.png")
var spr_damaged = preload("res://Sprites/Characters/BrokenDummy.png")
var spr_dead = preload("res://Sprites/Characters/DeadDummy.png")

func _ready():
	rifle_beam.connect("_on_hit_by_rifle", self, "_on_hit_by_rifle")

func _on_hit_by_rifle(object):
	if not dead:
		# check if instance being collided
		# with is self
		if object == self:
			hp -= Globals.RIFLE_DMG

func _physics_process(_delta):
	# only check for damage if not dead
	if not dead:
		# if half damaged change texture to damaged
		if (hp < float(max_hp) / 2) and (hp > 0):
			get_node("Sprite").set_texture(spr_damaged)

		# set state as dead if hp falls to 0
		elif hp <= 0:
			die()
	
	# debug nodes
	if not dead:
		get_node("HPLabel").text = "HP: " + var2str(hp)
	else:
		get_node("HPLabel").text = "dead AF"

func die():
	# set dead state, disable collisions
	dead = true
	get_node("Sprite").set_texture(spr_dead)
	get_node("Hurtbox/CollisionShape2D").disabled = true
	get_node("CollisionShape2D").disabled = true
