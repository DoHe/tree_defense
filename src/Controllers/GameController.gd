extends Node2D

var seeds: int = 1000
var life: int = 100
var game_over: bool = false

func _ready():
	update_seeds(0)
	update_life(0)
	
func update_seeds(change: int) -> void:
	seeds += change
	var count_label := get_node("/root/Level/UI/SeedsContainer/SeedsLabel")
	count_label.text = String(seeds)
	
func update_life(change: int) -> void:
	life += change
	var life_progress := get_node("/root/Level/UI/LifeContainer/LifeProgress")
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
