extends Node


var _sounds: Dictionary[String, String] = {
	"spacebar": "res://assets/sounds/spacebar.ogg",
	"key_press": "res://assets/sounds/key_press.ogg",
	"wall_bounce": "res://assets/sounds/wall_bounce.ogg",
	"splash": "res://assets/sounds/splash.ogg",
	"action": "res://assets/sounds/action.ogg",
	"game_over": "res://assets/sounds/death.ogg"
}

var _bus := "SFX"


func play(sound_path: String, pitch: float = randf_range(0.9, 1.1)) -> void:
	var player := AudioStreamPlayer.new()
	add_child(player)
	player.bus = _bus
	player.pitch_scale = pitch
	var sound := _sounds[sound_path]
	player.stream = load(sound)
	player.finished.connect(_on_stream_finished.bind(player))
	player.play()


func _on_stream_finished(stream: AudioStreamPlayer) -> void:
	stream.queue_free()
