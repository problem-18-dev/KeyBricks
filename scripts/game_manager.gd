extends Node


var _save_path := "user://score.save"
var main_scene: Main
var lives: int
var score: int
var high_score: int


func add_score(score_to_add) -> int:
	score += score_to_add
	if score > high_score:
		high_score = score
	return score


func change_lives(new_lives) -> int:
	lives = new_lives
	return lives


func lose_life() -> int:
	lives -= 1
	return lives


func save_high_score() -> void:
	if not _check_cookie_permissions():
		return

	if score > high_score:
		print("New high scored saved: " + str(score))
		var file := FileAccess.open(_save_path, FileAccess.WRITE)
		file.store_var(score)


func load_high_score() -> void:
	if not _check_cookie_permissions():
		high_score = 0
		return

	if FileAccess.file_exists(_save_path):
		print("Save file found")
		var file := FileAccess.open(_save_path, FileAccess.READ)
		high_score = file.get_var()
		print("High score loaded: " + str(high_score))
	else:
		print("Save file not found")
		high_score = 0


func _check_cookie_permissions() -> bool:
	if OS.is_userfs_persistent():
		return true

	print("Cookies not allowed")
	return false
