extends CanvasLayer

@onready var time = $Timer
@onready var main = $"."
@onready var sprite := $Control/Panel/MarginContainer/VBoxContainer/HBoxContainer/Control/Node2D/Sprite2D
@onready var money := $Control/Panel/MarginContainer/VBoxContainer/Control/money
@onready var grid_container = $Control/Panel/MarginContainer/VBoxContainer/HBoxContainer/GridContainer

func _ready():
	sprite.texture = LojinhaManager.get_current_skin_texture()
	time.start(0.5)
	connect_signal_buttons()

func _process(delta):
	money.text = "Moedas: %s" % LojinhaManager.money  # Atualizar moedas no display

func connect_signal_buttons():
	var grid_container = $Control/Panel/MarginContainer/VBoxContainer/HBoxContainer/GridContainer
	for i in range(1, 8):  # Agora são 7 botões
		var button = grid_container.get_node("Button" + str(i))
		if button:
			# Conectar o sinal "button_pressed" e passar o índice do botão
			if not button.is_connected("button_pressed", Callable(self, "on_button_pressed")):
				button.connect("button_pressed", Callable(self, "on_button_pressed"), i)
			
			# Conectar o sinal "text_button" e passar o índice do botão
			if not button.is_connected("text_button", Callable(self, "on_text_button")):
				button.connect("text_button", Callable(self, "on_text_button"), i)

func _on_voltar_pressed():
	# Oculta a interface da lojinha
	main.visible = false
	# Salva as mudanças ao sair da loja
	LojinhaManager.save_skins()

func on_button_pressed(skin_id: int) -> void:
	LojinhaManager.purchase_skin(skin_id)
	sprite.texture = LojinhaManager.get_current_skin_texture()  # Atualiza a textura selecionada

func on_text_button(skin_id: int) -> void:
	sprite.texture = LojinhaManager.skins_texts[skin_id]

func _on_timer_timeout():
	# Animação para Sprite
	if sprite.frame == 8:
		sprite.frame = 0
	else:
		sprite.frame += 1
