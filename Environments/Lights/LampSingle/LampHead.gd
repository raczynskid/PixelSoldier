extends RigidBody2D

var hp = Globals.LAMP_HP
var destroyed : bool = false
onready var joint = get_node("PinJoint2D")
onready var destroy_effect = get_node("ElectricEffect")
onready var light = get_node("Light2D")

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
	# if lamphead gets destroyed
	if not destroyed:
		# show flashing electricity effect
		destroy_effect.visible = true
		# play electricity animation
		destroy_effect.play()
		light.enabled = false
		remove_child(joint)
		apply_impulse(Vector2.ZERO, Vector2(10, 0))
		
