extends Node

var config = ConfigFile.new()
var jog = Player.new()
const SETTINGS_FILE_PATH = "user://setting.ini"

func _ready():
	if !FileAccess.file_exists(SETTINGS_FILE_PATH):
		config.set_value("keybinding", "move_up", "W")
		config.set_value("keybinding", "move_down", "S")
		config.set_value("keybinding", "move_right", "D")
		config.set_value("keybinding", "move_left", "A")
		config.set_value("keybinding", "interact", "E")
		config.set_value("keybinding", "inventory", "B")
		config.set_value("keybinding", "menu", "F")
		config.set_value("keybinding", "run", "Shift")
		config.set_value("keybinding", "pause", "Escape")
		
		config.set_value("video", "show_fps", false)
		config.set_value("video", "fps", 30)
		config.set_value("video", "vsync", true)
		config.set_value("video", "fps_button_pressed", false)
		config.set_value("video", "fps_val", 30)
		config.set_value("video", "brightness", 1.0)
		config.set_value("video", "display", 0)
		
		config.set_value("Player", "player_name", jog.name)
		
		config.set_value("audio", "master_volume", 1.0)
		config.set_value("audio", "music_volum", 1.0)
		config.set_value("audio", "sfx_volume", 1.0)
		
		config.save(SETTINGS_FILE_PATH)
	else:
		config.load(SETTINGS_FILE_PATH)

func save_video_settings(key: String, value):
	config.set_value("video", key, value)
	config.save(SETTINGS_FILE_PATH)

func load_video_settings():
	var video_settings = {}
	for key in config.get_section_keys("video"):
		video_settings[key] = config.get_value("video", key)
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

func load_keybinding():
	var keybinding = {}
	var keys = config.get_section_keys("keybinding")
	for key in keys:
		var input_event
		var event_str = config.get_value("keybinding", key)
		
		if event_str.contains("mouse_"):
			input_event = InputEventMouseButton.new()
			input_event.button_index = int(event_str.split("_")[1])
		else:
			input_event = InputEventKey.new()
			input_event.keycode = OS.find_keycode_from_string(event_str)
		
		keybinding[key] = input_event
	return keybinding
