extends Node2D

@onready var anim_titles = $AnimationPlayer
@onready var godot = $godot_engine
@onready var nomes = $feito_por
@onready var img = $Sprite2D

func _ready():
	ConfigGeral.center_window()
	anim_letters()
	terminar_inicio()

func anim_letters() -> void:
	godot.visible = true
	img.visible = true
	anim_titles.play("fade_in_godot")
	await anim_titles.animation_finished
	anim_titles.play("fade_out_godot")
	await anim_titles.animation_finished
	img.visible = false
	godot.visible = false
	nomes.visible = true
	anim_titles.play("fade_in_nomes")
	await anim_titles.animation_finished
	anim_titles.play("fade_out_nomes")
	await anim_titles.animation_finished
	nomes.visible = false

func terminar_inicio() -> void:
	await get_tree().create_timer(7).timeout
	# ConfigGeral.center_window()
	SceneManager.load_new_scene("res://scenes/menu/menu.tscn")
