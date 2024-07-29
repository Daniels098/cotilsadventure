extends Area2D

@onready var sprite = $Sprite2D2
@onready var anim_player = $AnimationPlayer


func _ready():
	sprite.visible = true
	var player = find_parent("CurrentScene").get_children().back().get_node("Player")
	player.connect("player_entering_door", enter_door)
	player.connect("player_entered_door", close_door)

func enter_door():
	anim_player.play("opening")

func close_door():
	anim_player.play("closing")
