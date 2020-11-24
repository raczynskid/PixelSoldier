extends Light2D

func _physics_process(delta):
    rotate(delta * 8)