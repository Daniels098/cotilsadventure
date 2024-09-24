extends CanvasLayer

@onready var pause_menu = $"."
var game_paused = true

func _on_button_resume_pressed():
	if game_paused:
		Engine.time_scale = 1
		pause_menu.visible = false
	#get_tree().root.get_viewport().set_input_as_handled()


func _on_buttons_options_pressed(): ########### Ta travando ############
	if game_paused:
		Engine.time_scale = 1
		pause_menu.visible = false
		var device = OS.get_name()
		if device == "Windows" or device == "Linux" or device == "MacOS" or device == "Web" or "BSD" in device:
			SceneManager.load_new_scene("res://scenes/menu/options_PC.tscn", "wipe_to_right") 
		else: # tem que ser outras cenas se nn o jogo reseta
			SceneManager.load_new_scene("res://scenes/menu/options_MOBILE.tscn", "wipe_to_right")


func _on_buttons_menu_principal_pressed():
	if game_paused:
		Engine.time_scale = 1
		pause_menu.visible = false
		SceneManager.load_new_scene("res://scenes/menu/menu.tscn", "wipe_to_right")


func _on_buttons_quit_pressed():
	get_tree().quit()
