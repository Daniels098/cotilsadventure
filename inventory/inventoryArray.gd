class_name Inv extends Resource

signal update

var inventory_data : Dictionary = {}
@export var slots: Array[InvSlot]
var jso = JSON.new()
var all_items: Dictionary = {}

func populate_all_items():
	all_items["documento"] = preload("res://inventory/items/documento.tres")
	# all_items["shield"] = preload("res://inventory/items/documento.tres")
	# all_items["potion"] = preload("res://inventory/items/documento.tres")

func get_item_by_name(item_name: String) -> InvItem:
	if all_items.has(item_name):
		return all_items[item_name]
	return null

func insert(item: InvItem):
	var itemslots = slots.filter(func(slot): return slot.item == item)
	if !itemslots.is_empty():
		itemslots[0].amount += 1
	else:
		var emptyslots = slots.filter(func(slot): return slot.item == null)
		if !emptyslots.is_empty():
			emptyslots[0].item = item
			emptyslots[0].amount = 1
	update.emit()

func save_inventory(file_path: String):
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	if file:
		inventory_data.clear()
		for slot in slots:
			if slot.item != null:
				inventory_data[slot.item.nome] = slot.amount
		# var json_result = jso.stringify(inventory_data)
		file.store_string(jso.stringify(inventory_data))
		file.close()
		print("Inventário salvo com sucesso!")
	else:
		print("Inventário falhou ao salvar!")

func load_inventory(file_path: String):
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file:
		var json_data = file.get_as_text()
		var error = jso.parse(json_data)
		if error == OK:
			inventory_data = jso.data
			file.close()
			for slot in slots:
				slot.item = null
				slot.amount = 0
			for item_name in inventory_data.keys():
				var empty_slot = slots.find(func(s): return s.item == null)
				if empty_slot != -1:
					var slot = slots[empty_slot]
					var new_item = InvItem.new()  # Cria um novo item
					new_item.nome = item_name  # Define o nome do item
					slot.item = new_item
					slot.amount = inventory_data[item_name]
			update.emit()  # Emite o sinal de atualização
			print("Inventário carregado com sucesso!")
		else:
			print("Erro ao carregar JSON: ", error)
	else:
		print("Erro ao abrir o arquivo para carregar.")
