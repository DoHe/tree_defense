extends Node2D

var startingSeed: int = 1000
var startingLife: int = 100
var seeds: int = startingSeed
var life: int = startingLife
var game_over: bool
var planting: String
var num_enemy_spawners: int
var level_num: int = 1
onready var cherry_cursor := preload("res://assets/trees/cherry_icon_pressed.png")
onready var ice_cursor := preload("res://assets/trees/ice_icon_pressed.png")
onready var big_cursor := preload("res://assets/trees/big_icon_cursor.png")
onready var tower_scene := preload("res://src/Objects/Tower.tscn")
var count_label
var life_progress
var wave_headline
var wave_text
var timer_label
var wave_label
var game_over_label
var enemy_spawner
var level

func _ready():
	reset()
	get_references()
	
func reset():
	seeds = startingSeed
	life = startingLife
	game_over = false
	planting = ""
	num_enemy_spawners = 0
	
func get_references():
	count_label = get_node("/root/Level/UI/Seeds/Container/SeedsLabel")
	life_progress = get_node("/root/Level/UI/Life/Container/LifeProgress")
	wave_headline = get_node("/root/Level/UI/Wave/WaveHeadline")
	wave_text = get_node("/root/Level/UI/Wave/WaveText")
	timer_label = get_node("/root/Level/UI/WaveInfo/Container/TimerLabel")
	wave_label = get_node("/root/Level/UI/WaveInfo/Container/WaveLabel")
	game_over_label = get_node("/root/Level/UI/GameOver/Label")
	enemy_spawner = get_node("/root/Level/EnemySpawner")
	level = get_node("/root/Level")
	update_seeds(0)
	update_life(0)
	update_wave_label("1")
	
func update_seeds(change: int) -> void:
	seeds += change
	count_label.text = String(seeds)
	
func update_life(change: int) -> void:
	life += change
	life_progress.value = life
	if life <= 0:
		player_died()
	
func player_died() -> void:
	get_tree().paused = true
	game_over = true
	game_over_label.text = "You lost :("
	game_over_label.visible = true
	
func register_enemy_spawner() -> void:
	num_enemy_spawners += 1
	
func all_enemies_gone() -> void:
	num_enemy_spawners -= 1
	if not num_enemy_spawners:
		level_num += 1
		if level_num > 2:
			game_over_label.text = "You won! :)"
			game_over_label.visible = true
			get_tree().paused = true
			return
		game_over_label.text = "You won this level, but here is more!"
		game_over_label.visible = true
		yield(get_tree().create_timer(3.0), "timeout")
		get_tree().change_scene("res://src/Levels/Level" + String(level_num) + ".tscn")
		reset()
		
func set_cursor(cursor):
	var cursor_size : Vector2 = cursor.get_size()
	Input.set_custom_mouse_cursor(
		cursor,
		0,
		Vector2(cursor_size.x/2, cursor_size.y)
	)
	
func build(tree: String) -> void:
	match tree:
		"cherry":
			if seeds < 500:
				return
			set_cursor(cherry_cursor)
		"ice":
			if seeds < 800:
				return
			set_cursor(ice_cursor)
		"big":
			if seeds < 1100:
				return
			set_cursor(big_cursor)
	planting = tree
			
func cancel_build():
	if not planting:
		return
		
	Input.set_custom_mouse_cursor(null)
	planting = ""

func plant(global_pos):
	if not planting:
		return
		
	match planting:
		"cherry":
			var cherry := tower_scene.instance()
			level.add_child(cherry)
			cherry.set_kind("cherry")
			var cursor_size : Vector2 = cherry_cursor.get_size()
			var offset := Vector2(0, cursor_size.y/4)
			cherry.global_position = global_pos - offset
			update_seeds(-500)
			cancel_build()
		"ice":
			var ice := tower_scene.instance()
			level.add_child(ice)
			ice.set_kind("ice")
			var cursor_size : Vector2 = ice_cursor.get_size()
			var offset := Vector2(0, cursor_size.y/4)
			ice.global_position = global_pos - offset
			update_seeds(-800)
			cancel_build()
		"big":
			var big := tower_scene.instance()
			level.add_child(big)
			big.set_kind("big")
			var cursor_size : Vector2 = big_cursor.get_size()
			var offset := Vector2(0, cursor_size.y/4)
			big.global_position = global_pos - offset
			update_seeds(-1100)
			cancel_build()
			
func show_wave(wave: int) -> void:
	var wave_str := String(wave)
	update_wave_label(wave_str)
	wave_text.text = wave_str
	wave_headline.visible = true
	wave_text.visible = true
	yield(get_tree().create_timer(3.0), "timeout")
	hide_wave()
	
func update_wave_label(wave: String) -> void:
	wave_label.text = "Level " + String(level_num) + " - Wave " + wave
	
func hide_wave() -> void:
	wave_headline.visible = false
	wave_text.visible = false
	
func update_timer(time: float) -> void:
	if not is_instance_valid(timer_label):
		return
	timer_label.text = "Time to next wave: %.2fs" % time
	
