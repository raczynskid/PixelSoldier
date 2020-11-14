extends Control

func _ready():
	var new_game = get_node("Menu/CenterRow/Buttons/NewGameButton")
	new_game.connect("pressed", self, "_on_Button_pressed", [new_game.scene_to_load])

func _on_Button_pressed(scene_to_load):
	get_tree().change_scene(scene_to_load)
