extends Node2D

export var speed : float = 200.0
export var maxHealth : int = 100
export var worth : int = 100
export var damage : int = 10
onready var healthBar : ProgressBar = $HealthBar
onready var sprite : Sprite = $sprite
onready var game_controller := get_node("/root/GameController")
var texture : StreamTexture

var health : int = maxHealth
var original_position : Vector2

func _ready() -> void:
	set_process(false)

func _process(delta: float) -> void:
	var move_distance : = speed * delta
	follow(move_distance)
	
func follow(distance: float) -> void:
	if texture:
		sprite.texture = texture	
	var follow : PathFollow2D = get_parent()
	follow.set_offset(follow.get_offset() + distance)

func hit(strength: int) -> void:
	health -= strength
	healthBar.value = 100 * health / maxHealth
	if health <= 0:
		explode()

func explode():
	game_controller.update_seeds(worth)
	queue_free()

func set_texture(txt: StreamTexture) -> void:
	texture = txt
