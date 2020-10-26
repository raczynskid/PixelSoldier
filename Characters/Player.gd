extends KinematicBody2D

var states_stack = []
var current_state = null
var fire = false

var velocity = Vector2.ZERO
var input_vector = Vector2.ZERO
var last_vector = Vector2.ZERO

onready var animationPlayer = get_node("AnimationPlayer")
onready var animationTree = get_node("AnimationTree")
onready var animationState = animationTree.get("parameters/playback")

func _ready():
	animationTree.active = true
	velocity = idle_state(input_vector)

func _physics_process(delta):

	# apply gravity to player
	velocity = gravity_modifiers(delta, velocity)

	# get arrow key inputs
	input_vector = get_movement_inputs()
	current_state = get_action_inputs()

	# prevent movement or idle if in shoot state
	if current_state == "shoot":
		velocity = shoot(input_vector)
	else:
		if input_vector.x != 0:
			# horizontal movement
			velocity = movement_state(delta, input_vector)
			# update to keep direction
			last_vector = input_vector
		else:
			# idle
			velocity = idle_state(last_vector)
		
		# check for jump input
		if input_vector.y > 0:
			velocity = jump(velocity)

	# apply velocity to player
	velocity = move_and_slide(velocity, Globals.UP)

	# debug labels
	get_node("Label").text = var2str(input_vector)
	get_node("Label2").text = var2str(velocity)
	get_node("Label3").text = var2str(current_state)
	

func get_movement_inputs():
	# get currnet movement vector from keyobard inptus
	
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_up") - Input.get_action_strength("ui_down")
	input_vector = input_vector.normalized()

	return input_vector

func get_action_inputs():
	# check for keyboard inputs for actions

	fire = Input.get_action_strength("fire")

	# if input pressed
	if fire:
		# if first shot, set animation according to last konwn movement direction
		if current_state != "shoot":
			animationTree.set("parameters/Shoot/blend_position", last_vector)
			animationState.travel('Shoot')
		return "shoot"

func idle_state(last_vector):
	# set idle animation according to last known movement direction

	current_state = "idle"
	animationTree.set("parameters/Idle/blend_position", last_vector.x)
	animationState.travel('Idle')

	# stop horizontal movement based on friction
	if is_on_floor():
		if velocity.x < 0:
			velocity.x += Globals.FRICTION
		if velocity.x > 0:
			velocity.x -= Globals.FRICTION
	return velocity

func movement_state(delta, input_vector):
	# set run animation based on keyboard inputs
	current_state = "move"
	animationTree.set("parameters/Run/blend_position", input_vector.x)
	animationState.travel('Run')

	# set horizontal velocity based on inputs and globals
	velocity.x += input_vector.x * Globals.ACCELERATION
	velocity.x = clamp(velocity.x, -Globals.MAX_SPEED, Globals.MAX_SPEED)
	return velocity

func gravity_modifiers(delta, velocity):
	# apply gravity if airborne

	if not is_on_floor():
		velocity.y += Globals.GRAVITY * delta
	else:
		velocity.y = 0
	return velocity

func jump(velocity):
	# apply upwards force if not airborne

	current_state = "jump"
	if is_on_floor():
		velocity.y -= Globals.JUMPFORCE
	return velocity

func shoot(input_vector):
	# base shoot state, animation is already initialized from get_movement_inputs()

	current_state = "shoot"

	# listen for keyboard input
	if input_vector != Vector2.ZERO:
		# use animation tree blendspace to apply direction to shooting animation
		animationTree.set("parameters/Shoot/blend_position", input_vector)
		animationState.travel('Shoot')
	
	# remove any horizontal speed if remaining
	if is_on_floor():
		if velocity.x < 0:
			velocity.x += Globals.FRICTION
		if velocity.x > 0:
			velocity.x -= Globals.FRICTION
	return velocity


