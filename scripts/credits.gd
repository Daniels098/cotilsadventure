extends Control

func _on_button_pressed():
	SceneManager.load_new_scene("res://scenes/menu/menu.tscn", "wipe_to_right")
