extends Node2D

@onready var target_area: Area2D = $Range
@onready var sprite: Sprite2D = $tree/TreeSprite
@onready var circle: Sprite2D = $Range/circle
@onready var bullet_scene = preload("res://src/Objects/Bullet.tscn")
@onready var ice_texture := preload("res://assets/trees/ice_left.png")
@onready var big_texture := preload("res://assets/trees/big_tree.png")

@export var shot_frequency: float = 0.5
@export var max_bullets: int = 1
var since_shot: float = 0.0
var kind: String = "cherry"


func _process(delta: float) -> void:
	since_shot += delta
	if since_shot < shot_frequency:
		return

	shoot()


func shoot():
	var targets := target_area.get_overlapping_areas()
	var shots = 0
	for target in targets:
		if !target.is_in_group("enemies"):
			continue
		if len(get_children()) >= 2 + max_bullets:
			continue
		var bullet = bullet_scene.instantiate()
		bullet.set_kind(kind)
		bullet.start(transform, target)
		call_deferred("add_child", bullet)
		shots += 1
	if shots:
		since_shot = 0


func _on_Area2D_area_entered(_area: Area2D) -> void:
	if shot_frequency < since_shot:
		shoot()


func _on_Area2D_area_exited(_area: Area2D) -> void:
	pass


func set_kind(knd: String):
	kind = knd
	match knd:
		"cherry":
			target_area.transform = target_area.transform.scaled(Vector2(0.8, 0.8))
		"ice":
			sprite.texture = ice_texture
			shot_frequency = 1
			target_area.transform = target_area.transform.scaled(Vector2(0.9, 0.9))
			max_bullets = 2
		"big":
			sprite.texture = big_texture
			shot_frequency = 2.5
			target_area.transform = target_area.transform.scaled(Vector2(1, 1))
			max_bullets = 1


func _on_tree_mouse_entered():
	circle.visible = true


func _on_tree_mouse_exited():
	circle.visible = false
