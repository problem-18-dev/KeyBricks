extends CharacterBody2D

@export var speed := 75


func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("move_left", "move_right")
	move_and_collide(Vector2(direction, 0) * speed * delta)
