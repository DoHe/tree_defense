extends Node

onready var game_controller := get_node("/root/GameController")

func _input(event: InputEvent) -> void:
	if not event is InputEventMouseButton:
		return
	
	if event.button_index != BUTTON_RIGHT or not event.pressed:
		return
		
	game_controller.cancel_build()
