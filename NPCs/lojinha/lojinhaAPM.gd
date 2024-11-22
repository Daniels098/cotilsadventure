extends CanvasLayer

@onready var time = $Timer
@onready var main = $"."
@onready var sprite := $Control/Panel/MarginContainer/VBoxContainer/HBoxContainer/Control/Node2D/Sprite2D
@onready var money := $Control/Panel/MarginContainer/VBoxContainer/Control/money

func _ready():
	sprite.texture = LojinhaManager.current_skin
	time.start(0.5)
	connect_signal_buttons()

func _process(delta):
	money.text = "Moedas: %s" % LojinhaManager.money # Atualizar moedas no display

func connect_signal_buttons():
	var grid_container = $Control/Panel/MarginContainer/VBoxContainer/HBoxContainer/GridContainer
	for i in range(1, 8):  # Agora 7 botões
		var button = grid_container.get_node("Button" + str(i))
		if button:
			# Conectar o sinal "button_pressed" de cada botão
			button.connect("button_pressed", Callable(self, "purchase_skin"))
			button.connect("text_button", Callable(self, "change_skin"))

func _on_voltar_pressed():
	main.visible = false

func change_skin(skin_text: Texture) -> void:
	sprite.texture = skin_text

func purchase_skin(skin_id: String, skin_text: Texture) -> void:
	if not LojinhaManager.skins[skin_id]:
		LojinhaManager.skins[skin_id] = true
		LojinhaManager.money -= 2
		money.text = "Moedas: %s" % LojinhaManager.money
		LojinhaManager.save_skins()
	else:
		LojinhaManager.current_skin = skin_text
		sprite.texture = LojinhaManager.current_skin

func _on_timer_timeout(): # Depois pra deixar mais bonitinho fazer na mão cada frame
	if sprite.frame == 8:
		sprite.frame = 0
	else:
		sprite.frame += 1
