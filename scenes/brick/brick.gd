class_name Brick
extends RigidBody2D

signal brick_destroyed(letter: String)

enum Difficulty { EASY, MEDIUM, HARD }

@export_category("Properties")
@export var letter: String = "A"
@export var difficulty: Difficulty = Difficulty.HARD
@export var size := 50

@onready var _current_difficulty: Difficulty

const _difficulties: Dictionary[Difficulty, String] = {
	Difficulty.HARD: "res://assets/images/keycap_red.png" ,
	Difficulty.MEDIUM: "res://assets/images/keycap_orange.png",
	Difficulty.EASY: "res://assets/images/keycap_green.png",
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Letter.text = letter
	$CollisionShape2D.shape.size = Vector2(size, size)
	_change_difficulty(difficulty)


func change_letter(new_letter: String) -> void:
	letter = new_letter
	$Letter.text = new_letter


func hit() -> void:
	match _current_difficulty:
		Difficulty.HARD:
			_change_difficulty(Difficulty.MEDIUM)
		Difficulty.MEDIUM:
			_change_difficulty(Difficulty.EASY)
		Difficulty.EASY:
			_destroy()


func _change_difficulty(new_difficulty: Difficulty) -> void:
	_current_difficulty = new_difficulty
	$Background.texture = load(_difficulties[_current_difficulty])


func _destroy() -> void:
	brick_destroyed.emit(letter)
	queue_free()
