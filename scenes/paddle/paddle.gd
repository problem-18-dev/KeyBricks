class_name Paddle
extends CharacterBody2D


@export var speed := 450

@onready var sprite_2d: Sprite2D = $Sprite2D


var _can_move := false

func _physics_process(delta: float) -> void:
	if not _can_move:
		return

	var _direction = Input.get_axis("move_left", "move_right")
	move_and_collide(Vector2(_direction, 0) * speed * delta)


func reset(new_position: Vector2) -> void:
	_can_move = false
	global_position = new_position


func start() -> void:
	AudioManager.play("spacebar")
	_can_move = true
