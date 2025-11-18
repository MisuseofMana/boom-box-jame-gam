extends AnimatedSprite2D

signal attack_finished

@onready var collision_shape_2d = $Area2D/CollisionShape2D
@onready var sfx = $AudioStreamPlayer2D

var source_of_attack: CharacterBody2D

func setup_sprite(shouldBeFlipped: bool, source: CharacterBody2D):
	source_of_attack = source
	if shouldBeFlipped:
		flip_h = true
		position.x = -16
	else:
		position.x = 16
	show()
	sfx.play()
	play('default')

func _on_animation_finished():
		attack_finished.emit()
		queue_free()
