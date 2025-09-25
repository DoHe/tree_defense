extends Node2D

@onready var nav_2d: NavigationRegion2D = %NavigationRegion2D
@onready var enemy_scene = preload("res://src/Objects/Enemy.tscn")
@onready var game_controller := get_node("/root/GameController")
@onready var truck_sprite = preload("res://assets/cars2/Cars/truck.png")
@onready var tractor_sprite = preload("res://assets/cars2/Cars/tractor.png")
@onready var towtruck_sprite = preload("res://assets/cars2/Cars/towtruck.png")

@export_file("*.json") var wave_config_path: String
@export var target_node_paths: Array[NodePath] = []
@export var initial_delay: float = 2
var wave_configs: Array
var wave_config: Dictionary
var since_wave: float = 0
var next_wave: float = 0
var wave: int = 0
var target_idx: int = 0
var targets: Array
var waves_done: bool = false
var num_spawned: int = 0


func _ready():
	for node_path in target_node_paths:
		targets.append(get_node(node_path))

	wave_configs = load_config(wave_config_path)
	wave_config = wave_configs[wave]
	next_wave = 0
	game_controller.register_enemy_spawner()


func load_config(file_path) -> Array:
	var file = FileAccess.open(file_path, FileAccess.READ)
	var test_json_conv = JSON.new()
	test_json_conv.parse(file.get_as_text())
	var config = test_json_conv.get_data()
	assert(config.size() > 0)
	return config


func _process(delta: float) -> void:
	if waves_done:
		return
	since_wave += delta

	if initial_delay:
		if since_wave < initial_delay:
			game_controller.update_timer(initial_delay - since_wave)
			return
		since_wave = 0
		initial_delay = 0

	if since_wave <= next_wave:
		game_controller.update_timer(next_wave - since_wave)
		return

	spawn_next_wave()
	since_wave = 0
	wave += 1
	if wave < len(wave_configs):
		wave_config = wave_configs[wave]
		next_wave = wave_config['break']
	else:
		waves_done = true


func enemy_died() -> void:
	num_spawned -= 1
	if num_spawned == 0 and waves_done:
		game_controller.all_enemies_gone()


func collect_enemies(enemies: Array) -> Array:
	var collected = []
	for enemy_config in enemies:
		for _i in range(int(enemy_config["count"])):
			collected.append(enemy_config["type"])
	return collected


func spawn_next_wave() -> void:
	game_controller.show_wave(wave + 1)
	var enemy_list = collect_enemies(wave_config["enemies"])
	spawn_enemies(
		enemy_list,
		wave_config["parallelism"],
		wave_config["frequency"],
	)


func spawn_enemies(types: Array, parallelism: int, frequency: float) -> void:
	var num_parallel = 0
	for type in types:
		spawn_enemy(type)
		num_parallel += 1
		var timeout = frequency
		if num_parallel < parallelism:
			timeout = 0.2
		else:
			num_parallel = 0
		await get_tree().create_timer(timeout).timeout


func spawn_enemy(type: String, starting_position: Vector2 = global_position) -> void:
	var enemy
	match type:
		"car":
			enemy = enemy_scene.instantiate()
		"truck":
			enemy = enemy_scene.instantiate()
			enemy.speed = 100
			enemy.worth = 120
			enemy.health = 200
			enemy.maxHealth = 200
			enemy.damage = 20
			enemy.set_texture(truck_sprite)
		"tractor":
			enemy = enemy_scene.instantiate()
			enemy.speed = 50
			enemy.worth = 180
			enemy.health = 700
			enemy.maxHealth = 700
			enemy.damage = 50
			enemy.set_texture(tractor_sprite)
		"towtruck":
			enemy = enemy_scene.instantiate()
			enemy.speed = 100
			enemy.worth = 200
			enemy.health = 300
			enemy.maxHealth = 300
			enemy.damage = 30
			enemy.set_texture(towtruck_sprite)
		_:
			return
	enemy.kind = type
	enemy.enemy_spawner = self
	add_child(enemy)
	enemy.global_position = starting_position
	enemy.set_movement_target(targets[target_idx].global_position)
	enemy.set_process(true)
	target_idx += 1
	if target_idx >= len(targets):
		target_idx = 0
	num_spawned += 1
