extends CanvasLayer

@onready var inv: Inv = preload("res://inventory/player_inv.tres")
@onready var slots: Array = $Control/NinePatchRect/GridContainer.get_children()
var invi = Inv.new()
var is_open = false

func _ready():
	inv.update.connect(update_slots)
	update_slots()
	close()
	
func update_slots():
	for i in range(min(inv.slots.size(), slots.size())):
		slots[i].update(inv.slots[i])

func _process(_delta):
	update_slots()
	if Input.is_action_just_pressed("inventory"):
		if is_open:
			close()
		else:
			
			open()

func open():
	visible = true
	is_open = true
	
func close():
	visible = false
	is_open = false
