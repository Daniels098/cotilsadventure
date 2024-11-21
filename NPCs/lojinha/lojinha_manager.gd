extends Node

var money: int = 8
var current_skin := load("res://assets/perso-02.png")
var skins := {
	0: true,
	1: false,
	2: false,
	3: false,
	4: false,
	5: false,
	6: false,
	7: false,
}

func save_skins():
	ManagerSave.save_by_manager()
