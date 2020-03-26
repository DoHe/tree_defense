extends Node2D

onready var target_area : Area2D = $Range
onready var bulletScene = preload("res://src/Objects/Bullet.tscn")

export var shot_frequency : float = 0.5
export var max_bullets : int = 1
var since_shot : float = 0.0

func _process(delta: float) -> void:
	since_shot += delta
	if since_shot < shot_frequency:
		return
		
	var targets : = target_area.get_overlapping_areas()
	for target in targets:
		if !target.is_in_group("enemies"):
			continue
		if len(get_children()) >= 2 + max_bullets:
			continue 
		var bullet = bulletScene.instance()
		add_child(bullet)
		bullet.start(transform, target)
	since_shot = 0

func _on_Area2D_area_entered(_area: Area2D) -> void:
	pass
	
func _on_Area2D_area_exited(_area: Area2D) -> void:
	pass
