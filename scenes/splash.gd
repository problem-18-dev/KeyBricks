extends CanvasLayer


func main_menu() -> void:
	GameManager.main_scene.load_scene(Main.Scene.MainMenu)
	GameManager.main_scene.play_music()
