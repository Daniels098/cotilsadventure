extends Control

signal text_button(Texture)
signal button_pressed(int)

@export var view_text: Texture
@export var skin_text: Texture
@export var skin_id: int

func _ready():
	# Atualiza a textura do botão e conecta os sinais
	if $TextureButton:
		$TextureButton.texture_normal = view_text
		# Conectar os sinais corretamente
		if not $TextureButton.is_connected("pressed", Callable(self, "_on_texture_button_pressed")):
			$TextureButton.pressed.connect(_on_texture_button_pressed)
		if not $Button.is_connected("pressed", Callable(self, "_on_button_pressed")):
			$Button.pressed.connect(_on_button_pressed)

func _process(delta):
	# Atualiza o texto do botão
	if LojinhaManager.skins[skin_id]:
		$Button.text = "USAR"  # Se a skin foi comprada, mostra "USAR"
	else:
		$Button.text = "COMPRAR"  # Se não comprada, mostra "COMPRAR"

	# Se o jogador não tiver moedas suficientes ou a skin não for comprada, desabilita o botão
	$Button.disabled = (LojinhaManager.money < 3 and not LojinhaManager.skins[skin_id])

func _on_texture_button_pressed():
	emit_signal("text_button", skin_text)

func _on_button_pressed():
	if LojinhaManager.skins[skin_id]:
		# Se a skin foi comprada, usa a skin
		LojinhaManager.current_skin_id = skin_id
		LojinhaManager.current_skin = skin_text
		print("Skin %s usada!" % skin_id)
	else:
		# Se a skin não foi comprada, realiza a compra
		LojinhaManager.purchase_skin(skin_id)
		print("Skin %s comprada!" % skin_id)
