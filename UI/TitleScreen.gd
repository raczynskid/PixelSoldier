extends Control

func _ready():
	# get button object
	var new_game = get_node("Menu/CenterRow/Buttons/NewGameButton")

	# listen for signal from the button
	# scene_to_load : .tscn file path
	new_game.connect("pressed", self, "_on_Button_pressed", [new_game.scene_to_load])

func _on_Button_pressed(scene_to_load):
	# change scene on load
	get_tree().change_scene(scene_to_load)
