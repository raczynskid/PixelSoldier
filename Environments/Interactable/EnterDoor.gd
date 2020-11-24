extends Area2D

func _on_EnterDoor_body_entered(body):
	if body.name == "Player":
		  body.active_door = get_parent().destination

func _on_EnterDoor_body_exited(body):
	if body.name == "Player":
		body.active_door = null
	
