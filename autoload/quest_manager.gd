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
func complete_quest(quest) -> void:
	_active_quests.erase(quest)
	emit_signal("quest_completed", quest)

func check_item_in_inventory(item_id: String) -> bool:
	var player = get_tree().get_nodes_in_group("players")[0]
	var invi = player.invi  # Acessa o inventário do Player
	
	# Verifica se o jogador já possui o item no inventário
	if invi and invi.check_item_in_slots(item_id) != null:
		return true
	return false

# Retorna a lista de missões ativas
func get_active_quests() -> Array:
	return _active_quests
