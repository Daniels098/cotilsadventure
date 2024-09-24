extends Control

@onready var input_button_scene = preload("res://scenes/menu/button.tscn")
@onready var action_list = $PanelContainer/MarginContainer/MarginContainer2/HBoxContainer/VBoxContainer/ScrollContainer/action_list_controls
@onready var vol_master = $PanelContainer/MarginContainer/MarginContainer2/HBoxContainer/VBoxContainer2/ScrollContainer/action_list_configs/HBox_Master/vol_master
@onready var vol_music = $PanelContainer/MarginContainer/MarginContainer2/HBoxContainer/VBoxContainer2/ScrollContainer/action_list_configs/hBox_Music/vol_music
@onready var vol_sfx = $PanelContainer/MarginContainer/MarginContainer2/HBoxContainer/VBoxContainer2/ScrollContainer/action_list_configs/HBox_sfx/vol_sfx
@onready var brilho = $PanelContainer/MarginContainer/MarginContainer2/HBoxContainer/VBoxContainer2/ScrollContainer/action_list_configs/HBox_Brilho/slider_brilho
@onready var display = $PanelContainer/MarginContainer/MarginContainer2/HBoxContainer/VBoxContainer2/ScrollContainer/action_list_configs/MarginContainer/HBoxContainer/Display
@onready var vsync = $PanelContainer/MarginContainer/MarginContainer2/HBoxContainer/VBoxContainer2/ScrollContainer/action_list_configs/HBoxContainer/Vsync
@onready var fps =$PanelContainer/MarginContainer/MarginContainer2/HBoxContainer/VBoxContainer2/ScrollContainer/action_list_configs/HBoxContainer/buttons_fps

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
	"Janela sem Borda",
	"Tela Cheia sem borda"
]

"""
	vsync //
	display //
	volumes master, music, sfx //
	max fps //
	fps show se for f
	brightness
"""
var disp
var is_remapping = false
var action_to_remap = null
var remapping_button = null

func _ready():
	add_window_mode_items()
	load_window()
	display.item_selected.connect(_on_display_item_selected)
	_load_keybinding_from_setting()
	_create_action_list()
	
	
	var audio_settings = ConfigFileHandler.load_audio_settings()
	vol_master.value = min(audio_settings.master_volume, 1.0)*100
	vol_music.value = min(audio_settings.get("music_volume", 1.0), 1.0)*100
	vol_sfx.value = min(audio_settings.sfx_volume, 1.0)*100

func _on_display_item_selected(index: int) -> void:
	on_window_mode_selected(index)
	ConfigFileHandler.save_video_settings("display", index)

func load_window():
	var video_settings = ConfigFileHandler.load_video_settings()
	if video_settings.has("display"):
		var display_mode = video_settings["display"]
		display.select(display_mode)
		on_window_mode_selected(display_mode)

func on_window_mode_selected(index: int) -> void:
	match index:
		0: # Tela cheia
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			ConfigFileHandler.save_video_settings("display", 0)
			
		1: # Janela
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			ConfigFileHandler.save_video_settings("display", 1)
		2: # Janela sem borda
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
			ConfigFileHandler.save_video_settings("display", 2)
		3: # Tela cheia sem borda
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
			ConfigFileHandler.save_video_settings("display", 3)

func add_window_mode_items() -> void:
	for windows in WINDOW_MODES:
		display.add_item(windows)

# Resetar action_list_controls
func _create_action_list():
	for item in action_list.get_children():
		item.queue_free()
	
	for action in input_actions:
		var button = input_button_scene.instantiate()
		var action_label = button.find_child("LabelAction")
		var input_label = button.find_child("LabelInput")
		
		#if action_label.text != null:
		action_label.text = input_actions[action]
		
		var events = InputMap.action_get_events(action)
		if events.size() > 0:
			input_label.text = events[0].as_text().trim_suffix(" (Physical)")
		else:
			input_label.text = ""
		
		action_list.add_child(button)
		button.pressed.connect(_on_input_button_pressed.bind(button, action))

func _on_input_button_pressed(button, action):
	if !is_remapping:
		is_remapping = true
		action_to_remap = action
		remapping_button = button
		button.find_child("LabelInput").text = "Pressione a tecla..."

func _input(event):
	if is_remapping:
		if ( event is InputEventKey ||
			(event is InputEventMouseButton && event.pressed)
		):
			if event is InputEventMouseButton && event.double_click:
				event.double_click = false
			
			InputMap.action_erase_events(action_to_remap)
			
			for action in input_actions:
				if InputMap.action_has_event(action, event):
					InputMap.action_erase_event(action, event)
					var buttons_action2 = action_list.get_children().filter(func(button):
						return button.find_child("LabelAction").text == input_actions[action]
					)
					for button in buttons_action2:
						button.find_child("LabelInput").text = ""
			
			InputMap.action_erase_events(action_to_remap)
			InputMap.action_add_event(action_to_remap, event)
			_update_action_list(remapping_button, event)
			ConfigFileHandler.save_keybinding(action_to_remap, event)
			
			is_remapping = false
			action_to_remap = null
			remapping_button = null
			
			accept_event()

func _update_action_list(button, event):
	button.find_child("LabelInput").text = event.as_text().trim_suffix(" (Physical)")

func _on_volume_value_changed(value):
	AudioServer.set_bus_volume_db(0,value)

func _on_check_box_pressed(toggled_on):
	AudioServer.set_bus_mute(0,toggled_on)

func _load_keybinding_from_setting():
	var keybinding = ConfigFileHandler.load_keybinding()
	for action in keybinding.keys():
		InputMap.action_erase_events(action)
		InputMap.action_add_event(action, keybinding[action])

func vol_reset():
	brilho.value = 50
	vol_master.value = 100
	vol_music.value = 100
	vol_sfx.value = 100

# Volumes and Buttons
func _on_reset_button_pressed():
	InputMap.load_from_project_settings()
	for action in input_actions:
		var events = InputMap.action_get_events(action)
		if events.size() > 0:
			ConfigFileHandler.save_keybinding(action, events[0])
	_create_action_list()

func _on_button_pressed():
	SceneManager.load_new_scene("res://scenes/menu/menu.tscn", "wipe_to_right")

func _on_reset_button_button_down():
	vol_reset()

func _on_vol_master_drag_ended(value_changed):
	if value_changed:
		ConfigFileHandler.save_audio_settings("master_volume", vol_master.value / 100)

func _on_vol_music_drag_ended(value_changed):
	if value_changed:
		ConfigFileHandler.save_audio_settings("music_volume", vol_music.value / 100)

func _on_vol_sfx_drag_ended(value_changed):
	if value_changed:
		ConfigFileHandler.save_audio_settings("sfx_volume", vol_sfx.value / 100)


func _on_slider_brilho_drag_ended(value_changed):
	pass # Replace with function body. ////

func _on_buttons_fps_pressed():
	pass # Replace with function body. /

func _on_check_button_pressed():
	pass # Replace with function body. /

func _on_h_slider_drag_ended(value_changed):
	pass # Replace with function body.
