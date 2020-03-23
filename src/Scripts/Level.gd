extends Node

onready var nav_2d: Navigation2D = $Navigation2D
# onready var enemy: Node2D = $Enemy
onready var camera: Camera = $Camera

func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventMouseButton:
		return
	
	if event.button_index != BUTTON_LEFT or not event.pressed:
		return

	# var new_path : = nav_2d.get_simple_path(
	#	enemy.global_position,
	#	camera.get_global_mouse_position()
	#)
	# enemy.path = new_path

