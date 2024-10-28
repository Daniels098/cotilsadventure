extends Node

var settings = {}
var data_cloud
var current_control = "Controle1"
var is_canhoto
var nome_player: String = "Aluno"
var username: String

const ControleGeral = {
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


const WINDOW_MODES: Array[String] = [
	"Tela Cheia",
	"Modo Janela",
	"Tela Cheia sem borda"
]

func _ready():
	load_settings()
	load_window()
	load_controles()

# ------------------- Gerenciamento de Configurações -------------------

# Carregar as configurações do arquivo 'settings.ini'
func load_settings():
	settings = ConfigFileHandler.load_settings()

# Salvar as configurações no arquivo 'settings.ini'
func save_settings():
	ConfigFileHandler.save_settings(settings)

# -------------------- Configurações de Display --------------------

# Aplicar o modo de display
func set_display_mode(index: int):
	match index:
		0: # Tela cheia
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		1: # Modo Janela
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		2: # Tela cheia sem borda
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
	
	
	if settings.has("video"):
		settings["video"]["display"] = index
	save_settings()

# Função de carregar display
func load_window():
	var video_settings = ConfigFileHandler.load_settings()
	if video_settings != null and video_settings.has("video"):
		var video_section = video_settings["video"]
		if video_section.has("display"):
			var display_mode = video_section["display"]
			#print(display_mode)
			if display_mode >= 0 and display_mode < WINDOW_MODES.size():
				set_display_mode(display_mode)
			else:
				print("Erro: display_mode fora dos limites válidos.")

func center_window():
	var screen = DisplayServer.screen_get_position() +  DisplayServer.screen_get_size() / 2
	var window_size = get_window().get_size_with_decorations()
	get_window().set_position(screen - window_size / 2)

# -------------------- Configuração de Brilho --------------------

# Ajustar o brilho
func set_brightness(value: float):
	if not settings.has("video"):
		settings["video"] = {}
	settings["video"]["brightness"] = value
	RenderingServer.set_default_clear_color(Color(value, value, value))
	save_settings()

# -------------------- Configurações de Áudio --------------------

# Ajustar volume master
func set_master_volume(value: float):
	if not settings.has("audio"):
		settings["audio"] = {}
	settings["audio"]["volumeMaster"] = value
	AudioServer.set_bus_volume_db(0, linear_to_db(value))
	save_settings()

# Ajustar volume da música
func set_music_volume(value: float):
	if not settings.has("audio"):
		settings["audio"] = {}
	settings["audio"]["volumeMusic"] = value
	AudioServer.set_bus_volume_db(1, linear_to_db(value))
	save_settings()

# Ajustar volume dos efeitos sonoros (SFX)
func set_sfx_volume(value: float):
	if not settings.has("audio"):
		settings["audio"] = {}
	settings["audio"]["volumeSFX"] = value
	AudioServer.set_bus_volume_db(2, linear_to_db(value))
	save_settings()

# -------------------- Configuração de Vsync --------------------

# Ativar ou desativar Vsync
func toggle_vsync():
	var vsync_enabled = DisplayServer.window_get_vsync_mode() == DisplayServer.VSYNC_ENABLED
	if vsync_enabled:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		Engine.max_fps = 0
		settings["video"]["vsync"] = false
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		settings["video"]["vsync"] = true
	save_settings()

# -------------------- Configuração do Keybinding --------------------
func update_keybinding():
	if settings and settings.has("Controle"):
		var controle_key = "Controle1"
		if settings["Controle"]["controle"] == true:
			controle_key = "Controle2"
		var controle = settings[controle_key]
		for key in controle.keys():
			if not controle.has(key):
				print("Erro: Chave não encontrada no settings:", key)
				continue
			InputMap.action_erase_events(key)
			var event = InputEventKey.new()
			var pressed = controle[key]
			if ControleGeral.has(pressed):
				event.physical_keycode = ControleGeral[pressed]
				InputMap.action_add_event(key, event)
			else:
				print("Erro ao colocar a tecla no Controle:", key)

func toggle_controls(val: bool):
	if settings and settings.has("Controle"):
		settings["Controle"]["controle"] = val
		print("Novo estado do controle: ", val)
		ConfigFileHandler.save_control_settings(val)
		update_keybinding()
		save_settings()
	else:
		print("Configuração de 'Controle' não encontrada.")

func load_controles():
	if settings and settings.has("Controle"):
		var controle_ativo = settings["Controle"]["controle"]
		if controle_ativo == true:
			current_control = "Controle1"
		else:
			current_control = "Controle2"
		update_keybinding()

func set_canhoto(val: bool):
	settings["Controle"]["canhoto"] = val
	is_canhoto = val
	save_settings()

# -------------------- Funções Auxiliares --------------------

# Função do nome do jogador
func set_name_player(nome: String):
	nome_player = nome
	return nome_player

func get_name_player() -> String:
	print("RETORNO DE NOME ABAIXO")
	print(nome_player)
	return nome_player

# Converter valor linear para dB (usado em volumes)
func linear_to_db(value: float) -> float:
	if value <= 0.0:
		return -80.0
	return 20.0 * log10(value)

func log10(value: float) -> float:
	return log(value) / log(10)
