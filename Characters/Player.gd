extends KinematicBody2D

const Cooldown = preload('res://Scripts/Cooldown.gd')

var states_stack = []
var current_state = null
var fire : float
var roll : float
var slide : float
var roll_enabled = true
var can_shoot = true
var ammo = Globals.RIFLE_MAX_AMMO

# load vectors
var velocity = Vector2.ZERO
var input_vector = Vector2.ZERO
var last_vector = Vector2.ZERO
var air_acceleration = Globals.ACCELERATION / 12

# load timers
onready var roll_cooldown = Cooldown.new(3)
onready var beam_cooldown = Cooldown.new(0.1)

# load animation nodes
onready var animationPlayer = get_node("AnimationPlayer")
onready var animationTree = get_node("AnimationTree")
onready var animationState = animationTree.get("parameters/playback")

# load misc nodes
onready var beam = get_node("RifleBeam")

func _ready():
	animationTree.active = true
	velocity = Vector2(0,0)
	roll_cooldown.max_time = 0.3

func _physics_process(delta):

	# apply gravity to player
	velocity = gravity_modifiers(delta, velocity)

	# get arrow key inputs
	input_vector = get_movement_inputs()
	current_state = get_action_inputs(delta)

	# prevent movement or idle if in shoot state
	# call methods based on state machine
	if current_state == "shoot":
		velocity = shoot(input_vector, delta)
	elif current_state == "roll":
		velocity = roll_state(velocity)
	elif current_state == "slide":
		velocity = slide_state(velocity)
	else:
		# if no action state is applied
		# but movement controls are pressed
		# go into movement state
		if input_vector.x != 0:

			# horizontal movement
			velocity = movement_state(input_vector)

			# update to keep facing last movement direction
			# can be overwritten by animation method calls
			last_vector = input_vector
		else:
			# stop horizontal movement based on friction if grounded
			if is_on_floor():
				velocity.x = int(round(lerp(velocity.x, 0, 0.25)))

				# shed remainder of velocity regardless of direction
				if abs(velocity.x) == 2:
					velocity.x = 0
			else:
				# idle
				idle_state(last_vector)

		# check for jump input
		if input_vector.y > 0:
			velocity = jump(velocity)

	# apply velocity to player
	velocity = move_and_slide(velocity, Globals.UP)

	# debug labels
	get_node("Label").text = "ammo " + var2str(ammo)
	get_node("Label2").text = "last " + var2str(last_vector.x)
	get_node("Label3").text = var2str(current_state)
	

func get_movement_inputs():
	# get current movement vector from keyobard inptus
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_up") - Input.get_action_strength("ui_down")
	input_vector = input_vector.normalized()

	return input_vector

func get_action_inputs(delta):
	# tick cooldowns
	roll_cooldown.tick(delta)
	beam_cooldown.tick(delta)

	# check for keyboard inputs for actions
	fire = Input.get_action_strength("fire")
	roll = Input.get_action_strength("ui_down")
	slide = Input.get_action_strength("slide")

	# if input pressed
	if fire:
		# check if shooting enabled
		if can_shoot:
			# if first shot, set animation according to last known movement direction
			if current_state != "shoot":
				animationTree.set("parameters/Shoot/blend_position", last_vector)
				animationState.travel('Shoot')
			return "shoot"
	else:
		idle_state(last_vector)
		beam.get_node("Beam").visible = false
		beam.get_node("End/Ricochet").emitting = false
		
	if roll:
		# check if roll is not in cooldown
		if roll_cooldown.is_ready():
			# use animation tree blendspace to apply last direction to roll animation
			if current_state != "roll":
				animationTree.set("parameters/Roll/blend_position", last_vector.x)
				animationState.travel("Roll")
			# perform roll in directon currently facing
			elif current_state == "slide":
				animationTree.set("parameters/Slide/blend_position", last_vector.x)
				animationState.travel("Slide")
			return "roll"
	
	if slide:
		# slide only when max velocity on the floor
		if current_state != "slide":
			animationTree.set("parameters/Slide/blend_position", velocity.x)
			animationState.travel("Slide")
			# perform slide in direction of movement
			return "slide"

func idle_state(vector):
	# vector : last_vector
	# return null
	# set idle animation according to last known movement direction
	current_state = "idle"
	animationTree.set("parameters/Idle/blend_position", vector.x)
	animationState.travel('Idle')

