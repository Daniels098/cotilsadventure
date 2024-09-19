extends Control

@onready var input_button_scene = preload("res://scenes/menu/button.tscn")
@onready var action_list = $PanelContainer/MarginContainer/VBoxContainer/ScrollContainer/action_list

var is_remapping = false
var action_to_remap = null
var remapping_button = null


func _ready():
	_load_keybinding_from_setting()
	_create_action_list()

func _creat_action_list():
	InputMap.load_from_project_settings()
	for item in action_list.get_children():
		item.queue_free()
	
	for action in InputMap.get_actions():
		var button = input_button_scene.instantiate()
		var action_label = button.find_child("LabelAction")
		var input_label = button.find_child("LabelInput")
		
		action_label.text = action
		
		var events = InputMap.action_get_events(action)
		if events.size() > 0:
			input_label.text = events[0].as_text()
		else:
			input_label.text = ""
		
		action_list.add_child(button)


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
