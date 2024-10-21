class_name Menu extends Control

var settings = {}
var last_scene = "res://scenes/areaLivreCotil/cantina_pra_escada.tscn"  # Cena padrão
var jso = JSON.new()
var invi = Inv.new()
var inventory: Array
var nome: String
@onready var input = $LineEdit

func _ready():
	$btn_start.disabled = true
	load_user_settings()
	load_last_scene()

func load_last_scene():
	var file = FileAccess.open("user://save_game.json", FileAccess.READ)
	if file:
		var json_string = file.get_as_text()
		var error = jso.parse(json_string)
		if error == OK:
			last_scene = jso.data["scene"]
		#	print("Scene is okay")
		#else:
		#	print("Scene is not okay")
		file.close()

func load_user_settings():
	settings = ConfigFileHandler.load_settings()
	if settings.has("video"):
		var display_mode = settings["video"].get("display", 1)
		ConfigGeral.set_display_mode(display_mode)

func _process(delta):
	analize_name()
	# get_playername()
	$Label.text = "Digite seu nome para iniciar!"

func _on_button_pressed():
	if get_playername():
		# invi.load_inventory()
		SceneManager.load_new_scene(last_scene, "wipe_to_right")

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

func analize_name():
	var nome = ConfigGeral.get_name_player()
	print("DENTRO DE ANALIZE NAME")
	print(nome)
	if nome != "" and nome != null:
		$LineEdit.editable = true
		get_playername()
	else:
		$LineEdit.editable = false
		$LineEdit.text = ConfigGeral.get_name_player()

func get_playername():
	nome = input.text
	if !nome.is_empty() && nome.length() > 3 && !nome.is_valid_int() && !nome.is_valid_float():
		$btn_start.disabled = false
		nome = nome.to_lower().capitalize()
		ConfigGeral.set_name_player(name)
		return true
	else:
		$btn_start.disabled = true
		# print("Insira apenas letras")
		return false

func _on_btn_login_pressed():
	SceneManager.load_new_scene("res://scenes/menu/login_menu.tscn", "wipe_to_right")
