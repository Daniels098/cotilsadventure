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
	# print("Itens no dicionário: ", all_items.keys()) 

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
