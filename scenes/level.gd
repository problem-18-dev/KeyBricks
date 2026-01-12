extends Node

@export_category("Scenes")
@export var ball_scene: PackedScene
@export var paddle_scene: PackedScene
@export var letter_scene: PackedScene
@export var brick_scene: PackedScene
@export_category("Level")
@export var columns := 15
@export var rows := 15
@export var brick_size := 50
@export var word: String = "KEYBOARD"

# A & Z in ascii
const A := 65
const Z := 90


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_spawn_bricks()
	_spawn_ball()
	_spawn_paddle()


func _spawn_bricks() -> void:
	var letters := word.split("")
	var letter_attempts := 0
	for x in columns:
		for y in rows:
			var brick: Brick = brick_scene.instantiate()
			var x_position := float($BricksStartLocation.position.x + brick_size * x)
			var y_position := float($BricksStartLocation.position.y + brick_size * y)
			brick.position = Vector2(x_position, y_position)

			var letter_to_render := String.chr(randi_range(A, Z))
			letter_attempts = 0 if letters.has(letter_to_render) else letter_attempts + 1

			if letters.size() > 0:
				if letters.has(letter_to_render):
					var letter_index := letters.find(letter_to_render)
					letters.remove_at(letter_index)
					letter_attempts = 0

				if letter_attempts >= 3:
					var letter_index := randi_range(0, letters.size() - 1)
					letter_to_render = letters[letter_index]
					letters.remove_at(letter_index)
					letter_attempts = 0

			brick.letter = letter_to_render

			add_child(brick)


func _spawn_ball() -> void:
	var ball := ball_scene.instantiate()
	ball.position = $BallSpawnLocation.position
	var start_rotation = randf_range(-45, 45)
	start_rotation = start_rotation if start_rotation != 0 else randf_range(-45, 45)
	ball.start_rotation = start_rotation
	add_child(ball)


func _spawn_paddle() -> void:
	var paddle := paddle_scene.instantiate()
	paddle.position = $PaddleSpawnLocation.position
	paddle.speed = 150.0
	add_child(paddle)
