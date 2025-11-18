extends CharacterBody2D
class_name Player

@export_subgroup("Nodes")
@export var gravity_component: GravityComponent
@export var input_component: InputComponent
@export var movement_component: MovementComponent
@export var animation_component: AnimationComponent
@export var adv_jump_component: AdvancedJumpComponent

@onready var player_sprite = $PlayerSprite

const ATTACK_ANIMATION = preload("uid://dypc6238h1aak")
const PROJECTILE = preload("uid://dpi0csq2b3hfc")
const PLAYER_PROJECTILE = preload("uid://opgdkqai6txn")

func _physics_process(delta) -> void:
	gravity_component.handle_gravity(self, delta)
	movement_component.handle_horizontal_movement(self, input_component.input_horizontal)
	adv_jump_component.handle_jump(self, input_component.get_jump_input(), input_component.get_jump_input_released())
	animation_component.handle_move_animation(input_component.input_horizontal)
	animation_component.handle_jump_animation(adv_jump_component.is_going_up, gravity_component.is_falling)
	animation_component.handle_melee_animation(input_component.get_attack_input())
	animation_component.handle_shoot_animation(input_component.get_shoot_input())
	animation_component.handle_breakdance_animation(input_component.get_breakdown_input())
	
	move_and_slide()

func spawn_melee():
	var attk = ATTACK_ANIMATION.instantiate()
	add_child(attk)
	attk.setup_sprite(player_sprite.flip_h, self)
	
func spawn_shot():
	var shot: Projectile = PROJECTILE.instantiate()
	shot.global_position = global_position
	get_tree().root.add_child(shot)
	shot.setup_sprite(player_sprite.flip_h, global_position, PLAYER_PROJECTILE)

func _on_hit_detection_area_entered(_area):
	EventBus.decrease_flow()
