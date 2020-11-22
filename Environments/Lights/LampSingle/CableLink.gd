extends RigidBody2D

var hp = Globals.CABLE_HP
var destroyed : bool = false
onready var joint = get_node("PinJoint2D")

func _ready():
	var player = get_tree().get_current_scene().get_node("Player")
	var rifle_beam = player.get_node("RifleBeam")
	
	rifle_beam.connect("_on_hit_by_rifle", self, "_on_hit_by_rifle")

func _on_hit_by_rifle(object):
	# check if instance being collided
	# with is self
	if object == self:
		hp -= Globals.RIFLE_DMG

func _physics_process(_delta):
	if hp <= 0:
		destroy()
		destroyed = true

func destroy():
	if not destroyed:
		remove_child(joint)
		apply_impulse(Vector2.ZERO, Vector2(10, 0))
