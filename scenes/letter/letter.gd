extends Node2D

@export var letter: String

var is_revealed := false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Letter.text = letter


func reveal() -> void:
	$Letter.show()
	is_revealed = true
