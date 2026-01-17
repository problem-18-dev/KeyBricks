extends RigidBody2D

signal ball_started
signal ball_destroyed

@export_category("Movement")
@export var min_speed := 150.0
@export var max_speed := 450.0
@export var min_vertical_velocity := 16
@export var min_horizontal_velocity := 16
@export_range(-45, 45, 1.0) var start_rotation := 0.0
@export_category("Collision")
@export var acceleration_on_bounce := 15.0

var _direction: Vector2
var _speed: float
var _has_started := false


func _process(_delta: float) -> void:
	if position.y >= 1200:
		ball_destroyed.emit()


func _physics_process(delta: float) -> void:
	if not _has_started:
		return

	var collision := move_and_collide(_direction.normalized() * _speed * delta)
	if collision:
		var collider := collision.get_collider()
		if collider is Brick:
			AudioManager.play("key_press")
			collider.hit()
		elif collider is Paddle:
			AudioManager.play("spacebar")
		else:
			AudioManager.play("wall_bounce")
		_direction = _direction.bounce(collision.get_normal())
		# Bounce
		if abs(_direction.y) <= 15.0:
			_direction.y = min_vertical_velocity * sign(_direction.y)
		if abs(_direction.x) <= 15.0:
			_direction.x = min_horizontal_velocity * sign(_direction.x)

		# Accelerate
		_speed += acceleration_on_bounce
		_speed = min(_speed, max_speed)


func reset(new_position: Vector2) -> void:
	_direction = Vector2.ZERO
	_speed = 0
	global_position = new_position
	_has_started = false


func start() -> void:
	_direction = Vector2.UP.rotated(deg_to_rad(start_rotation)) * min_speed
	_speed = min_speed
	_has_started = true
	ball_started.emit()


func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("interact") or event is InputEventScreenTouch) and not _has_started:
		start()
