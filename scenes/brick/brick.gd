class_name Brick
extends RigidBody2D

signal brick_destroyed(letter: String, score: int)

enum Difficulty { EASY, MEDIUM, HARD }
enum Size { SMALL, LARGE }

const _difficulties: Dictionary[Difficulty, String] = {
	Difficulty.HARD: "res://assets/images/keycap_red.png" ,
	Difficulty.MEDIUM: "res://assets/images/keycap_orange.png",
	Difficulty.EASY: "res://assets/images/keycap_green.png",
}

const _scores: Dictionary[Difficulty, int] = {
	Difficulty.HARD:  75,
	Difficulty.MEDIUM: 50,
	Difficulty.EASY: 25,
}

@export_category("Properties")
@export var letter: String = "A"
@export var difficulty: Difficulty = Difficulty.HARD
@export var size := Size.SMALL

@onready var _current_difficulty: Difficulty


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	change_letter(letter)
	_change_difficulty(difficulty)
	_change_size(size)


func change_letter(new_letter: String) -> void:
	letter = new_letter
	$Letter.text = new_letter


func hit() -> void:
	match _current_difficulty:
		Difficulty.HARD:
			$AnimationPlayer.play("Hit")
			_change_difficulty(Difficulty.MEDIUM)
		Difficulty.MEDIUM:
			$AnimationPlayer.play("Hit")
			_change_difficulty(Difficulty.EASY)
		Difficulty.EASY:
			_destroy()


func get_size() -> Vector2:
	match size:
		Size.LARGE:
			return Vector2(75, 75)
		_:
			return Vector2(50, 50)


func _change_difficulty(new_difficulty: Difficulty) -> void:
	_current_difficulty = new_difficulty
	$Background.texture = load(_difficulties[_current_difficulty])


func _change_size(new_size: Size) -> void:
	match new_size:
		Size.LARGE:
			$CollisionShape2D.shape.size = Vector2(75, 75)
			$Background.scale = Vector2(1.5, 1.5)
			$Letter.add_theme_font_size_override("font_size", 44)
		_:
			$CollisionShape2D.shape.size = Vector2(50, 50)
			$Background.scale = Vector2(1.0, 1.0)
			$Letter.add_theme_font_size_override("font_size", 36)
			return


func _destroy() -> void:
	brick_destroyed.emit(letter, _scores[difficulty])
	queue_free()
