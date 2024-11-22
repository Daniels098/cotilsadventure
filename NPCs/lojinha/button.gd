extends Control

signal text_button(Texture)
signal button_pressed(int, Texture)

@export var view_text: Texture
@export var skin_text: Texture
@export var skin_id: String

func _ready():
	if $TextureButton:
		$TextureButton.texture_normal = view_text
		if not $TextureButton.is_connected("pressed", Callable(self, "_on_texture_button_pressed")):
			$TextureButton.pressed.connect(_on_texture_button_pressed)
	if not $Button.is_connected("pressed", Callable(self, "_on_button_pressed")):
		$Button.pressed.connect(_on_button_pressed)

func _process(delta):
	if not LojinhaManager.skins.has(skin_id):
		print("Erro: skin_id %s não encontrado no dicionário 'LojinhaManager.skins'" % skin_id)
	
	$Button.text = "USAR" if LojinhaManager.skins[skin_id] else "COMPRAR"
	$Selected.visible = LojinhaManager.current_skin == skin_text
	
	$Button.disabled = LojinhaManager.money < 4 and not LojinhaManager.skins[skin_id]

func _on_texture_button_pressed():
	emit_signal("text_button", skin_text)

func _on_button_pressed():
	emit_signal("button_pressed", skin_id, skin_text)
