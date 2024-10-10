class_name Player extends CharacterBody2D

@export var speed: int = 80
@export var input_enabled: bool = true
@export var direction = Vector2.ZERO
var invi: Inv = preload("res://inventory/player_inv.tres")
@export var bolsa: bool = false
@onready var anim_player = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@export var nome: String = "Aluno"
var is_moving = false
var last_direction = Vector2.DOWN

func orient(input_direction: Vector2) -> void:
	if anim_player != null:
		if input_direction.x > 0:
			anim_player.play("WalkRight")
			sprite.flip_h = true
		elif input_direction.x < 0:
			anim_player.play("WalkLeft")
			sprite.flip_h = false
		elif input_direction.y > 0:
			anim_player.play("WalkDown")
		elif input_direction.y < 0:
			anim_player.play("WalkUp")

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
		is_moving = false
		if Input.is_action_pressed("move_right"):
			direction.x = 1
			is_moving = true
		elif Input.is_action_pressed("move_left"):
			direction.x = -1
			is_moving = true
		elif Input.is_action_pressed("move_down"):
			direction.y = 1
			is_moving = true
		elif Input.is_action_pressed("move_up"):
			direction.y = -1
			is_moving = true
		if direction != Vector2.ZERO:
			direction = direction.normalized()
			velocity = direction * speed
			move_and_slide()
			orient(direction)
			last_direction = direction
		else:
			#move(direction)
			idle_animation()

func move(direction: Vector2):
	if direction.y > 0:
		anim_player.play("WalkDown")
	elif direction.x > 0:
		anim_player.play("WalkRight")
	elif direction.x < 0:
		anim_player.play("WalkLeft")
	elif direction.y < 0:
		anim_player.play("WalkUp")
	sprite.flip_h = direction.x < 0

func idle_animation():
	if last_direction == Vector2.DOWN:
		anim_player.play("Down")
	elif last_direction == Vector2.UP:
		anim_player.play("Up")
	elif last_direction == Vector2.LEFT:
		anim_player.play("Left")
	elif last_direction == Vector2.RIGHT:
		anim_player.play("Right")