func movement_state(vector):
	# vector : input_vector
	# return null
	# set run animation based on keyboard inputs
	current_state = "move"
	animationTree.set("parameters/Run/blend_position", vector.x)
	animationState.travel('Run')

	# set horizontal velocity based on inputs and globals
	if is_on_floor():
		# increase horizontal velocity by acceleration factor
		velocity.x += vector.x * Globals.ACCELERATION
		# limit to max speed
		velocity.x = clamp(velocity.x, -Globals.MAX_SPEED, Globals.MAX_SPEED)
	else:
		# use lower acceleration if airborne
		velocity.x += vector.x * air_acceleration
		# limit to max speed
		velocity.x = clamp(velocity.x, -Globals.MAX_SPEED, Globals.MAX_SPEED)

	return velocity.floor()

func gravity_modifiers(delta, vector):
	# vector : velocity
	# return : Vector2
	# apply gravity if airborne
	if not is_on_floor():
		vector.y += Globals.GRAVITY * delta
	else:
		vector.y = 0
	return vector

func jump(vector):
	# vector : velocity
	# return : Vector2
	# apply upwards force if not airborne
	current_state = "jump"
	if is_on_floor():
		if abs(vector.x) > 20:
			vector.y -= clamp(abs(vector.x) * 5, 100, Globals.JUMPFORCE)
		else:
			vector.y -= Globals.JUMPFORCE
	return vector

func roll_state(vector):
	# vector : velocity
	# return : Vector2
	# perform combat roll
	current_state = "roll"
	animationTree.set("parameters/Roll/blend_position", last_vector.x)
	animationState.travel('Roll')

	# disable shooting for time of roll
	can_shoot = false

	# roll from idle
	if vector.x == 0:
		if last_vector.x > 0:
			vector.x = Globals.MAX_SPEED / 2
		if last_vector.x < 0:
			vector.x = -(Globals.MAX_SPEED / 2)

	# roll from movement
	else:
		# keep current movement vector if input is applied
		animationTree.set("parameters/Roll/blend_position", input_vector.x)
		animationState.travel('Roll')

		# slightly increase speed for duration of roll
		if vector.x != 0:
			if last_vector.x > 0:
				vector.x = Globals.MAX_SPEED * 1.5
			if last_vector.x < 0:
				vector.x = -(Globals.MAX_SPEED * 1.5)
		
	
	return vector

func end_roll():
	# called on animation end
	# return to idle

	# reset cooldown timer
	roll_cooldown.reset()

	# if roll ends on the floor, decrease horizontal speed to 1/3rd
	if is_on_floor():
		velocity.x = velocity.x / 3

	# reenable shooting
	can_shoot = true

func slide_state(vector):
	# vector : velocity
	# return : Vector2
	# perform slide

	# set state
	current_state = "slide"

	# set animation blend
	animationTree.set("parameters/Slide/blend_position", vector.x)
	animationState.travel('Slide')

	# shed horizontal speed
	if vector.x > 0:
		vector.x = int(round(lerp(vector.x, -50, 0.01)))
	elif vector.x < 0:
		vector.x = int(round(lerp(vector.x, 50, 0.01)))
	roll_cooldown.reset()
	return vector

func end_slide():
	pass

func shed_speed(vector):
	# vector : velocity
	# return : Vector2
	# remove any horizontal speed if remaining
	if is_on_floor():
		vector.x = int(round(lerp(vector.x, 0, 0.1)))
		# drop remaining velocity
		if abs(vector.x) == 5:
			vector.x = 0
	
	return vector

func shoot(vector, delta):
	# vector : input_vector
	# return : Vector2

	# base shoot state, animation is already initialized from get_movement_inputs()
	current_state = "shoot"

	if ammo > 0:

		# start emitting ricochet particles
		beam.get_node("End/Ricochet").emitting = true

		# listen for keyboard input
		if vector != Vector2.ZERO:

			# use animation tree blendspace to apply direction to shooting animation
			animationTree.set("parameters/Shoot/blend_position", vector)
			animationState.travel('Shoot')
		
		# hide and show sprite of bullet trace
		if beam.get_node("Beam").visible:
			beam.get_node("Beam").visible = false
		else:
			# wait for timer for slower flicker
			if beam_cooldown.is_ready():
				beam.get_node("Beam").visible = true
				beam_cooldown.reset()
		
		ammo -= 1
	
	else:
		# stop emitting particles
		beam.get_node("End/Ricochet").emitting = false
	
	return shed_speed(velocity)


