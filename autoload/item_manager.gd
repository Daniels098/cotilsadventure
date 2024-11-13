extends Node

signal remove_item_signal(item_id: String)

var collected_items = []

# Função para registrar um item como coletado
func register_item(item_id: String) -> void:
	if item_id not in collected_items:
		collected_items.append(item_id)

# Função para verificar se um item já foi coletado
func is_item_collected(item_id: String) -> bool:
	return item_id in collected_items

# Verifica se o jogador já possui o item no inventário
func check_item_in_inventory(item_id: String) -> bool:
	var player_nodes = get_tree().get_nodes_in_group("players")
	if player_nodes.size() == 0:
		print("Jogador não encontrado na cena!")
		return false # Retorna falso se o jogador não for encontrado.
	
	var player = player_nodes[0]
	var invi = player.invi
	if invi.check_item_in_slots(item_id):
		return true
	return false


# Função para remover um item específico do inventário
func remove_item(item_id: String) -> void:
	var player = get_tree().get_nodes_in_group("players")[0]
	var invi = player.invi
	emit_signal("remove_item_signal", item_id)
	invi.remove_item(item_id)
