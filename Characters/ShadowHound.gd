extends KinematicBody2D

# load vectors
var velocity = Vector2.ZERO
var last_vector = Vector2(-1,0)

# set variables
var max_hp : int = Globals.SHADOWHOUND_MAX_HP
var hp : int = max_hp
var dead : bool = false
const Cooldown = preload('res://Scripts/Cooldown.gd')
var current_state = null

# load nodes
onready var player = get_parent().get_node("Player")
onready var rifle_beam = player.get_node("RifleBeam")
onready var active_sprite = get_node("Sprite")
onready var playerDetectionZone = get_node("PlayerDetectionZone")

# load animation nodes
onready var animationPlayer = get_node("FullHPAnimationPlayer")
onready var animationTree = get_node("AnimationTree")
onready var animationState = animationTree.get("parameters/playback")

func _ready():
	
	rifle_beam.connect("_on_hit_by_rifle", self, "_on_hit_by_rifle")
	animationTree.active = true
	animationTree.set("parameters/Idle/blend_position", last_vector.x)
	animationState.travel("Idle")

func _physics_process(delta):

	# only check for damage if not dead
	if not dead:

		# apply gravity to kinematic body
		# only when not dead - workaround because same
		# collision shape used for physics and combat
		if current_state == null:

			# check for player entering
			# detection zone if in idle state

			seek_player()
		elif current_state == "chase":
			# if player found

			var target_player = playerDetectionZone.player
			if target_player != null:
				# if player is found
				# establish vector between self and player position
				var direction = (player.global_position - global_position).normalized()
				# move towards player
				velocity = velocity.move_toward(direction * Globals.SHADOWHOUND_MAX_SPEED, Globals.ACCELERATION * delta)
			else:
				# if player exited detection zone, stop
				velocity = Vector2.ZERO
		
		pick_animation(velocity)
		velocity = gravity_modifiers(delta, velocity)

		# if half damaged change texture to damaged
		if (hp < float(max_hp) / 2) and (hp > 0):
			pass
			#get_node("Sprite").set_texture(spr_damaged)

		# set state as dead if hp falls to 0
		elif hp <= 0:
			die()
	
	# apply velocity to kinematicbody2D
	velocity = move_and_slide(velocity, Globals.UP)

	# debug nodes
	if not dead:
		get_node("HPLabel").text = "HP: " + var2str(hp)
		get_node("Label").text = var2str(velocity)
	else:
		get_node("HPLabel").text = "dead AF"

func die():
	# set dead state
	dead = true

	# disable collisions
	get_node("Hurtbox/CollisionShape2D").disabled = true

	# play death animation
	animationTree.set("parameters/Die/blend_position", last_vector.x)
	animationState.travel("Die")

	# disable physics collisions
	get_node("CollisionShape2D").disabled = true
	velocity = Vector2.ZERO

func gravity_modifiers(delta, vector):
	# vector : velocity
	# return : Vector2
	# apply gravity if airborne
	if not is_on_floor():
		vector.y += Globals.GRAVITY * delta
	else:
		vector.y = 0
	return vector

func _on_hit_by_rifle(object):
	if not dead:
		# check if instance being collided
		# with is self
		if object == self:
			hp -= Globals.RIFLE_DMG

func hit_by_melee():
# called from Player/ActionPivot/knife_hurtbox signal
# interface method static name

	# check for damage only if not dead
	if not dead:
		# decrease hp by global melee dmg
		hp -= Globals.MELEE_DMG

func seek_player():
	# use detection zone to check if player in range
	if playerDetectionZone.can_see_player():
		current_state = "chase"

func pick_animation(velocity):
	if velocity.x == 0:
		animationTree.set("parameters/Idle/blend_position", last_vector.x)
		animationState.travel("Idle")
	elif (abs(velocity.x) > 0) and (abs(velocity.x) < 50):
		animationTree.set("parameters/Walk/blend_position", last_vector.x)
		animationState.travel("Walk")
	elif (abs(velocity.x) > 50):
		animationTree.set("parameters/Run/blend_position", last_vector.x)
		animationState.travel("Run")