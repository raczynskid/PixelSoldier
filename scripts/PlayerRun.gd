class_name PlayerRun
extends State

@export
var idle_state : State

@export
var jump_state : State

@export
var roll_state : State

@onready
var shoot : Node = $"../Shoot"

@onready
var misc : Node = $"../Misc"

func process_physics(_delta: float) -> State:
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if Input.is_action_pressed("shoot"):
		shoot.shoot(self.get_name())
	else:
		parent.animations.play(animation_name)
		
	if Input.is_action_just_pressed("jump"):
		return jump_state
		
	if input_direction.x:
		parent.scale.x = parent.scale.y * (-1 if input_direction.x <0 else 1)
		if Input.is_action_just_pressed("ui_down"):
			return roll_state
		if abs(parent.velocity.x) < parent.max_speed:
			parent.velocity.x += input_direction.x * _delta * move_speed
		if (parent.velocity.x * input_direction.x) < 0:
			misc.decelerate(_delta)
		return null
		
	return idle_state
