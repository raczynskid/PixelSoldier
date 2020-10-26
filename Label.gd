extends Label

func _ready():
	get_parent.get_node("States").get_node("Shoot").text = var2str(v)
