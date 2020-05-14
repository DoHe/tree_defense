extends Node2D

var seeds: int = 1000
var life: int = 100
var game_over: bool = false
var planting: String = ""
var num_enemy_spawners: int = 0
onready var cherry_cursor := preload("res://assets/trees/cherry_icon_pressed.png")
onready var ice_cursor := preload("res://assets/trees/ice_icon_pressed.png")
onready var big_cursor := preload("res://assets/trees/big_icon_pressed.png")
onready var tower_scene := preload("res://src/Objects/Tower.tscn")
onready var count_label := get_node("/root/Level/UI/Seeds/Container/SeedsLabel")
onready var life_progress := get_node("/root/Level/UI/Life/Container/LifeProgress")
onready var wave_headline := get_node("/root/Level/UI/Wave/WaveHeadline")
onready var wave_text := get_node("/root/Level/UI/Wave/WaveText")
onready var timer_label := get_node("/root/Level/UI/WaveInfo/Container/TimerLabel")
onready var wave_label := get_node("/root/Level/UI/WaveInfo/Container/WaveLabel")
onready var game_over_label := get_node("/root/Level/UI/GameOver/Label")
onready var enemy_spawner := get_node("/root/Level/EnemySpawner")
onready var level := get_node("/root/Level")

func _ready():
	update_seeds(0)
	update_life(0)
	
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
	
func restart_level() -> void:
	seeds = 0
	game_over = false
	get_tree().paused = false
	get_tree().reload_current_scene()
	
func register_enemy_spawner() -> void:
	num_enemy_spawners += 1
	
func all_enemies_gone() -> void:
	num_enemy_spawners -= 1
	if not num_enemy_spawners:
		game_over_label.visible = true
	
func build(tree: String) -> void:
	match tree:
		"cherry":
			if seeds < 500:
				return
			planting = tree
			var cursor_size : Vector2 = cherry_cursor.get_size()
			Input.set_custom_mouse_cursor(
				cherry_cursor,
				0,
				Vector2(cursor_size.x/2, cursor_size.y)
			)
		"ice":
			if seeds < 800:
				return
			planting = tree
			var cursor_size : Vector2 = ice_cursor.get_size()
			Input.set_custom_mouse_cursor(
				ice_cursor,
				0,
				Vector2(cursor_size.x/2, cursor_size.y)
			)
		"big":
			if seeds < 1000:
				return
			planting = tree
			var cursor_size : Vector2 = big_cursor.get_size()
			Input.set_custom_mouse_cursor(
				big_cursor,
				0,
				Vector2(cursor_size.x/2, cursor_size.y)
			)
			
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
			update_seeds(-1000)
			cancel_build()
			
func show_wave(wave: int) -> void:
	var wave_str := String(wave)
	wave_label.text = "Level 1 - Wave " + wave_str
	wave_text.text = wave_str
	wave_headline.visible = true
	wave_text.visible = true
	yield(get_tree().create_timer(3.0), "timeout")
	hide_wave()
	
func hide_wave() -> void:
	wave_headline.visible = false
	wave_text.visible = false
	
func update_timer(time: float) -> void:
	timer_label.text = "Time to next wave: %.2fs" % time
	
