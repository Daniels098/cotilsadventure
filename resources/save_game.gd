extends Node
class_name SaveGame
# Caminho para o arquivo de save
const SAVE_PATH = "user://save_game.json"
var data = {}
var inv := Inv.new()
var jso := JSON.new()

# Função para salvar os dados do jogador
func save_game(cfg: String, player: Player, inv: Inv, scene_name: String, mission: String) -> void:
	cfg = ConfigGeral.nome_player
	var save_data = {
		"player_name": cfg,
		"position": {
			"x": player.position.x,
			"y": player.position.y
		},
		"scene": scene_name,
		"mission": mission, # ID da missão possivelmente
		"inventory": get_node("/root/GlobalInventory").invi.save()
	}
	"""# Salvar inventário
	for slot in inv.slots:
		if slot.item:
			save_data["inventory"].append({
			"item_name": slot.item.nome,
			"amount": slot.amount
			})"""
	
	# Escrever o arquivo de save
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(
			jso.stringify(save_data, "\t")
		)
		file.close()
		print("Jogo salvo com sucesso!")

# Função para carregar os dados do jogador
func load_game(cfg: String, player: Player, inv: Inv) -> Dictionary:
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		var json_string = file.get_as_text()
		var error = jso.parse(json_string)
		# cfg = ConfigGeral.nome_player
		if error == OK:
			var data = jso.data
			if typeof(data) == TYPE_DICTIONARY:
				# print(data)
				cfg = data["player_name"]
				player.current_scene = data["scene"]
				player.position.x = data["position"]["x"]
				player.position.y = data["position"]["y"]
				player.current_mission = data["mission"]
				for i in range(min(inv.slots.size(), data["inventory"].size())):
					var item_data = data["inventory"][i]
					var item = get_item_by_name(item_data["item_name"])
					if item:
						inv.slots[i].item = item
						inv.slots[i].amount = item_data["amount"]
				file.close()
				print("Jogo carregado com sucesso!")
				return data
			else:
				print("'Data' são é um Dictionary")
				return data
		else:
			print("Erro ao carregar JSON: ", jso.error)
			return {}
	else:
		print("Arquivo de save não encontrado.")
		return {}

# Função auxiliar para encontrar o item pelo nome
func get_item_by_name(item_name: String) -> InvItem:
	for item in inv.slots:
		if item.item and item.item.nome == item_name:
			return item.item
	return null
