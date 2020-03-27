extends CanvasLayer

onready var game_controller := get_node("/root/GameController")

func _on_Cherry_pressed():
	game_controller.build("cherry")
