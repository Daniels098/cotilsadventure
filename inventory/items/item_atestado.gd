extends Node2D

# Sinal para avisar o ItemManager que o item foi coletado
signal item_collected(item_id)

@export var item: InvItem
@export var dialogue_resource: DialogueResource
@export var dialogue_start: String
const baloon = preload("res://dialogue/balloon.tscn")
var item_id = "atestado"
var invi: Inv

func _enter_tree():
	if !ItemManager.is_item_collected(item_id) or !ItemManager.check_item_in_inventory(item_id):
		connect("item_collected", Callable(ItemManager, "register_item"))

func _process(delta):
	if ItemManager.is_item_collected(item_id) or ItemManager.check_item_in_inventory(item_id):
		queue_free() # Remove o item se o jogador já o possui

func _on_area_2d_body_entered(player: Player):
	if QuestsAt.is_quest_active("matricula"): #trocar a missão
		if not player is Player:
			return
		var collected = item
		player.collect(collected)
		emit_signal("item_collected", item_id) # Emitindo o signal para o ItemManager
		action()
		player.anim_exclama()
		queue_free()
	else:
		action()

func action() -> void:
	var ballon: Node = baloon.instantiate()
	get_tree().current_scene.add_child(ballon)
	ballon.start(dialogue_resource, dialogue_start)
	
