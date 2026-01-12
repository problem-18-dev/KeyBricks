extends StaticBody2D

@export var width := 20.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite2D.texture.size.y = width
	$CollisionShape2D.shape.size.y = width
