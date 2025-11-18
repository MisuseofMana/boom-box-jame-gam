extends AnimatedSprite2D
class_name Projectile

@export_subgroup('Settings')
@export var sprite_sheet : SpriteFrames
@export var speed : int = 125
@export var projectile_lifetime : float = 0.2
@export var verticalMovement: bool = false

@onready var timer = $Timer
@onready var shoot_sound = $Shoot
@onready var hit_sound = $HitSound

var hit_something : bool = false

func _ready():
	timer.wait_time = projectile_lifetime
	timer.start()

func setup_sprite(shouldBeFlipped: bool, parentGlobPos: Vector2, custom_frames: SpriteFrames):
	sprite_frames = custom_frames
	var customOffset: int = 10
	if shouldBeFlipped:
		customOffset = customOffset * -1
		speed = speed * -1
	if verticalMovement:
		global_position = parentGlobPos + Vector2(0, customOffset)
	else:
		global_position = parentGlobPos + Vector2(customOffset, -10)
	shoot_sound.play()
	
func _physics_process(delta):
	if hit_something:
		return
		
	var newPos
	if verticalMovement:
		newPos = transform.y * speed * delta
	else:
		newPos = transform.x * speed * delta
	position += newPos

func explode() -> void:
	hit_something = true
	play('on_hit')
	hit_sound.play()

func _on_timer_timeout():
	play('fade')

func _on_animated_sprite_2d_animation_finished():
	if animation == 'fade':
		queue_free()

func _on_area_2d_body_entered(_body):
	explode()

func _on_hit_sound_finished():
	queue_free()
