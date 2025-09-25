extends Node

@onready var game_controller := get_node("/root/GameController")

func _ready():
	game_controller.get_references()

func _input(event: InputEvent) -> void:
	if not event is InputEventMouseButton:
		return
	
	if event.button_index != MOUSE_BUTTON_RIGHT or not event.pressed:
		return
		
	game_controller.cancel_build()
