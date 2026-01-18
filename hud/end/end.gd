extends Node


const A := 65
const Z := 90

@export var brick_scene: PackedScene


func _ready() -> void:
	$UI/HighScore.text = "HIGH SCORE: " + str(GameManager.high_score)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") or event is InputEventScreenTouch:
		AudioManager.play("spacebar")
		GameManager.main_scene.load_scene(Main.Scene.MainMenu)


func _on_brick_timer_timeout() -> void:
	var brick: Brick = brick_scene.instantiate()
	var random_difficulty := randi() % Brick.Difficulty.size()
	brick.difficulty = Brick.Difficulty.values()[random_difficulty]
	var letter := String.chr(randi_range(A, Z))
	brick.change_letter(letter)

	var brick_spawn_location := $BrickPath/BrickSpawnLocation
	brick_spawn_location.progress_ratio = randf()
	brick.position = brick_spawn_location.position

	var direction = float(brick_spawn_location.rotation + PI / 2)
	direction += randf_range(-PI / 4, PI / 4)
	brick.angular_velocity = direction

	var velocity := Vector2(randf_range(150.0, 250.0), 0.0)
	brick.linear_velocity = velocity.rotated(direction)
	brick.modulate = Color(0.4, 0.4, 0.4, 1.0)

	$BackgroundBricks.add_child(brick)
