extends Node

var settings = {}

const WINDOW_MODES: Array[String] = [
	"Tela Cheia",
	"Modo Janela",
	"Tela Cheia sem borda"
]

func _ready():
	load_settings()
	load_window()

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

# -------------------- Configuração de Brilho --------------------

# Ajustar o brilho
func set_brightness(value: float):
	settings["brightness"] = clamp(value, 0, 1)
	RenderingServer.set_default_clear_color(Color(value, value, value))
	save_settings()

# -------------------- Configurações de Áudio --------------------

# Ajustar volume master
func set_master_volume(value: float):
	settings["VolumeMaster"] = clamp(value, 0, 1)
	AudioServer.set_bus_volume_db(0, linear_to_db(value))
	save_settings()

# Ajustar volume da música
func set_music_volume(value: float):
	settings["VolumeMusic"] = clamp(value, 0, 1)
	AudioServer.set_bus_volume_db(1, linear_to_db(value))
	save_settings()

# Ajustar volume dos efeitos sonoros (SFX)
func set_sfx_volume(value: float):
	settings["VolumeSFX"] = clamp(value, 0, 1)
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

# -------------------- Configurações de Keybinding --------------------

# Definir novo keybinding
func set_keybinding(action: String, event: InputEvent):
	InputMap.action_erase_events(action)
	InputMap.action_add_event(action, event)
	if settings.has("Keybinding"):
		settings["Keybinding"][action] = event
	else:
		settings["Keybinding"] = {action: event}
	save_settings()

# -------------------- Funções Auxiliares --------------------

# Converter valor linear para dB (usado em volumes)
func linear_to_db(value: float) -> float:
	if value <= 0.0:
		return -80.0
	return 20.0 * log10(value)

func log10(value: float) -> float:
	return log(value) / log(10)
