extends Node2D
class_name EmotionAnim

@onready var sprite = $Sprite2D
@onready var anim_player = $AnimationPlayer

const exclama_sprite = preload("res://assets/balao-esclama.png")
const feliz_sprite = preload("res://assets/balao-feliz.png")
const reticen_sprite = preload("res://assets/balao-tresP.png")
const interr_sprite = preload("res://assets/Balao-interoga.png")

func _play():
	anim_player.play("animate")

func play_exclama():
	sprite.texture = exclama_sprite
	_play()

func play_feliz():
	sprite.texture = feliz_sprite
	_play()

func play_reticen():
	sprite.texture = reticen_sprite
	_play()

func play_interr():
	sprite.texture = interr_sprite
	_play()

func destroy(time):
	await get_tree().create_timer(time).timeout
	queue_free()
