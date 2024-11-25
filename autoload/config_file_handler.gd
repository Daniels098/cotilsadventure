extends Node

var config = ConfigFile.new()
var jog = Player.new()
const SETTINGS_FILE_PATH = "user://settings.ini"
var keybindings = {}

func _ready():
	if !FileAccess.file_exists(SETTINGS_FILE_PATH):
		_initialize_settings()
	else:
		config.load(SETTINGS_FILE_PATH)
	load_video_settings()
	var err = config.save(SETTINGS_FILE_PATH)
	if err != OK:
		print("Erro ao salvar configurações:", err)
	keybindings = load_settings()

func _initialize_settings():
	config.set_value("Controle", "controle", false)
	config.set_value("Controle", "canhoto", false)
	# Inicializa as configurações padrão
	config.set_value("Controle1", "move_up", "W")
	config.set_value("Controle1", "move_down", "S")
	config.set_value("Controle1", "move_right", "D")
	config.set_value("Controle1", "move_left", "A")
	config.set_value("Controle1", "interact", "E")
	config.set_value("Controle1", "inventory", "B")
	config.set_value("Controle1", "menu", "F")
	config.set_value("Controle1", "run", "Shift")
	config.set_value("Controle1", "pause", "Escape")

	# Configurações para Controle 2
	config.set_value("Controle2", "move_up", "Up")
	config.set_value("Controle2", "move_down", "Down")
	config.set_value("Controle2", "move_right", "Right")
	config.set_value("Controle2", "move_left", "Left")
	config.set_value("Controle2", "interact", "C")
	config.set_value("Controle2", "inventory", "B")
	config.set_value("Controle2", "menu", "V")
	config.set_value("Controle2", "run", "X")
	config.set_value("Controle2", "pause", "Escape")

	config.set_value("video", "vsync", true)
	config.set_value("video", "display", 0)
	
	config.set_value("audio", "volumeMaster", 1.0)
	config.set_value("audio", "volumeMusic", 1.0)
	config.set_value("audio", "volumeSFX", 1.0)

	config.save(SETTINGS_FILE_PATH)

func get_keybinding(control: String, action: String):
	var settings = load_settings()
	if settings.has(control) and settings[control].has(action):
		return settings[control][action]
	else:
		print("Keybinding não encontrada para o controle: ", control, ", ação: ", action)
		return "None"  # Ou qualquer valor padrão que você queira

func load_settings() -> Dictionary:
	var settings = {}
	# var config = ConfigFile.new()
	if config.load(SETTINGS_FILE_PATH) == OK:
		for section in config.get_sections():
			settings[section] = {}
			for key in config.get_section_keys(section):
				settings[section][key] = config.get_value(section, key)
	else:
		print("Erro ao carregar o arquivo de configurações.")
	return settings

func save_settings(settings: Dictionary):
	if typeof(settings) != TYPE_DICTIONARY:
		print("Erro: 'settings' não é um dicionário válido.")
		return
	# Loop sobre as seções (primeiro nível do dicionário)
	for section in settings.keys():
		# Certifique-se de que cada seção seja um Dictionary
		if typeof(settings[section]) != TYPE_DICTIONARY:
			print("Erro: A seção '%s' não é um dicionário." % section)
			continue  # Pula para a próxima seção
		# Loop sobre as chaves dentro de cada seção
		for key in settings[section].keys():
			config.set_value(section, key, settings[section][key])
	# Tenta salvar o arquivo de configurações
	var err = config.save(SETTINGS_FILE_PATH)
	if err != OK:
		print("Erro ao salvar configurações:", err)
	else:
		config.save(SETTINGS_FILE_PATH)


func load_video_settings():
	var video_settings = {}
	if config.load(SETTINGS_FILE_PATH) == OK:
		if config.has_section("video"):
			for key in config.get_section_keys("video"):
				video_settings[key] = config.get_value("video", key)
			print("Configurações de vídeo carregadas:", video_settings)
			if video_settings.has("display"):
				#print(video_settings["display"])
				ConfigGeral.set_display_mode(video_settings["display"])
			else:
				print("Erro: Chave 'display' não encontrada nas configurações de vídeo.")				
		else:
			print("Erro: Seção 'video' não encontrada no arquivo de configurações.")
	else:
		print("Erro ao carregar o arquivo de configurações.")
	return video_settings

func save_audio_settings(key: String, value):
	config.set_value("audio", key, value)
	config.save(SETTINGS_FILE_PATH)

func load_audio_settings():
	var audio_settings = {}
	for key in config.get_section_keys("audio"):
		audio_settings[key] = config.get_value("audio", key)
	return audio_settings

func save_keybinding(action: StringName, event: InputEvent):
	var event_str
	if event is InputEventKey:
		event_str = OS.get_keycode_string(event.physical_keycode)
	config.set_value("keybinding", action, event_str)
	config.save(SETTINGS_FILE_PATH)

func _load_keybinding_from_setting(current_control):
	var keybinding = keybindings[current_control]
	for action in keybinding.keys():
		var event = InputEventKey.new()
		event.scancode = InputEventKey[keybinding[action]]
		InputMap.action_erase_events(action)
		InputMap.action_add_event(action, event)

func save_control_settings(botao):
	var settings = load_settings()
	settings["Controle"]["controle"] = botao
	save_settings(settings)

func load_control_settings():
	var settings = load_settings()  
	if settings.has("Controle"):
		return settings["Controle"]["controle"]
	else:
		print("Erro: Seção 'Controle' não encontrada nas configurações.")
		return false
