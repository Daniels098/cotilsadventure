class_name Menu extends Control

var settings = {}

func _ready():
	load_user_settings()

func load_user_settings():
	settings = ConfigFileHandler.load_settings()

	if settings.has("video"):
		var display_mode = settings["video"].get("display", 1)
		ConfigGeral.set_display_mode(display_mode)

func _on_button_pressed():
	SceneManager.load_new_scene("res://scenes/areaLivreCotil/cantina_pra_escada.tscn", "wipe_to_right")

func _on_button_4_pressed():
	get_tree().quit()

func _on_btn_options_pressed():
	var device = OS.get_name()
	if device == "Windows" or device == "Linux" or device == "MacOS" or device == "Web" or "BSD" in device:
		SceneManager.load_new_scene("res://scenes/menu/options_MOBILE.tscn", "wipe_to_right") ######
	else: 
		SceneManager.load_new_scene("res://scenes/menu/options_MOBILE.tscn", "wipe_to_right")

func _on_button_3_pressed():
	SceneManager.load_new_scene("res://scenes/menu/credits.tscn", "wipe_to_right")


func _on_btn_login_pressed():
	pass #SceneManager.load_new_scene("res://scenes/menu/login_menu.tscn", "wipe_to_right")
