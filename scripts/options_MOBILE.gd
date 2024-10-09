extends Control

@onready var input_button_scene = preload("res://scenes/menu/button.tscn")
@onready var vol_master = $PanelContainer/MarginContainer/MarginContainer2/HBoxContainer/VBoxContainer2/ScrollContainer/action_list_configs/HBox_Master/vol_master
@onready var vol_music = $PanelContainer/MarginContainer/MarginContainer2/HBoxContainer/VBoxContainer2/ScrollContainer/action_list_configs/hBox_Music/vol_music
@onready var vol_sfx = $PanelContainer/MarginContainer/MarginContainer2/HBoxContainer/VBoxContainer2/ScrollContainer/action_list_configs/HBox_sfx/vol_sfx
@onready var brilho = $PanelContainer/MarginContainer/MarginContainer2/HBoxContainer/VBoxContainer2/ScrollContainer/action_list_configs/HBox_Brilho/slider_brilho
@onready var vsync = $PanelContainer/MarginContainer/MarginContainer2/HBoxContainer/VBoxContainer2/ScrollContainer/action_list_configs/HBoxContainer2/Vsync
@onready var canhoto = $PanelContainer/MarginContainer/MarginContainer2/HBoxContainer/VBoxContainer2/ScrollContainer/action_list_configs/HBoxContainer3/ModeCanhoto

"""
	vsync //
	display //
	volumes master, music, sfx //
	max fps //
	fps show se for f
	brightness
"""

func _ready():
	load_vsync()
	load_sliders()
	load_canhoto()

# ------------- Buttons reset and to back ------------------------
# Button Voltar
func _on_button_pressed():
	SceneManager.load_new_scene("res://scenes/menu/menu.tscn", "wipe_to_right")

# Button reset volume
func _on_reset_button_button_down():
	# Valores padrão para áudio
	vol_master.value = 100
	vol_music.value = 100
	vol_sfx.value = 100
	ConfigGeral.set_master_volume(1)
	ConfigGeral.set_music_volume(1)
	ConfigGeral.set_sfx_volume(1)
	
	# Valor padrão para brilho
	brilho.value = 50
	ConfigGeral.set_brightness(0.5)
	
	# Valor padrão para Vsync e CheckButton
	vsync.button_pressed = true
	ConfigGeral.toggle_vsync()
	
	canhoto.button_pressed = false
	var current_control = "Destro"
	
	# Salvar configurações padrão no arquivo settings.ini
	var settings = ConfigFileHandler.load_settings()
	settings["audio"] = {
		"volumeMaster": 1,
		"volumeMusic": 1,
		"volumeSFX": 1
	}
	settings["video"] = {
		"brightness": 0.5,
		"vsync": true,
	}
	settings["Controle"] = {
		"canhoto": false
	}
	ConfigFileHandler.save_settings(settings)

# ---------------------- Buttons Config esquerda ---------------------------
# logica para o botao vsync
func _on_vsync_pressed():
	ConfigGeral.toggle_vsync()
	load_vsync()

func load_vsync():
	var settings = ConfigFileHandler.load_settings()
	if settings.has("video") and settings["video"].has("vsync"):
		vsync.button_pressed = settings["video"]["vsync"]
	else:
		print("Configuração de Vsync não encontrada.")

# ---------------------- Modo Canhoto --------------------------
func load_canhoto():
	var settings = ConfigFileHandler.load_settings()
	if settings.has("Controle") and settings["Controle"].has("canhoto"):
		canhoto.button_pressed = settings["Controle"]["canhoto"]
	else:
		print("Configuração de 'canhoto' não encontrada.")

func _on_mode_canhoto_pressed():
	ConfigGeral.set_canhoto(canhoto.button_pressed)

# Função no ConfigGeral

# ----------------------- Sliders --------------------------

func load_sliders():
	var settings = ConfigFileHandler.load_settings()
	if settings.has("audio"):
		vol_master.value = settings["audio"].get("volumeMaster", 1) * 100
		vol_music.value = settings["audio"].get("volumeMusic", 1) * 100
		vol_sfx.value = settings["audio"].get("volumeSFX", 1) * 100
	if settings.has("video"):
		brilho.value = settings["video"].get("brightness", 1) * 100

func _on_slider_brilho_value_changed(value):
	var val = brilho.value/100
	ConfigGeral.set_brightness(val)

func _on_vol_master_value_changed(value):
	var val = vol_master.value/100
	ConfigGeral.set_master_volume(val)

func _on_vol_music_value_changed(value):
	var val = vol_music.value/100
	ConfigGeral.set_music_volume(val)

func _on_vol_sfx_value_changed(value):
	var val = vol_sfx.value/100
	ConfigGeral.set_sfx_volume(val)
