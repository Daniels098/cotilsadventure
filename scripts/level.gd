class_name Level extends Node2D

@export var player: Player
@export var doors:Array[Door]
@onready var pause_menu = $MenuPause
var data: LevelDataHandoff
var game_paused = false
var button_layer = preload("res://scenes/controlsTouch.tscn")
var button_layer_canhoto = preload("res://scenes/controlsTouchCanhoto.tscn")
var _save: SaveGame

func _ready():
	player = get_tree().get_first_node_in_group("players")
	if player != null:
		player.disable_mode
		player.visible = false
		if not ManagerSave.game_loaded:
			player.load_player_data()
	if data == null:
		enter_level()
	load_button_layout()

func load_button_layout():
	if ConfigGeral.is_canhoto_func():
		if $ButtonLayerDestro != null:
			$ButtonLayerDestro.visible = false
		$ButtonLayerCanhoto.visible = true
	else:
		if $ButtonLayerCanhoto != null:
			$ButtonLayerCanhoto.visible = false
		$ButtonLayerDestro.visible = true

func enter_level() -> void:
	if data != null:
		init_player_location()
	if player != null:
		player.enable()
	_connect_to_doors()

func _unhandled_input(event):
	if event.is_action_released("pause"):
		if $LojinhaApm != null:
			if $Inv_GUI.visible or $QuestGUI/Panel.visible or $LojinhaApm.visible:
				return
		else:
			if $Inv_GUI.visible or $QuestGUI/Panel.visible:
				return
		if $MenuPause.visible or $Inv_GUI.visible or $QuestGUI/Panel.visible:
			if ConfigGeral.is_canhoto_func():
				$ButtonLayerCanhoto.visible = false
			else:
				$ButtonLayerDestro.visible = false
		else:
			if ConfigGeral.is_canhoto_func():
				$ButtonLayerCanhoto.visible = true
			else:
				$ButtonLayerDestro.visible = true
		game_paused = !game_paused
		if game_paused:
			Engine.time_scale = 0
			pause_menu.visible = true
		else:
			Engine.time_scale = 1
			pause_menu.visible = false
			load_button_layout()
		get_tree().root.get_viewport().set_input_as_handled()

func init_player_location() -> void:
	# ta dando erro de null pq o level que o boneco vai nao tem player pra dar assign
	if data != null:
		for door in doors:
			if door.name == data.entry_door_name:
				player.position = door.get_player_entry_vector()
		if player != null:
			player.orient(data.move_dir)

func _on_player_entered_door(door:Door) -> void:
	_disconnect_from_doors()
	player.disable()
	player.queue_free()
	data = LevelDataHandoff.new()
	data.entry_door_name = door.entry_door_name
	data.move_dir = door.get_move_dir()
	set_process(false)

func _connect_to_doors() -> void:
	for door in doors:
		if not door.player_entered_door.is_connected(_on_player_entered_door):
			door.player_entered_door.connect(_on_player_entered_door)

func _disconnect_from_doors() -> void:
	for door in doors:
		if door.player_entered_door.is_connected(_on_player_entered_door):
			door.player_entered_door.disconnect(_on_player_entered_door)
