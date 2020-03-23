extends Node2D

onready var nav_2d: Navigation2D = get_node("/root/Level/Navigation2D")
onready var enemyScene = preload("res://src/Objects/Enemy.tscn")

export (NodePath) var targetNodePath
export var spawn_frequency = 3
var since_spawn : float = 0
onready var target = get_node(targetNodePath)

func _process(delta: float) -> void:
	since_spawn += delta
	if since_spawn < spawn_frequency:
		return
	spawn()
	since_spawn = 0

func spawn() -> void:
	var enemy = enemyScene.instance()
	add_child(enemy)
	var path : = nav_2d.get_simple_path(
		enemy.global_position,
		target.global_position
	)
	enemy.path = path
