extends Control

@onready var input_button_scene = preload("res://scenes/menu/button.tscn")
@onready var vol_master = $PanelContainer/MarginContainer/MarginContainer/MarginContainer2/HBoxContainer/VBoxContainer2/ScrollContainer/action_list_configs/HBox_Master/vol_master
@onready var vol_music = $PanelContainer/MarginContainer/MarginContainer/MarginContainer2/HBoxContainer/VBoxContainer2/ScrollContainer/action_list_configs/hBox_Music/vol_music
@onready var vol_sfx = $PanelContainer/MarginContainer/MarginContainer/MarginContainer2/HBoxContainer/VBoxContainer2/ScrollContainer/action_list_configs/HBox_sfx/vol_sfx
@onready var brilho = $PanelContainer/MarginContainer/MarginContainer/MarginContainer2/HBoxContainer/VBoxContainer2/ScrollContainer/action_list_configs/HBox_Brilho/slider_brilho
@onready var display = $PanelContainer/MarginContainer/MarginContainer/MarginContainer2/HBoxContainer/VBoxContainer2/ScrollContainer/action_list_configs/HBoxContainer/Display
@onready var vsync = $PanelContainer/MarginContainer/MarginContainer/MarginContainer2/HBoxContainer/VBoxContainer2/ScrollContainer/action_list_configs/HBoxContainer2/Vsync
@onready var check_button = $PanelContainer/MarginContainer/MarginContainer/MarginContainer2/HBoxContainer/VBoxContainer2/ScrollContainer/action_list_configs/HBoxContainer2/CheckButton
@onready var action_list = $PanelContainer/MarginContainer/MarginContainer/MarginContainer2/HBoxContainer/VBoxContainer/ScrollContainer/action_list_controls

var control_schemes = {
	"Controle1": {
		"move_up": "W",
		"move_down": "S",
		"move_right": "D",
		"move_left": "A",
		"interact": "E",
		"inventory": "B",
		"menu": "F",
		"run": "Shift",
		"pause": "Escape"
	},
	"Controle2": {
		"move_up": "Up",
		"move_down": "Down",
		"move_right": "Right",
		"move_left": "Left",
		"interact": "C",
		"inventory": "B",
		"menu": "V",
		"run": "X",
		"pause": "Escape"
	}
}

const KeyMap = {
	"W": KEY_W,
	"A": KEY_A,
	"S": KEY_S,
	"D": KEY_D,
	"Up": KEY_UP,
	"Down": KEY_DOWN,
	"Left": KEY_LEFT,
	"Right": KEY_RIGHT,
	"E": KEY_E,
	"B": KEY_B,
	"F": KEY_F,
	"C": KEY_C,
	"V": KEY_V,
	"X": KEY_X,
	"Shift": KEY_SHIFT,
	"Escape": KEY_ESCAPE,
}

var disp
var is_remapping = false
var action_to_remap = null
var remapping_button = null


var input_actions = {
	"move_up": "Frente",
	"move_down": "Baixo",
	"move_right": "Direita",
	"move_left": "Esquerda",
	"run": "Correr",
	"interact": "Interagir",
	"menu": "Celular",
	"inventory": "Bolsa",
}

const WINDOW_MODES: Array[String] = [
	"Tela Cheia",
	"Modo Janela",
	"Tela Cheia sem borda"
]

func _ready():
	add_window_mode_items()
	load_window()
	display.item_selected.connect(_on_display_item_selected)
	_load_keybinding_from_setting()
	load_vsync()
	load_sliders()
	load_button_input()
	_load_current_keybindings()

# ------------------------- Tela --------------------------
# Função para salvar o display selecionado
func _on_display_item_selected(index: int) -> void:
	on_window_mode_selected(index)

