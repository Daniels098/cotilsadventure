extends CanvasLayer

@onready var pause_menu = $"."
var game_paused = true
@onready var menu_pc = preload("res://scenes/menu/menu_pause_pc.tscn")
@onready var menu_mobile = preload("res://scenes/menu/menu_pause_mobile.tscn")

func _on_button_resume_pressed():
	if game_paused:
		Engine.time_scale = 1
		pause_menu.visible = false
	#get_tree().root.get_viewport().set_input_as_handled()


func _on_buttons_options_pressed(): ########### Ta travando ############
	if game_paused:
		Engine.time_scale = 0
		pause_menu.visible = true
		var menu_instance
		var device = OS.get_name()
		if device == "Windows" or device == "Linux" or device == "MacOS" or device == "Web" or "BSD" in device:
			menu_instance = menu_pc.instantiate()
		else:
			menu_instance = menu_mobile.instantiate()
		pause_menu.add_child(menu_instance)

func _on_buttons_menu_principal_pressed():
	if game_paused:
		Engine.time_scale = 1
		pause_menu.visible = false
		SceneManager.load_new_scene("res://scenes/menu/menu.tscn", "wipe_to_right")


func _on_buttons_quit_pressed():
	get_tree().quit()
