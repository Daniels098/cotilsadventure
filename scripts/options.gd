extends Control

func _ready():
	_load_keybinding_from_setting()
	#_create_action_list()

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
