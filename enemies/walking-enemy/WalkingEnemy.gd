extends KinematicBody2D

enum MoveDirections {
	LEFT = -1,
	RIGHT = 1,
}

export(MoveDirections) var direction = MoveDirections.LEFT
export(int) var speed = 30
export(int) var gravity = 10
export(int) var max_gravity = 200

var velocity := Vector2.RIGHT

onready var animated_sprite = $AnimatedSprite
onready var edge_ray_cast = $EdgeRayCast


func _physics_process(_delta):
	apply_gravity()
	
	if is_on_floor():
		velocity.y = gravity
	
	var actual_velocity = move_and_slide(
		Vector2(velocity.x * speed * direction, velocity.y),
		Vector2.UP
	)
	
	if actual_velocity.x == 0 or not edge_ray_cast.is_colliding():
		direction *= -1
		animated_sprite.flip_h = direction == 1
		edge_ray_cast.position.x *= -1


func apply_gravity():
	velocity.y = min(velocity.y + gravity, max_gravity)

