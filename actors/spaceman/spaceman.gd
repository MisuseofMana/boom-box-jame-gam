extends CharacterBody2D
class_name SpaceMan

@export_subgroup("Nodes")
@export var gravity_component: GravityComponent
@export var movement_component: MovementComponent
@export var animation_component: AnimationComponent

@export_subgroup("Behavior")
@export var chase_duration: float = 5.0
@export var idle_duration: float = 0.4
@export var hit_points: int = 3
@export var vision_distance: float = 40.0
@onready var dieAnimation = $die
@onready var hurt_sfx = $AudioStreamPlayer2D

@onready var chase_timer = $ChaseTimer
@onready var vision = $Vision
@onready var idle_timer = $IdleTimer
@onready var spaceman_sprite = $SpacemanSprite
@onready var melee_range = $MeleeRange
@onready var attack_timer = $AttackTimer
@onready var collider = $Collider
@onready var hit_detection = $HitDetection

signal died

const ATTACK_ANIMATION = preload("uid://dypc6238h1aak")
const PROJECTILE = preload("uid://dpi0csq2b3hfc")
const ENEMY_PROJECTILE = preload("uid://c3gbcacc5ltcv")

var target: CharacterBody2D

var can_attack: bool = true
var attacking: bool = false

var chosen_direction: float = 0.0
var home_position: Vector2

enum State {
	IDLE,
	ATTACKING,
	WALKING,
	RETURNING
}

func _ready():
	idle_timer.wait_time = idle_duration
	chase_timer.wait_time = chase_duration
	home_position = global_position

func _physics_process(delta) -> void:
	if hit_points <= 0:
		return 
		
	if target:
		if target.global_position.x > global_position.x and not attacking:
			chosen_direction = 1.0
		if target.global_position.x < global_position.x and not attacking:
			chosen_direction = -1.0
		if attacking:
			chosen_direction = 0.0
	else:
		go_home()
	
	if chosen_direction <= 0:
		vision.target_position.x = -vision_distance
	else:
		vision.target_position.x = vision_distance
		
	if vision.is_colliding():
		if not target: 
			var coll = vision.get_collider()
			if coll:
				if coll is CharacterBody2D:
					target = coll
		chase_timer.start()
			
	gravity_component.handle_gravity(self, delta)
	movement_component.handle_horizontal_movement(self, chosen_direction)
	animation_component.handle_move_animation(chosen_direction)
	
	if target:
		if melee_range.has_overlapping_areas() and can_attack:
			animation_component.handle_melee_animation(true)
			can_attack = false
			attacking = true
			idle_timer.start()
	
	move_and_slide()
	
func spawn_melee():
	var attk = ATTACK_ANIMATION.instantiate()
	add_child(attk)
	attk.setup_sprite(spaceman_sprite.flip_h, self)
	attack_timer.start()
	
func spawn_shot():
	var shot: Projectile = PROJECTILE.instantiate()
	shot.global_position = global_position
	get_tree().root.add_child(shot)
	shot.setup_sprite(spaceman_sprite.flip_h, global_position, ENEMY_PROJECTILE)
	attack_timer.start()

func go_home():
	if home_position.x > global_position.x:
		chosen_direction = 1.0
	if home_position.x < global_position.x:
		chosen_direction = -1.0
	if abs(home_position.x - global_position.x) <= 5:
		chosen_direction = 0.0

func _on_chase_timer_timeout():
	target = null

func _on_attack_timer_timeout():
	can_attack = true

func _on_idle_timer_timeout():
	attacking = false

func _on_hit_detection_area_entered(_area):
	hurt_sfx.play()
	hit_points -= 1
	target = get_tree().get_first_node_in_group('player')
	if hit_points == 0:
		die()

func die():
	spaceman_sprite.queue_free()
	vision.queue_free()
	melee_range.queue_free()
	collider.queue_free()
	hit_detection.queue_free()
	dieAnimation.show()
	dieAnimation.play('default')
	
func spawn_cassette():
	const CASETTE = preload("uid://dm0iig8hhwstb")
	var drop : Casette = CASETTE.instantiate()
	drop.one_use = true
	drop.global_position = global_position + Vector2(0, -6)
	get_tree().get_root().add_child(drop)
	queue_free()

func _on_die_animation_finished():
	died.emit()
	call_deferred('spawn_cassette')
