extends Node2D

@onready var area_2d = $Area2D
@onready var sprite = $AnimatedSprite2D
@onready var label = $Label

func _input(event):
	if area_2d.has_overlapping_areas() and EventBus.flow_level >= 2:
		if event.is_action_pressed('interact'):
			EventBus.emit_next_level()


func _on_area_2d_area_entered(_area):
	if EventBus.flow_level >= 2:
		sprite.play('broadcast')
		label.show()

func _on_area_2d_area_exited(_area):
	sprite.play('default')
	label.hide()
