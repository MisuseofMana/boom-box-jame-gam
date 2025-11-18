extends PathFollow2D

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var sfx = $AudioStreamPlayer2D
@onready var collision_shape_2d = $Area2D/CollisionShape2D

func _on_timer_timeout():
	progress_ratio += 0.01

func _on_spawn_timer_timeout():
	if animated_sprite_2d.visible == false:
		animated_sprite_2d.show()
		animated_sprite_2d.play('default')
		call_deferred('enable_collision')

func _on_area_2d_area_entered(area):
	if area.owner == self:
		return
	animated_sprite_2d.play('explode')
	call_deferred('disable_collision')
	
func _on_animated_sprite_2d_animation_finished():
	if animated_sprite_2d.animation == 'explode':
		sfx.play()
		animated_sprite_2d.hide()
		EventBus.increase_flow()

func disable_collision():
	collision_shape_2d.disabled = true
	
func enable_collision():
	collision_shape_2d.disabled = false
