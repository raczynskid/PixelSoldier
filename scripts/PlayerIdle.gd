extends State

@export
var jump_state : State

@export
var run_state : State

@export
var shoot_state : State

@export
var h_intertia : int = 5

@onready
var shoot : Node = $"../Shoot"

@onready
var misc : Node = $"../Misc"

func process_physics(_delta: float) -> State:
	if parent.velocity.x:
		misc.decelerate(_delta)
	
	if Input.is_action_just_pressed("jump"):
		return jump_state
	if Input.is_action_pressed('shoot') and parent.is_on_floor():
		shoot.shoot(self.get_name())
	else:
		parent.animations.play(animation_name)
	if Input.is_action_pressed('ui_left') or Input.is_action_pressed('ui_right'):
		return run_state
	return null
