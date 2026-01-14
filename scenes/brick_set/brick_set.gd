extends Node2D

@export_category("Bricks")
@export_range(1, 8)
var rows := 1
@export_range(1, 16)
var columns := 1
@export var difficulty := Brick.Difficulty.EASY

var _brick_scene: PackedScene = preload("res://scenes/brick/brick.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_spawn_bricks()


func _spawn_bricks() -> void:
	for x in columns:
		for y in rows:
			var brick: Brick = _brick_scene.instantiate()
			var position_offset := brick.size / 2.0
			var x_position := float((position.x + position_offset) + brick.size * (x - 1))
			var y_position := float((position.y + position_offset) + brick.size * (y - 1))
			brick.difficulty = difficulty
			add_child(brick)
			brick.global_position = Vector2(x_position, y_position)
