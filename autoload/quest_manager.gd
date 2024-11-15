extends Node

# Lista de missões ativas, que serão mantidas entre cenas
var _active_quests: Array = []

# Sinais para notificar mudanças nas missões, se precisar conectar a outros scripts
signal quest_added
signal quest_completed

# Adiciona uma nova missão à lista ativa (até o limite que você definir)
func add_quest(quest) -> void:
	if _active_quests.size() < 3:
		_active_quests.append(quest)
		emit_signal("quest_added", quest)

 # Marca uma missão como completa e a remove das ativas
func completed_quest(quest) -> void: # Complete_quest porém tem o mesmo nome que outra função e da conflito ao chamar no DialogueManager
	_active_quests.erase(quest)
	emit_signal("quest_completed", quest)

# Retorna a lista de missões ativas
func get_active_quests() -> Array:
	return _active_quests
