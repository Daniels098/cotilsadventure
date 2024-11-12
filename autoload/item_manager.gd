extends Node

signal remove_item_signal(item_id: String)

var collected_items = []

# Função para registrar um item como coletado
func register_item(item_id):
	if item_id not in collected_items:
		collected_items.append(item_id)

# Função para verificar se um item já foi coletado
func is_item_collected(item_id):
	return item_id in collected_items

func remove_item(item_id: String):
	print("função sendo chamada")
	emit_signal("remove_item_signal", item_id)
