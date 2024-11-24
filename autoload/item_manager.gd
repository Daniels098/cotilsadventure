extends Node

signal remove_item_signal(item_id: String)

var collected_items = []
var locais := []

# Função para registrar um item como coletado
func register_item(item_id: String) -> void:
	if item_id not in collected_items:
		collected_items.append(item_id)
		ManagerSave.save_by_manager()  # Salva o progresso ao registrar um item

# Função para verificar se um item já foi coletado
func is_item_collected(item_id: String) -> bool:
	return item_id in collected_items

# Verifica se o jogador já possui o item no inventário
func check_item_in_inventory(item_id: String) -> bool:
	var player_nodes = get_tree().get_nodes_in_group("players")
	if player_nodes.size() == 0:
		print("Jogador não encontrado na cena!")
		return false  # Retorna falso se o jogador não for encontrado.
	
	var player = player_nodes[0]
	var invi = player.invi
	if invi and invi.check_item_in_slots(item_id):
		return true
	return false

# Função para remover um item específico do inventário
# Função para remover um item específico do inventário, caso ele exista
func remove_item(item_id: String) -> void:
	var player_nodes = get_tree().get_nodes_in_group("players")
	if player_nodes.size() == 0:
		print("Jogador não encontrado na cena!")
		return
	
	var player = player_nodes[0]
	var invi = player.invi

	# Verifica se o item existe no inventário antes de remover
	if invi and invi.check_item_in_slots(item_id):
		emit_signal("remove_item_signal", item_id)
		invi.remove_item(item_id)
		ManagerSave.save_by_manager()  # Salva o progresso após a remoção
		print("Item removido do inventário e progresso salvo.")
	else:
		print("Item não encontrado no inventário.")

# Carregar o estado dos itens coletados ao iniciar o jogo
func load_collected_items() -> void:
	pass # collected_items = SaveGame.load_collected_items()  # Carrega os itens coletados da última sessão

## ------------------- Funções de Locais -------------------

func visit_local(local_nome: String):
	locais.push_back(local_nome)

func is_visited(local_nome: String) -> bool:
	if locais.has(local_nome):
		return true
	return false
