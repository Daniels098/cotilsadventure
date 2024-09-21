class_name Menu extends Control


func _on_button_pressed():
	SceneManager.load_new_scene("res://scenes/academico/terreo_academico.tscn", "wipe_to_right")

func _on_button_4_pressed():
	get_tree().quit()

func _on_btn_options_pressed():
	SceneManager.load_new_scene("res://scenes/menu/options.tscn", "wipe_to_right")

func _on_button_3_pressed():
	SceneManager.load_new_scene("res://scenes/menu/credits.tscn", "wipe_to_right")


func _on_btn_login_pressed():
	SceneManager.load_new_scene("res://scenes/menu/login_menu.tscn", "wipe_to_right")
