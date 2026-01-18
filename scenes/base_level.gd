extends Node

const A := 65
const Z := 90

@export_category("Game")
@export var next_level: Main.Scene
@export_category("Level")
@export var word: String = "KEYBOARD"
@export_range(2, 4)
var max_letter_attempts := 3
@export var max_ball_speed := 575.0
@export var min_ball_speed := 225.0
@export var ball_acceleration := 15.0

var _ball_scene: PackedScene = preload("res://scenes/ball/ball.tscn")
var _paddle_scene: PackedScene = preload("res://scenes/paddle/paddle.tscn")
var _available_letters := word.split("")
var _letters_hit := 0
var _ball: Node
var _paddle: Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_assign_bricks()
	_spawn_ball()
	_spawn_paddle()
	$HUD.spawn_word(word)


func _assign_bricks() -> void:
	var bricks := get_tree().get_nodes_in_group("bricks")
	var letter_attempts := 0
	for i in bricks.size():
		var letter := String.chr(randi_range(A, Z))
		letter_attempts = 0 if _available_letters.has(letter) else letter_attempts + 1

		if _available_letters.size() > 0:
			if _available_letters.has(letter):
				var letter_index := _available_letters.find(letter)
				_available_letters.remove_at(letter_index)
				letter_attempts = 0
			elif letter_attempts >= max_letter_attempts:
				var letter_index := randi_range(0, _available_letters.size() - 1)
				letter = _available_letters[letter_index]
				_available_letters.remove_at(letter_index)
				letter_attempts = 0

		var brick: Brick = bricks[i]
		brick.brick_destroyed.connect(_on_brick_destroyed)
		brick.change_letter(letter)


func _spawn_ball() -> void:
	var ball := _ball_scene.instantiate()
	ball.position = $BallSpawnLocation.position
	var start_rotation = randf_range(-45, 45)
	start_rotation = start_rotation
	ball.start_rotation = start_rotation
	ball.max_speed = max_ball_speed
	ball.min_speed = min_ball_speed
	ball.acceleration_on_bounce = ball_acceleration
	ball.ball_destroyed.connect(_on_ball_destroyed)
	ball.ball_started.connect(_on_ball_started)
	_ball = ball
	add_child(ball)


func _spawn_paddle() -> void:
	var paddle := _paddle_scene.instantiate()
	paddle.position = $PaddleSpawnLocation.position
	_paddle = paddle
	add_child(paddle)


func _add_score(new_score: int) -> void:
	GameManager.add_score(new_score)
	$HUD.change_score(GameManager.score)


func _restart_level() -> void:
	_ball.reset($BallSpawnLocation.position)
	_paddle.reset($PaddleSpawnLocation.position)


func _load_next_level() -> void:
	GameManager.save_high_score()
	GameManager.main_scene.load_scene(next_level)


func _on_ball_destroyed() -> void:
	var lives := GameManager.lose_life()
	$HUD.change_lives(GameManager.lives)

	if lives <= 0:
		_paddle.queue_free()
		_ball.queue_free()
		AudioManager.play("game_over")
		await $HUD.show_message("GAME OVER", 2)
		GameManager.save_high_score()
		GameManager.main_scene.reset_stats()
		GameManager.main_scene.load_scene(Main.Scene.End)
		return

	_restart_level()


func _on_ball_started() -> void:
	_paddle.start()


func _on_brick_destroyed(letter: String, brick_score: int) -> void:
	if _letters_hit >= word.length():
		_add_score(brick_score * 2)
		$HUD.add_multiplier()
	else:
		_add_score(brick_score)

	if word.contains(letter):
		$HUD.reveal_letter(letter)
		_letters_hit += 1

	# Bricks left minus one to compensate for brick emitting the signal
	var bricks_left := get_tree().get_node_count_in_group("bricks") - 1
	if bricks_left <= 0:
		AudioManager.play("action")
		_paddle.queue_free()
		_ball.queue_free()
		await $HUD.show_message("WELL TYPED", 2)
		_load_next_level()


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		var is_paused := get_tree().paused
		if is_paused:
			$HUD.hide_message()
		else:
			$HUD.show_message("PAUSED")
		get_tree().paused = not get_tree().paused
