extends Node2D

class_name Enemy

@export var speed: float = 200.0
@export var maxHealth: int = 100
@export var worth: int = 80
@export var damage: int = 10
@onready var healthBar: ProgressBar = $HealthBar
@onready var sprite: Sprite2D = $sprite
@onready var nav_agent: NavigationAgent2D = %NavigationAgent2D
var texture: CompressedTexture2D
var frozen_for: float = 0
var kind: String = "car"
var enemy_spawner = null

var health: int = maxHealth
var original_position: Vector2


func _ready() -> void:
	set_process(false)


func set_movement_target(movement_target: Vector2):
	nav_agent.target_position = movement_target


func _process(delta: float) -> void:
	var modified_speed: float = speed
	if frozen_for > 0:
		frozen_for -= delta
		modified_speed *= 0.3
		if frozen_for <= 0:
			sprite.modulate = Color(1, 1, 1)
	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = nav_agent.get_next_path_position()

	var direction: Vector2 = current_agent_position.direction_to(next_path_position)
	global_position += direction * modified_speed * delta


func hit(strength: int, hit_kind: String) -> void:
	health -= strength
	healthBar.value = 100.0 * health / maxHealth
	if health <= 0:
		explode()
		return
	if hit_kind == "ice":
		sprite.modulate = Color(0.53, 0.81, 0.921)
		frozen_for = 1


func died():
	enemy_spawner.enemy_died()


func explode():
	GameController.update_seeds(worth)
	if kind == "towtruck":
		enemy_spawner.spawn_enemy("car", global_position)
		await get_tree().create_timer(0.2).timeout
		enemy_spawner.spawn_enemy("car", global_position)
	died()
	queue_free()


func set_texture(txt: CompressedTexture2D) -> void:
	texture = txt
