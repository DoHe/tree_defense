extends Node2D

@onready var game_controller := get_node("/root/GameController")


func _on_Area2D_area_shape_entered(_area_id, area, _area_shape, _self_shape):
	if !area.is_in_group("enemies"):
		return
	var enemy = area.get_parent()
	game_controller.update_life(-enemy.damage)
	enemy.died()
	enemy.queue_free()
