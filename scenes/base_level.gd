extends Node

const A := 65
const Z := 90

@export_category("Level")
@export var word: String = "KEYBOARD"
@export_range(2, 4)
var max_letter_attempts := 3

var _ball_scene: PackedScene = preload("res://scenes/ball/ball.tscn")
var _paddle_scene: PackedScene = preload("res://scenes/paddle/paddle.tscn")
var _word_scene: PackedScene = preload("res://scenes/word/word.tscn")
var _spawned_word: Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_assign_bricks()
	_spawn_word()
	_spawn_ball()
	_spawn_paddle()


func _assign_bricks() -> void:
	var bricks := get_tree().get_nodes_in_group("bricks")
	var available_letters := word.split("")
	var letter_attempts := 0
	for i in bricks.size():
		var letter := String.chr(randi_range(A, Z))
		letter_attempts = 0 if available_letters.has(letter) else letter_attempts + 1

		if available_letters.size() > 0:
			if available_letters.has(letter):
				var letter_index := available_letters.find(letter)
				available_letters.remove_at(letter_index)
				letter_attempts = 0
			elif letter_attempts >= max_letter_attempts:
				var letter_index := randi_range(0, available_letters.size() - 1)
				letter = available_letters[letter_index]
				available_letters.remove_at(letter_index)
				letter_attempts = 0

		var brick := bricks[i]
		brick.brick_destroyed.connect(_on_brick_destroyed)
		brick.change_letter(letter)


func _spawn_word() -> void:
	var word_to_spawn := _word_scene.instantiate()
	word_to_spawn.set_letters(word)
	word_to_spawn.position = $WordSpawnLocation.position
	_spawned_word = word_to_spawn
	add_child(word_to_spawn)


func _spawn_ball() -> void:
	var ball := _ball_scene.instantiate()
	ball.position = $BallSpawnLocation.position
	var start_rotation = randf_range(-45, 45)
	start_rotation = start_rotation if start_rotation != 0 else randf_range(-45, 45)
	ball.start_rotation = start_rotation
	add_child(ball)


func _spawn_paddle() -> void:
	var paddle := _paddle_scene.instantiate()
	paddle.position = $PaddleSpawnLocation.position
	add_child(paddle)


func _on_brick_destroyed(letter: String) -> void:
	if word.contains(letter):
		_spawned_word.reveal_letter(letter)
