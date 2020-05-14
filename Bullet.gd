extends Node2D

onready var ice_texture = preload("res://assets/snowflake.png")
onready var big_texture = preload("res://assets/fruit/fruitassets_08.png")
onready var sprite : Sprite = $leaf
onready var explosion_sprite : Sprite = $ExplosionArea/circle
onready var explosion_area : Area2D = $ExplosionArea
export var speed : int = 600
export var steer_force : float = 800.0
export var strength : int = 30

var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO
var target = null
var target_position = null
var texture : StreamTexture
var kind : String = "cherry"
var seeking: bool = true
var area_damage: bool = false
var exploded : bool = false

func start(_transform, _target):
	if texture:
		sprite.texture = texture
	global_transform = _transform
	target = _target
	if seeking:
		rotation += rand_range(-0.09, 0.09)
		velocity = transform.x * speed
	else:
		target_position = _target.global_position

func steer():
	var steer = Vector2.ZERO
	if target and is_instance_valid(target):
		var desired = (target.global_position - global_position).normalized() * speed
		steer = (desired - velocity).normalized() * steer_force
	return steer
	
func seek(delta: float):
	if target and not is_instance_valid(target):
		explode()
	acceleration += steer()
	velocity += acceleration * delta
	velocity = velocity.clamped(speed)
	rotation = velocity.angle()
	global_position += velocity * delta

func _physics_process(delta):
	if seeking:
		seek(delta)
	else:
		var distance : Vector2 = target_position - global_position
		if area_damage and distance.length() <= 0.1:
			explode()
		velocity = speed * distance.normalized()
		var new_position = global_position + velocity * delta
		if (target_position - new_position).length() > (target_position - global_position).length():
			new_position = target_position
		global_position = new_position

func _on_Bullet_area_entered(area: Area2D) -> void:
	if area == target and not area_damage and area.is_in_group("enemies"):
		area.get_parent().hit(strength, kind)
		explode()

func explode():
	if exploded:
		return
	exploded = true
	if area_damage:
		explosion_sprite.visible = true
		sprite.visible = false
		var targets = explosion_area.get_overlapping_areas()
		for target in targets:
			if !target.is_in_group("enemies"):
				continue
			target.get_parent().hit(strength, kind)
		yield(get_tree().create_timer(0.7), "timeout")
		explosion_sprite.visible = false
	#$Particles2D.emitting = false
	#set_physics_process(false)
	#$AnimationPlayer.play("explode")
	#yield($AnimationPlayer, "animation_finished")
	queue_free()
	
func set_kind(knd: String):
	kind = knd
	match kind:
		"cherry":
			pass
		"ice":
			texture = ice_texture
			sprite.transform = sprite.transform.scaled(Vector2(0.1, 0.1))
			seeking = false
			speed = 800
			strength = 5
		"big":
			texture = big_texture
			seeking = false
			area_damage = true
			speed = 450
			strength = 80
