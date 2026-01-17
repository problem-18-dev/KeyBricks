class_name Main
extends Node


enum Scene {Splash, MainMenu, LevelOne, LevelTwo, LevelThree, End}

@export_category("Settings")
@export var first_scene: Scene
@export var start_lives := 3
@export var start_score := 0

var _scenes: Dictionary[Scene, String] = {
	Scene.Splash: "res://scenes/splash.tscn",
	Scene.MainMenu: "res://hud/main_menu/main_menu.tscn",
	Scene.LevelOne: "res://levels/level_one.tscn",
	Scene.LevelTwo: "res://levels/level_two.tscn",
	Scene.LevelThree: "res://levels/level_three.tscn",
	Scene.End: "res://hud/end/end.tscn",
}
var _scene_instance: Node


func _ready() -> void:
	GameManager.main_scene = self
	GameManager.load_high_score()
	reset_stats()
	load_scene(first_scene)


func unload_scene() -> void:
	if is_instance_valid(_scene_instance):
		_scene_instance.queue_free()
	_scene_instance = null


func load_scene(scene: Scene) -> void:
	unload_scene()
	var scene_resource: PackedScene = load(_scenes[scene])
	if scene_resource:
		_scene_instance = scene_resource.instantiate()
		$Scene.add_child(_scene_instance)


func reset_stats() -> void:
	GameManager.lives = start_lives
	GameManager.score = start_score


func play_music() -> void:
	$MusicPlayer.play()
