extends KinematicBody2D
class_name Player

export(Resource) var movementConfig
export(int) var HEALTH_CAPACITY = 3

var velocity = Vector2.ZERO
onready var hit_points = HEALTH_CAPACITY

onready var animation_sprite = $AnimatedSprite


func _ready():
	movementConfig = movementConfig as PlayerMovementConfig


func _physics_process(_delta):
	apply_gravity()

	var input = Vector2.ZERO
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")

	if input.x == 0:
		apply_friction()
		if velocity.x == 0:
			animation_sprite.play("Idle")
	else:
		apply_acceleretion(input.x)

		animation_sprite.flip_h = input.x > 0
		if animation_sprite.animation == "Jump":
			animation_sprite.animation = "Run"
			animation_sprite.frame = 1
		animation_sprite.play("Run")

	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			velocity.y = -movementConfig.JUMP_HEIGHT
	else:
		animation_sprite.play("Jump")
		if Input.is_action_just_released("ui_up") and velocity.y <= -movementConfig.MIN_JUMP_HEIGHT:
			velocity.y = -movementConfig.MIN_JUMP_HEIGHT

		if velocity.y > movementConfig.JUMP_ACCELERATION_POINT:
			velocity.y += movementConfig.GRAVITY_ENHANCEMENT

	velocity = move_and_slide(velocity, Vector2.UP)


func apply_gravity():
	velocity.y = min(velocity.y + movementConfig.GRAVITY, movementConfig.MAX_GRAVITY)


func apply_friction():
	velocity.x = move_toward(velocity.x, 0, movementConfig.FRICTION)


func apply_acceleretion(direction: int):
	velocity.x = move_toward(velocity.x, movementConfig.MAX_SPEED * direction, movementConfig.ACCELERATION)


func handle_damage(damage: int) -> void:
	hit_points = clamp(hit_points - damage, 0, HEALTH_CAPACITY)
