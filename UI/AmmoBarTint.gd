extends TextureProgress

func _physics_process(_delta):
	# set color based on remaining ammo
	set_tint_progress(Color(1,value/100,value/100))
