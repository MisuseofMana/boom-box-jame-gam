class_name AnimationComponent
extends Node

@export_subgroup("Nodes")
@export var sprite: AnimatedSprite2D

var animation_locked: bool = false
var can_shoot: bool = true
var can_attack: bool = true

signal just_attacked
signal just_shot

func _ready():
	sprite.animation_finished.connect(handle_animation_locking)

func handle_horizontal_flip(move_direction: float) -> void:
	if move_direction == 0:
		return
		
	sprite.flip_h = false if move_direction > 0 else true
	
func handle_move_animation(move_direction: float) -> void:
	handle_horizontal_flip(move_direction)

	if animation_locked:
		return

	if move_direction != 0: 
		sprite.play('walk')
	else:
		sprite.play('idle')

func handle_jump_animation(is_jumping: bool, is_falling: bool) -> void:
	if animation_locked:
		return
	
	if is_jumping:
		sprite.play("jump")
	elif is_falling:
		sprite.play("fall")

func handle_melee_animation(attack_pressed: bool) -> void:
	if attack_pressed and can_attack:
		animation_locked = true
		can_attack = false
		sprite.play('attack')
		just_attacked.emit()

func handle_shoot_animation(shoot_pressed: bool) -> void:
	if shoot_pressed and can_shoot:
		can_shoot = false
		animation_locked = true
		sprite.play('shoot')
		just_shot.emit()
		
func handle_breakdance_animation(breakdown_pressed: bool) -> void:
	if not breakdown_pressed:
		animation_locked = false
		can_shoot = true
		can_attack = true
	if breakdown_pressed and EventBus.current_flow >= 10:
		sprite.play('breakdown')
		animation_locked = true

func handle_animation_locking():
	const lockedAnimations: Array[StringName] = ['attack', 'shoot']
	if lockedAnimations.has(sprite.animation):
		animation_locked = false
	if sprite.animation == 'attack':
		can_attack = true
	if sprite.animation == 'shoot':
		can_shoot = true
