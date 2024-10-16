extends Node
class_name SaveGame
# Caminho para o arquivo de save
const SAVE_PATH = "user://save_game.json"
var data = {}
# var inv := Inv.new()
var jso := JSON.new()

# Função para salvar os dados do jogador
func save_game(player: Player, invi: Inv, scene_name: String, mission: String) -> void:
	var save_data = {
		"position": {
			"x": player.position.x,
			"y": player.position.y
		},
		"scene": scene_name,
		"mission": mission, # ID da missão possivelmente
		"inventory": []
	}
	# Salvar inventário
	if invi.slots.size() > 0:
		for slot in invi.slots:
			if slot.item:
				save_data["inventory"].append({
				"item_name": slot.item.nome,
				"amount": slot.amount
				})
	
	# Escrever o arquivo de save
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(jso.stringify(save_data, "\t"))
		file.close()
		print("Jogo salvo com sucesso!")
	else:
		print("Falha ao salvar o jogo!")

# Função para carregar os dados do jogador
func load_game(name: String, player: Player, invi: Inv) -> Dictionary:
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		var json_string = file.get_as_text()
		var error = jso.parse(json_string)
		if error == OK:
			var data = jso.data
			if typeof(data) == TYPE_DICTIONARY:
				player.current_scene = data["scene"]
				player.position.x = data["position"]["x"]
				player.position.y = data["position"]["y"]
				player.current_mission = data["mission"]
				var saved_inventory = data["inventory"]
				# print("INVENTARIO ABAIXO")
				# print(saved_inventory)
				invi.populate_all_items()
				for slot in invi.slots:
					slot.item = null
					slot.amount = 0
				for i in range(min(saved_inventory.size(), invi.slots.size())):
					var item_data = data["inventory"][i]
					var item = invi.get_item_by_name(item_data["item_name"])
					if item:
						invi.slots[i].item = item
						invi.slots[i].amount = item_data["amount"]
				file.close()
				print("Jogo carregado com sucesso!")
				return data
			else:
				print("'Data' são é um Dictionary, dados inválidos no arquivo de save")
				return {}
		else:
			print("Erro ao carregar JSON: ", jso.get_error_message())
			return {}
	else:
		print("Arquivo de save não encontrado.")
		return {}
