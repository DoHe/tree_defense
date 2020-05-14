extends Node2D

export var speed : float = 200.0
export var maxHealth : int = 100
export var worth : int = 80
export var damage : int = 10
onready var healthBar : ProgressBar = $HealthBar
onready var sprite : Sprite = $sprite
onready var game_controller := get_node("/root/GameController")
var texture : StreamTexture
var frozen_for : float = 0
var kind : String = "car"
var enemy_spawner = null

var health : int = maxHealth
var original_position : Vector2

func _ready() -> void:
	set_process(false)
	enemy_spawner = get_parent().get_parent().get_parent()

func _process(delta: float) -> void:
	var modified_speed : float = speed
	if frozen_for > 0:
		frozen_for -= delta
		modified_speed *= 0.3
		if frozen_for <= 0:
			sprite.modulate = Color(1, 1, 1)
	var move_distance : = modified_speed * delta
	follow(move_distance)
	
func follow(distance: float) -> void:
	if texture:
		sprite.texture = texture	
	var follow : PathFollow2D = get_parent()
	follow.set_offset(follow.get_offset() + distance)

func hit(strength: int, kind: String) -> void:
	health -= strength
	healthBar.value = 100 * health / maxHealth
	if health <= 0:
		explode()
		return
	if kind == "ice":
		sprite.modulate = Color(0.53, 0.81, 0.921)
		frozen_for = 1

func died():
	enemy_spawner.enemy_died()

func explode():
	game_controller.update_seeds(worth)
	died()
	if kind == "towtruck":
		enemy_spawner.spawn_enemy("car", global_position)
		yield(get_tree().create_timer(0.2), "timeout")
		enemy_spawner.spawn_enemy("car", global_position)
	queue_free()

func set_texture(txt: StreamTexture) -> void:
	texture = txt
