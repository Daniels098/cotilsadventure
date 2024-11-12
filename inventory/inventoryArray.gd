class_name Inv extends Resource

signal update

var inventory_data : Dictionary = {}
@export var slots: Array[InvSlot]
var jso = JSON.new()
var all_items: Dictionary = {}

func _ready():
	ItemManager.connect("remove_item_signal", Callable(self, "_on_remove_item_signal"))
	print("Conectado ao sinal")

func _on_remove_item_signal(item_id: String):
	print("signal chegou com item_id: ", item_id)
	remove_item(item_id)

func populate_all_items():
	all_items["documento"] = preload("res://inventory/items/documento.tres")
	# all_items["documentos_matri"] = preload("res://inventory/items/documento.tres")
	# all_items["potion"] = preload("res://inventory/items/documento.tres")
	# print("Itens no dicionário: ", all_items.keys()) 

## Da pra usar
func get_item_by_name(item_name: String) -> InvItem: 
	if all_items.has(item_name):
		var item_resource = all_items[item_name]
		if item_resource is InvItem:
			return item_resource
		else:
			print("Erro: O recurso encontrado não é do tipo InvItem.")
	else:
		print("Item '", item_name, "' não encontrado no dicionário.")
	return null

func item_search(item_name: String) -> bool:
	if all_items.has(item_name):
		return true
	return false

# Para verificar se o item existe no inventário do player pelo nome
func check_item_in_slots(item_name: String) -> bool:
	for slot in slots:
		if slot.item != null and slot.item is InvItem:
			if slot.item.nome == item_name:
				return true
	return false

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

func remove_item(item_name: String, amount: int = 1) -> bool:
	# Procurar o item no inventário
	var item = get_item_by_name(item_name)
	if item == null:
		return false  # O item não foi encontrado no inventário

	# Encontrar o slot que contém esse item
	for slot in slots:
		if slot.item == item:
			# Se a quantidade for maior que 1, diminui a quantidade
			if slot.amount > amount:
				slot.amount -= amount
			else:
				# Se a quantidade for 1 ou menor, remove o item do slot
				slot.item = null
				slot.amount = 0
			update.emit()  # Emitir sinal de atualização
			return true
	return false  # Item não encontrado
