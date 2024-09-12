extends Area2D

@onready var sprite = $Sprite2D2
@onready var anim_player = $AnimationPlayer

func _ready():
	sprite.visible = true

func close_door():
	anim_player.play("closing")

func _on_body_entered(body: Node2D) -> void:
	anim_player.play("opening")
