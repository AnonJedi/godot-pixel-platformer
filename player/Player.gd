extends KinematicBody2D

export(int) var MAX_SPEED = 80
export(int) var ACCELERATION = 20
export(int) var FRICTION = 20
export(int) var JUMP_HEIGHT = 200
export(int) var MIN_JUMP_HEIGHT = 30
export(int) var JUMP_ACCELERATION_POINT = 10
export(int) var GRAVITY_ENHANCEMENT = 4
export(int) var GRAVITY = 10

var velocity = Vector2.ZERO

onready var animation_sprite = $AnimatedSprite


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
			velocity.y = -JUMP_HEIGHT
	else:
		animation_sprite.play("Jump")
		if Input.is_action_just_released("ui_up") and velocity.y <= -MIN_JUMP_HEIGHT:
			velocity.y = -MIN_JUMP_HEIGHT

		if velocity.y > JUMP_ACCELERATION_POINT:
			velocity.y += GRAVITY_ENHANCEMENT

	velocity = move_and_slide(velocity, Vector2.UP)


func apply_gravity():
	velocity.y += GRAVITY


func apply_friction():
	velocity.x = move_toward(velocity.x, 0, FRICTION)


func apply_acceleretion(direction: int):
	velocity.x = move_toward(velocity.x, MAX_SPEED * direction, ACCELERATION)