# Função de carregar display
func load_window():
	var video_settings = ConfigFileHandler.load_settings()
	if video_settings != null and video_settings.has("video"):
		var video_section = video_settings["video"]
		if video_section.has("display"):
			var display_mode = video_section["display"]
			if display_mode >= 0 and display_mode < WINDOW_MODES.size():
				display.select(display_mode)  # Seleciona o modo de exibição
				on_window_mode_selected(display_mode)
			else:
				print("Erro: display_mode fora dos limites válidos.")

# Modo de tela
func on_window_mode_selected(index: int) -> void:
	ConfigGeral.set_display_mode(index)
	# ConfigGeral.center_window()

# Adicionar modos de tela ao DisplayButton
func add_window_mode_items() -> void:
	for windows in WINDOW_MODES:
		display.add_item(windows)

# ---------------------- Input Map --------------------------
func _on_check_button_toggled(pressed: bool) -> void:
	if pressed:
		ConfigGeral.current_control = "Controle2"
	else:
		ConfigGeral.current_control = "Controle1"
		print("Controle atualizado para:", ConfigGeral.current_control)
	ConfigGeral.toggle_controls(pressed)
	_load_current_keybindings()

func load_button_input():
	var butt = ConfigFileHandler.load_control_settings()
	check_button.button_pressed = butt

func _load_current_keybindings():
	# Limpa a lista de ações existentes
	for item in action_list.get_children():
		item.queue_free()
	for action in ["move_up", "move_down", "move_right", "move_left", "interact", "inventory", "menu", "run", "pause"]:
		var key = ConfigFileHandler.get_keybinding(ConfigGeral.current_control, action)
		var button = Button.new() 
		button.text = action + ": " + key
		action_list.add_child(button) 

func _update_action_list(button, event):
	button.find_child("LabelInput").text = event.as_text().trim_suffix(" (Physical)")

func _load_keybinding_from_setting():
	var keybindings = ConfigFileHandler.keybindings
	var current_contro = ConfigGeral.current_control
	# Certifique-se de que a chave 'keybinding' está no dicionário de configurações
	if keybindings.has(current_contro):
		var keybinding = keybindings[current_contro]
		
		for action in keybinding.keys():
			var event = InputEventKey.new()
			# Verifique se a chave existe no KeyMap antes de atribuir
			if KeyMap.has(keybinding[action]):
				event.physical_keycode = KeyMap[keybinding[action]]
			else:
				print("Warning: Key not found in KeyMap for action: ", action)
				continue  # Ignora se a tecla não existir no KeyMap
			InputMap.action_erase_events(action)
			InputMap.action_add_event(action, event)
	else:
		print("Warning: Current control configuration not found: ", current_contro)

func load_sliders():
	var settings = ConfigFileHandler.load_settings()
	if settings.has("audio"):
		vol_master.value = settings["audio"].get("volumeMaster", 1) * 100
		vol_music.value = settings["audio"].get("volumeMusic", 1) * 100
		vol_sfx.value = settings["audio"].get("volumeSFX", 1) * 100
	if settings.has("video"):
		brilho.value = settings["video"].get("brightness", 1) * 100
# ---------------------- Vsync ---------------------------
func load_vsync():
	var settings = ConfigFileHandler.load_settings()
	if settings.has("video") and settings["video"].has("vsync"):
		vsync.button_pressed = settings["video"]["vsync"]
	else:
		print("Configuração de Vsync não encontrada.")

func _on_button_pressed():
	SceneManager.load_new_scene("res://scenes/menu/menu.tscn")

func _on_vsync_pressed():
	ConfigGeral.toggle_vsync()
	load_vsync()

# ----------------------- Sliders --------------------------

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

func _on_reset_button_pressed():
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
	
	check_button.button_pressed = false
	ConfigGeral.current_control = "Controle1"
	_load_current_keybindings()
	
	ConfigGeral.set_display_mode(0)
	display.select(0)
	
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
		"display": 0
	}
	settings["Controle"] = {
		"controle": false
	}
	ConfigFileHandler.save_settings(settings)
