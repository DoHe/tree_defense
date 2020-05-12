extends Node2D

export var speed : float = 180.0
export var maxHealth : int = 100
export var worth : int = 100
onready var healthBar : ProgressBar = $HealthBar
onready var line : Line2D = $line
onready var game_controller := get_node("/root/GameController")

var path : = PoolVector2Array() setget set_path
var health : int = maxHealth
var original_position : Vector2

func _ready() -> void:
	set_process(false)

func _process(delta: float) -> void:
	var move_distance : = speed * delta
	# move_along_path(move_distance)

func move_along_path(distance: float) -> void:
	var starting_point : = position
	for _i in range(path.size()):
		var distance_to_next : = starting_point.distance_to(path[0])
		if distance <= distance_to_next and distance >= 0.0:
			position = starting_point.linear_interpolate(
				path[0],
				distance / distance_to_next
			)
			break
		elif distance < 0.0:
			position = path[0]
			set_process(false)
		distance -= distance_to_next
		starting_point = path[0]
		path.remove(0)

func set_path(value: PoolVector2Array) -> void:
	path = value
	# line.points = path
	if value.size() == 0:
		return
	set_process(true)

func hit(strength: int) -> void:
	health -= strength
	healthBar.value = 100 * health / maxHealth
	if health <= 0:
		explode()

func explode():
	game_controller.update_seeds(worth)
	queue_free()
