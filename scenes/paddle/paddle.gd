class_name Paddle
extends CharacterBody2D


@export var min_speed := 225
@export var max_speed := 300
@export var acceleration_weight := 1.2

var _can_move := false
var t := 0.0

func _physics_process(delta: float) -> void:
	if not _can_move:
		return

	var _direction = Input.get_axis("move_left", "move_right")
	t = 0.0 if _direction == 0 else t + delta * acceleration_weight
	var speed = lerp(min_speed, max_speed, min(t, 1))
	move_and_collide(Vector2(_direction, 0) * speed * delta)


func reset(new_position: Vector2) -> void:
	_can_move = false
	global_position = new_position


func start() -> void:
	AudioManager.play("spacebar")
	_can_move = true
