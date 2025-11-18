class_name TutorialMachine
extends Node2D

@export_multiline var hint_text: String

@onready var label = $PanelContainer/Label
@onready var sprite = $AnimatedSprite2D
@onready var anims = $AnimationPlayer

var is_displaying: bool = false

func _ready():
	label.text = hint_text

func _on_activator_area_area_entered(_area):
	is_displaying = true
	sprite.play('activate')
	anims.play('show_hint')

func _on_activator_area_area_exited(_area):
	is_displaying = false
	sprite.play_backwards('activate')
	anims.play_backwards('show_hint')

func _on_animated_sprite_2d_animation_finished():
	if sprite.animation == 'activate':
		if is_displaying == true:
			sprite.play('scroll')
