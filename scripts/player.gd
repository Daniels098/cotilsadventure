class_name Player extends CharacterBody2D

@export var speed: int = 75
@export var input_enabled: bool = true
@export var direction = Vector2.ZERO
var invi: Inv = preload("res://inventory/player_inv.tres")
@export var bolsa: bool = false
@onready var anim_player = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@export var nome: String

func orient(input_direction:Vector2) -> void:
	"""if input_direction.x > 0:
		anim_player.play("Right")
	elif input_direction.x < 0:
		anim_player.play("Left")
	elif input_direction.y > 0:
		anim_player.play("Down")
	elif input_direction.y < 0:
		anim_player.play("Up")"""
	#sprite.flip_h = input_direction.x < 0
	pass

# if Input.is_action_just_pressed("interact"):

func collect(item):
	invi.insert(item)

func disable():
	input_enabled = false
	visible = false

func enable():
	input_enabled = true
	visible = true
	anim_player.play("Down")

func entered_door():
	emit_signal("player_entered_door")

func _physics_process(delta):
	if input_enabled:
		direction = Vector2.ZERO
		if Input.is_action_pressed("move_right"): #get_action_strength
			direction.x = 1
		elif Input.is_action_pressed("move_left"):
			direction.x = -1
		elif Input.is_action_pressed("move_down"):
			direction.y = 1
		elif Input.is_action_pressed("move_up"):
			direction.y = -1
		if direction != Vector2.ZERO:
			direction = direction.normalized()
			velocity = direction * speed
			move_and_slide()
			move(delta)

func move(delta):
	if Input.is_anything_pressed() and Engine.time_scale == 1:
			if direction.y > 0:
				anim_player.play("WalkDown")
			elif direction.x > 0:
				anim_player.play("WalkRight")
			elif direction.x < 0:
				anim_player.play("WalkLeft")
			elif direction.y < 0:
				anim_player.play("WalkUp")
