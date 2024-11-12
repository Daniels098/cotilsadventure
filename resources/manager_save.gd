extends Node

signal save_game_request
var save_timer: Timer
var game_loaded := false

func _ready():
	save_timer = Timer.new()
	save_timer.wait_time = 300 # 5 minutos
	save_timer.connect("timeout", Callable(self, "_on_save_timer_timeout"))
	add_child(save_timer)
	save_timer.start()

func _on_save_timer_timeout():
	emit_signal("save_game_request")

func save_by_manager(): # SEMPRE CHAMAR O SAVE GAME DE FORA DO PLAYER POR ESTA FUNÇÃO
	emit_signal("save_game_request")
