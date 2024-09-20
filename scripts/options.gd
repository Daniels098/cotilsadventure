extends Control

@onready var input_button_scene = preload("res://scenes/menu/button.tscn")
@onready var action_list = $PanelContainer/MarginContainer/VBoxContainer/ScrollContainer/action_list

var input_actions = {
	"move_up": "Frente",
	"move_down": "Baixo",
	"move_right": "Direita",
	"move_left": "Esquerda",
	"interact": "Interagir",
	"run": "Correr"
}

var is_remapping = false
var action_to_remap = null
var remapping_button = null

func _ready():
	_load_keybinding_from_setting()
	_create_action_list()

func _create_action_list():
	InputMap.load_from_project_settings()
	for item in action_list.get_children():
		item.queue_free()
	
	for action in input_actions:
		var button = input_button_scene.instantiate()
		var action_label = button.find_child("LabelAction")
		var input_label = button.find_child("LabelInput")
		
		if action_label.text != null:
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
			if action_to_remap != null:
				InputMap.action_erase_events(action_to_remap)
				InputMap.action_add_event(action_to_remap, event)
				_update_action_list(remapping_button, event)
			
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

# Conectar os sinais dos botoes no configfile

func _load_keybinding_from_setting():
	var keybinding = ConfigFileHandler.load_keybinding()
	for action in keybinding.keys():
		InputMap.action_erase_events(action)
		InputMap.action_add_event(action, keybinding[action])
		#ConfigFileHandles.save_keybinding(action_to_remap, event)


func _on_reset_button_pressed():
	_create_action_list()


func _on_button_pressed():
	SceneManager.load_new_scene("res://scenes/menu/menu.tscn", "wipe_to_right")
