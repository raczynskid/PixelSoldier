extends Area2D

var player = null

func can_see_player():
	return player != null

func _on_LadderArea_body_entered(body):
	
	if body.name == "Player":
		body.can_climb = true

func _on_LadderArea_body_exited(body):
	if body.name == "Player":
		body.can_climb = false
