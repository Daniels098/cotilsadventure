extends CanvasLayer

@onready var time = $Timer
@onready var main = $"."
@onready var sprite := $Control/Panel/MarginContainer/VBoxContainer/HBoxContainer/Control/Node2D/Sprite2D
@onready var money := $Control/Panel/MarginContainer/VBoxContainer/Control/money
@onready var grid_container = $Control/Panel/MarginContainer/VBoxContainer/HBoxContainer/GridContainer

func _ready():
	sprite.texture = LojinhaManager.get_current_skin_texture()
	time.start(0.5)
	# connect_signal_buttons()

func _process(delta):
	money.text = "%s" % LojinhaManager.money  # Atualizar moedas no display

func _on_voltar_pressed():
	# Oculta a interface da lojinha
	main.visible = false
	if ConfigGeral.is_canhoto:
		$"../ButtonLayerCanhoto".visible = true
	else:
		$"../ButtonLayerDestro".visible = true
	# Salva as mudanças ao sair da loja
	LojinhaManager.save_skins()

func _on_timer_timeout():
	# Animação para Sprite
	if sprite.frame == 8:
		sprite.frame = 0
	else:
		sprite.frame += 1

func _on_button_1_button_pressed(int):
	LojinhaManager.purchase_skin(1)
	sprite.texture = LojinhaManager.get_current_skin_texture()

func _on_button_1_text_button(int):
	sprite.texture = LojinhaManager.skins_texts[0]

func _on_button_2_button_pressed(int):
	LojinhaManager.purchase_skin(2)
	sprite.texture = LojinhaManager.get_current_skin_texture()

func _on_button_2_text_button(int):
	sprite.texture = LojinhaManager.skins_texts[2]

func _on_button_3_button_pressed(int):
	LojinhaManager.purchase_skin(3)
	sprite.texture = LojinhaManager.get_current_skin_texture()

func _on_button_3_text_button(int):
	sprite.texture = LojinhaManager.skins_texts[3]

func _on_button_4_button_pressed(int):
	LojinhaManager.purchase_skin(4)
	sprite.texture = LojinhaManager.get_current_skin_texture()

func _on_button_4_text_button(int):
	sprite.texture = LojinhaManager.skins_texts[3]

func _on_button_5_button_pressed(int):
	LojinhaManager.purchase_skin(5)
	sprite.texture = LojinhaManager.get_current_skin_texture()

func _on_button_5_text_button(int):
	sprite.texture = LojinhaManager.skins_texts[4]

func _on_button_6_button_pressed(int):
	LojinhaManager.purchase_skin(6)
	sprite.texture = LojinhaManager.get_current_skin_texture()

func _on_button_6_text_button(int):
	sprite.texture = LojinhaManager.skins_texts[5]

func _on_button_7_button_pressed(int):
	LojinhaManager.purchase_skin(7)
	sprite.texture = LojinhaManager.get_current_skin_texture()

func _on_button_7_text_button(int):
	sprite.texture = LojinhaManager.skins_texts[6]
