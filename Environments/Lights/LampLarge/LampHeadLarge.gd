extends RigidBody2D

var hp = Globals.LAMP_HP
var destroyed : bool = false
onready var destroy_effect = get_node("ElectricEffect")
onready var light = get_node("Light2D")
onready var jointLeft = get_node("PinJoint2DLeft")
onready var jointRight = get_node("PinJoint2DRight")
var destroy_joint_scenario : int

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

func drop_random_joint():
	# pick a random scanario for breaking the cables
	destroy_joint_scenario = randi()%4+1
	match destroy_joint_scenario:
		1:
			# only left cable breaks
			remove_child(jointLeft)
		2:
			# only left cable breaks
			remove_child(jointRight)
		3:
			# both cables break
			remove_child(jointLeft)
			remove_child(jointRight)
		4:  
			# nothing happens
			pass

func destroy():
	# if lamphead gets destroyed
	if not destroyed:
		# show flashing electricity effect
		destroy_effect.visible = true
		# play electricity animation
		destroy_effect.play()
		light.enabled = false
		drop_random_joint()
		apply_impulse(Vector2.ZERO, Vector2(10, 0))
		
