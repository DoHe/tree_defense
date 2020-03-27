extends Node2D

onready var nav_2d: Navigation2D = get_node("/root/Level/Navigation2D")
onready var enemy_scene = preload("res://src/Objects/Enemy.tscn")

export (Array, NodePath) var target_node_paths
export var spawn_frequency = 3
export var initial_delay = 3
var since_spawn : float = 0
var target_idx : int = 0
var targets : Array

func _process(delta: float) -> void:
	since_spawn += delta
	if initial_delay:
		if since_spawn > initial_delay:
			initial_delay = 0
			since_spawn = spawn_frequency
		else:
			return
	if since_spawn < spawn_frequency:
		return
	spawn()
	since_spawn = 0

func spawn() -> void:
	if not targets and not target_node_paths:
		return
		
	if not targets:
		for node_path in target_node_paths:
			targets.append(get_node(node_path))

	var enemy = enemy_scene.instance()
	add_child(enemy)
	var path : = nav_2d.get_simple_path(
		enemy.global_position,
		targets[target_idx].global_position
	)
	var normalized_path = PoolVector2Array([])
	for point in path:
		normalized_path.append(to_local(point))
	enemy.path = normalized_path
	target_idx += 1
	if target_idx >= len(targets):
		target_idx = 0
