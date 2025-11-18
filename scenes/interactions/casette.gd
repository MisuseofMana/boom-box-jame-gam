extends Node2D
class_name Casette

@onready var pickup = $pickup
@onready var animated_sprite_2d = $Node2D/AnimatedSprite2D
@onready var timer = $Timer
@export var one_use : bool = false
@onready var collision_shape_2d = $Node2D/Area2D/CollisionShape2D

func _on_timer_timeout():
	animated_sprite_2d.show()
	collision_shape_2d.disabled = false

func _on_area_2d_area_entered(_area):
	animated_sprite_2d.hide()
	pickup.play()
	EventBus.increase_flow()
	call_deferred("disable_collision_shape")
	if not one_use:
		timer.start()

func disable_collision_shape():
	collision_shape_2d.disabled = true
	
func _on_pickup_finished():
	if one_use:
		queue_free()
