extends Node2D

@export var letter: String


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Letter.text = letter


func reveal() -> void:
	$Letter.show()
