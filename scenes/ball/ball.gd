extends RigidBody2D

signal ball_started
signal ball_lost

const rotation_diff := PI / 5

@export_category("Movement")
@export var min_speed := 150.0
@export var max_speed := 450.0
@export var paddle_bounce_intensity := 0.5
@export_category("Collision")
@export var acceleration_on_bounce := 15.0

var _min_direction := 5.0 / 100
var _direction: Vector2
var _speed: float
var _has_started := false


func _process(_delta: float) -> void:
	if position.y >= get_viewport_rect().size.y:
		ball_lost.emit()


func _physics_process(delta: float) -> void:
	if not _has_started:
		return

	var collision := move_and_collide(_direction.normalized() * _speed * delta)
	if collision:
		_handle_collision(collision)


func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("interact") or event is InputEventScreenTouch) and not _has_started:
		start()


func reset(new_position: Vector2) -> void:
	sleeping = true
	_has_started = false
	_direction = Vector2.ZERO
	_speed = 0
	global_position = new_position


func start() -> void:
	_direction = Vector2.UP.rotated(randf_range(-rotation_diff, rotation_diff))
	_speed = min_speed
	_has_started = true
	sleeping = false
	ball_started.emit()


func _increase_speed() -> void:
	var new_speed := _speed + acceleration_on_bounce
	_speed = clampf(new_speed, _speed, max_speed)


func _handle_collision(collision: KinematicCollision2D) -> void:
	var collider := collision.get_collider()
	var audio_to_play := "wall_bounce"

	_direction = _direction.bounce(collision.get_normal())
	if collider is Paddle:
		audio_to_play = "spacebar"
		_direction = collider.position.direction_to(position)
		_direction.x *= paddle_bounce_intensity
	elif collider is not Brick:
		print("direction before: ", _direction)
		if abs(_direction.y) < _min_direction:
			_direction.y = _min_direction * signf(_direction.y)
		if abs(_direction.x) < _min_direction:
			_direction.x = _min_direction * signf(_direction.x)
		print("direction after: ", _direction)

	if collider is Brick:
		audio_to_play = "key_press"
		collider.hit()

	AudioManager.play(audio_to_play)
	_increase_speed()
