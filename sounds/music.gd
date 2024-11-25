extends AudioStreamPlayer

var dict: Dictionary

func _ready():
	dict = ConfigFileHandler.load_audio_settings()
	volume_db = ConfigGeral.linear_to_db(dict["volumeMusic"])
	play()

func _process(delta):
	volume_db = ConfigGeral.music
