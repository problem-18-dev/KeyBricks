class_name Brick
extends RigidBody2D

signal brick_destroyed(letter: String)

enum Difficulty { EASY, MEDIUM, HARD }

@export_category("Properties")
@export var letter: String = "A"
@export var difficulty: Difficulty = Difficulty.HARD
@export var size := 50

var _current_difficulty := difficulty

const difficulties: Dictionary[Difficulty, Color] = {
	Difficulty.HARD: Color("005f46"),
	Difficulty.MEDIUM: Color("ff6923"),
	Difficulty.EASY: Color("780a00"),
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Letter.text = letter
	$CollisionShape2D.shape.size = Vector2(size, size)


func hit() -> void:
	match _current_difficulty:
		Difficulty.HARD:
			_current_difficulty = Difficulty.MEDIUM
		Difficulty.MEDIUM:
			_current_difficulty = Difficulty.EASY
		Difficulty.EASY:
			brick_destroyed.emit(letter)
			queue_free()
