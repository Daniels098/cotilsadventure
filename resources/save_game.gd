extends Node
class_name SaveGame

const SAVE_PATH = "user://save_game.json"
var data = {}
var jso := JSON.new()
var invi:= Inv.new()

# Função para salvar os dados do jogador localmente e na API
func save_game(nome: String, player: Player, user: String, invi: Inv, scene_name: String, mission: String) -> void:
	var device = OS.get_name()
	var save_data = {
		"nome": nome,
		"scene": scene_name,
		"username": user,
		"mission": mission,
		"device": device,
		"inventory": [],
		"position": {
			"x": player.position.x,
			"y": player.position.y
		},
		"array_missions": [],
	}
	# Preencher o inventário
	if invi != null and invi.slots.size() > 0:
		for slot in invi.slots:
			if slot.item:
				save_data["inventory"].append({
					"amount": slot.amount,
					"item_name": slot.item.nome
				})
		print("Invi NÃO é nulo e possui slots.")
	else:
		print("Invi é nulo ou não possui slots.")
	
	# Salvar localmente no arquivo JSON
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(jso.stringify(save_data, "\t"))
		file.close()
		HttpsRequest.send_data_game(save_data)
		print("Jogo salvo na nuvem com sucesso!")
	else:
		print("Falha ao salvar o jogo localmente!")

# Função para carregar os dados do jogador
func load_game(name: String, player: Player, invi: Inv, missions: QuestArray) -> Dictionary:
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
				player.device = OS.get_name()
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
				print("'Data' não é um Dictionary, dados inválidos no arquivo de save.")
				return {}
		else:
			print("Erro ao carregar JSON: ", jso.get_error_message())
			return {}
	else:
		print("Arquivo de save local não encontrado. Tentando carregar da nuvem...")
		print(ConfigGeral.data_cloud)
		var cloud_data = HttpsRequest.load_cloud_save(ConfigGeral.data_cloud["username"])
		if cloud_data:
			print(cloud_data)
			# Processa o cloud_data da mesma forma que o save local
			name = cloud_data.get("player", name) if cloud_data.has("player") and cloud_data["player"] != null else name
			if cloud_data.has("scene") and cloud_data["scene"] != null:
				player.current_scene = cloud_data["scene"]
			if cloud_data.has("mission") and cloud_data["mission"] != null:
				player.current_mission = cloud_data["mission"]
			player.device = OS.get_name()
			
			var position_data = cloud_data.get("position", null)
			if position_data and (position_data.get("x", 0) != 0 or position_data.get("y", 0) != 0):
				player.position.x = position_data["x"]
				player.position.y = position_data["y"]
			var saved_inventory = cloud_data.get("inventory", [])
			invi.populate_all_items()
			for slot in invi.slots:
				slot.item = null
				slot.amount = 0
			
			if saved_inventory.size() > 0:
				for i in range(min(saved_inventory.size(), invi.slots.size())):
					var item_data = saved_inventory[i]
					var item = invi.get_item_by_name(item_data.get("item_name", ""))
					if item:
						invi.slots[i].item = item
						invi.slots[i].amount = item_data.get("amount", 0)

			print("Jogo carregado com sucesso da nuvem!")
			return cloud_data
		else:
			print("Erro: Não foi possível carregar o save da nuvem.")
			return {}
