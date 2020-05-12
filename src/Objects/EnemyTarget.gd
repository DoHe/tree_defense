extends Node2D

onready var game_controller := get_node("/root/GameController")

func _on_Area2D_area_shape_entered(area_id, area, area_shape, self_shape):
	game_controller.update_life(-10)
	print("Killing: ", area.get_parent())
	area.get_parent().queue_free()
