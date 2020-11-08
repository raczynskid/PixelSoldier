extends KinematicBody2D

var hp : int = 100
var dead : bool = false
onready var player = get_parent().get_node("Player")
onready var rifle_beam = player.get_node("RifleBeam")

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
		if hp <= 0:
			die()
	
	# debug nodes
	if not dead:
		get_node("HPLabel").text = "HP: " + var2str(hp)
	else:
		get_node("HPLabel").text = "dead AF"

func die():
	# set dead state, disable collisions
	dead = true
	get_node("Hurtbox/CollisionShape2D").disabled = true
	get_node("CollisionShape2D").disabled = true
