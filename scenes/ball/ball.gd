extends RigidBody2D

signal ball_destroyed

@export_category("Start")
@export var speed := 150.0
@export_range(-45, 45, 1.0) var start_rotation := 0.0
@export_category("Collision")
@export var acceleration_on_bounce := 0.025

var _velocity: Vector2
var _has_started := false


func _process(_delta: float) -> void:
	if position.y >= 1200:
		ball_destroyed.emit()
		queue_free()


func _physics_process(delta: float) -> void:
	if not _has_started:
		return

	var collision := move_and_collide(_velocity * delta)
	if collision:
		var collider := collision.get_collider()
		if collider is Brick:
			collider.hit()
		var bounce_direction := _velocity.bounce(collision.get_normal())
		var new_velocity := bounce_direction * (acceleration_on_bounce + 1)
		_velocity = new_velocity


func _start() -> void:
	_velocity = Vector2.UP.rotated(deg_to_rad(start_rotation)) * speed
	_has_started = true


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and not _has_started:
		_start()
