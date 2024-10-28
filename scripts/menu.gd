class_name Menu extends Control

var settings = {}
var last_scene = "res://scenes/areaLivreCotil/cantina_pra_escada.tscn"  # Cena padrão
var jso = JSON.new()
var invi = Inv.new()
var inventory: Array

func _ready():
	load_user_settings()
	mostrar_nome_player()

func load_last_scene():
	var cloud = ConfigGeral.data_cloud
	var file = FileAccess.open("user://save_game.json", FileAccess.READ)
	if file:
		var json_string = file.get_as_text()
		var error = jso.parse(json_string)
		if error == OK:
			last_scene = jso.data["scene"]
		file.close()
	elif cloud["scene"] != null:
		print(cloud["scene"])
		last_scene = cloud["scene"]

func load_user_settings():
	settings = ConfigFileHandler.load_settings()
	if settings.has("video"):
		var display_mode = settings["video"].get("display", 1)
		ConfigGeral.set_display_mode(display_mode)

func _on_button_4_pressed():
	get_tree().quit()

func _on_btn_options_pressed():
	var device = OS.get_name()
	if device == "Windows" or device == "Linux" or device == "MacOS" or device == "Web" or "BSD" in device:
		SceneManager.load_new_scene("res://scenes/menu/options_PC.tscn", "wipe_to_right") ######
	else: 
		SceneManager.load_new_scene("res://scenes/menu/options_MOBILE.tscn", "wipe_to_right")

func _on_button_3_pressed():
	SceneManager.load_new_scene("res://scenes/menu/credits.tscn", "wipe_to_right")

func _on_btn_login_pressed():
	SceneManager.load_new_scene("res://scenes/menu/login_menu.tscn", "wipe_to_right")

func mostrar_nome_player():
	$Label.text = "Olá, " + ConfigGeral.get_name_player()

func _process(delta):
	if $Label.text == "Olá, Aluno":
		$btn_login.visible = true
		$btn_start.visible = false
	else:
		$btn_login.visible = false
		$btn_start.visible = true
		load_last_scene()

func _on_btn_start_pressed():
	SceneManager.load_new_scene(last_scene, "wipe_to_right")
