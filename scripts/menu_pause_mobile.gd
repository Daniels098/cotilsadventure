extends CanvasLayer

@onready var input_button_scene = preload("res://scenes/menu/button.tscn")
@onready var vol_master = $MenuPauseMobile/PanelContainer/MarginContainer/MarginContainer2/HBoxContainer/VBoxContainer2/ScrollContainer/action_list_configs/HBox_Master/vol_master
@onready var vol_music = $MenuPauseMobile/PanelContainer/MarginContainer/MarginContainer2/HBoxContainer/VBoxContainer2/ScrollContainer/action_list_configs/hBox_Music/vol_music
@onready var vol_sfx = $MenuPauseMobile/PanelContainer/MarginContainer/MarginContainer2/HBoxContainer/VBoxContainer2/ScrollContainer/action_list_configs/HBox_sfx/vol_sfx
@onready var brilho = $MenuPauseMobile/PanelContainer/MarginContainer/MarginContainer2/HBoxContainer/VBoxContainer2/ScrollContainer/action_list_configs/HBox_Brilho/slider_brilho
@onready var vsync = $PanelContainer/MarginContainer/MarginContainer2/HBoxContainer/VBoxContainer2/ScrollContainer/action_list_configs/HBoxContainer2/Vsync
@onready var canhoto = $MenuPauseMobile/PanelContainer/MarginContainer/MarginContainer2/HBoxContainer/VBoxContainer2/ScrollContainer/action_list_configs/HBoxContainer3/ModeCanhoto
@onready var main = $"."

"""
	vsync 
	display 
	volumes master, music, sfx 
	brightness
"""

func _ready():
	load_vsync()
	load_sliders()


# ----------------------- Sliders --------------------------
# Reset dos sliders do volume
func vol_reset():
	brilho.value = 50
	vol_master.value = 100
	vol_music.value = 100
	vol_sfx.value = 100

# Setar volume Master
func _on_volume_value_changed(value):
	AudioServer.set_bus_volume_db(0,value)

# Setar volume Master
func _on_check_box_pressed(toggled_on):
	AudioServer.set_bus_mute(0,toggled_on)

func load_sliders():
	var audio_settings = ConfigFileHandler.load_audio_settings()
	var video_settings = ConfigFileHandler.load_video_settings()
	
	brilho.value = min(video_settings.get("brightness"), 1.0)*100
	vol_master.value = min(audio_settings.get("master_volume"), 1.0)*100
	vol_music.value = min(audio_settings.get("music_volume"), 1.0)*100
	vol_sfx.value = min(audio_settings.get("sfx_volume"), 1.0)*100

# ------------- Buttons reset and to back ------------------------
# Button Voltar
func _on_button_pressed():
	queue_free()

# Button reset volume
func _on_reset_button_button_down():
	vol_reset()

# --------------------- Sliders ---------------------------
# Salvar slider Master
func _on_vol_master_drag_ended(value_changed):
	ConfigFileHandler.save_audio_settings("master_volume", vol_master.value / 100)

# Salvar slider da musica
func _on_vol_music_drag_ended(value_changed):
	ConfigFileHandler.save_audio_settings("music_volume", vol_music.value / 100)

# Salvar slider do sfx
func _on_vol_sfx_drag_ended(value_changed):
	ConfigFileHandler.save_audio_settings("sfx_volume", vol_sfx.value / 100)

# Salvar slider do brilho
func _on_slider_brilho_drag_ended(value_changed):
	ConfigFileHandler.save_video_settings("brightness", brilho.value / 100)

# ---------------------- Buttons Config esquerda ---------------------------
# logica para o botao vsync
func _on_vsync_pressed():
	if DisplayServer.window_get_vsync_mode() == DisplayServer.VSYNC_DISABLED:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		vsync.button_pressed = true
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		vsync.button_pressed = false
		Engine.max_fps = 0
	ConfigFileHandler.save_video_settings("vsync", DisplayServer.window_get_vsync_mode())# == DisplayServer.VSYNC_ENABLED)

func load_vsync():
	var video_settings = ConfigFileHandler.load_video_settings()
	if video_settings.has("vsync"):
		var vsync_enabled = video_settings["vsync"]
		if vsync_enabled:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
			vsync.button_pressed = true
		else:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
			Engine.max_fps = 0
			vsync.button_pressed = false

# ---------------------- Modo Canhoto --------------------------
func load_canhoto():
	pass

func _on_mode_canhoto_pressed():
	pass

func save_canhoto():
	pass
