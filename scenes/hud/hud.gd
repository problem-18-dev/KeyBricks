extends CanvasLayer


var _word_scene: PackedScene = preload("res://scenes/word/word.tscn")
var _spawned_word: Node


func _ready() -> void:
	change_lives(GameManager.lives)
	change_score(GameManager.score)


func reveal_letter(letter: String) -> void:
	_spawned_word.reveal_letter(letter)


func spawn_word(word: String) -> void:
	var word_to_spawn := _word_scene.instantiate()
	word_to_spawn.set_letters(word)
	word_to_spawn.position = $WordSpawnLocation.position
	_spawned_word = word_to_spawn
	add_child(word_to_spawn)


func change_lives(lives: int) -> void:
	for i in %Hearts.get_child_count():
		%Hearts.get_child(i).visible = i < lives


func change_score(score: int) -> void:
	%ScoreLabel.text = "SCORE: " + str(score)


func add_multiplier() -> void:
	_spawned_word.hide()
	$DoubleScoreLabel.show()


func show_message(message: String, ttl: int = 0) -> void:
	$Message.text = message
	if ttl:
		await get_tree().create_timer(ttl).timeout
		hide_message()


func hide_message() -> void:
	$Message.text = ""
