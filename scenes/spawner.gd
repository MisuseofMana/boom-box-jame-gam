extends Node2D

const SPACEMAN = preload("uid://ckoa8c0tqp68y")
@onready var sprite_2d = $Sprite2D

@export var modulateColor : Color = Color(1.0, 1.0, 1.0, 1.0)

func _ready():
	sprite_2d.self_modulate = modulateColor
	spawn_guy()

func spawn_guy():
	var guy : SpaceMan = SPACEMAN.instantiate()
	add_child(guy)
	var random = randi_range(0, 100)
	if random > 50:
		guy.spaceman_sprite.flip_h = true
	guy.died.connect(cooldown_start)
	
func cooldown_start():
	get_tree().create_timer(15).timeout.connect(spawn_guy)

	
