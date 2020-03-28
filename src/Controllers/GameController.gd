extends Node2D

var seeds: int = 1000
var life: int = 100
var game_over: bool = false
var planting: String = ""
onready var tree_cursor := preload("res://assets/trees/cherry_icon_pressed.png")
onready var cherry_scene := preload("res://src/Objects/Tower.tscn")
onready var count_label := get_node("/root/Level/UI/Seeds/Container/SeedsLabel")
onready var life_progress := get_node("/root/Level/UI/Life/Container/LifeProgress")
onready var level := get_node("/root/Level")
onready var cursor_size : Vector2 = tree_cursor.get_size()


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
	# var game_over_ui := get_node("/root/level/UI/GameOver")
	# game_over_ui.visible = true
	
func restart_level() -> void:
	seeds = 0
	game_over = false
	get_tree().paused = false
	get_tree().reload_current_scene()
	
func build(tree: String) -> void:
	if planting:
		return
	match tree:
		"cherry":
			if seeds < 500:
				return
			planting = tree
			Input.set_custom_mouse_cursor(
				tree_cursor,
				0,
				Vector2(cursor_size.x/2, cursor_size.y)
			)

func plant(global_pos):
	if not planting:
		return
		
	match planting:
		"cherry":
			var cherry := cherry_scene.instance()
			level.add_child(cherry)
			var offset := Vector2(0, cursor_size.y/2)
			cherry.global_position = global_pos - offset
			Input.set_custom_mouse_cursor(null)
			update_seeds(-500)
			planting = ""
