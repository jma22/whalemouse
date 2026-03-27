extends CharacterBody3D

@export var speed := 5.0
@export var acceleration := 10.0
@export var friction := 10.0

@onready var sprite: AnimatedSprite3D = $AnimatedSprite3D

func _physics_process(delta: float) -> void:
	var input_dir := Vector2.ZERO
	if Input.is_key_pressed(KEY_A):
		input_dir.x -= 1
	if Input.is_key_pressed(KEY_D):
		input_dir.x += 1
	if Input.is_key_pressed(KEY_W):
		input_dir.y -= 1
	if Input.is_key_pressed(KEY_S):
		input_dir.y += 1
	input_dir = input_dir.normalized()

	var direction := Vector3(input_dir.x, 0, input_dir.y)

	if direction.length() > 0:
		velocity.x = lerp(velocity.x, direction.x * speed, acceleration * delta)
		velocity.z = lerp(velocity.z, direction.z * speed, acceleration * delta)
	else:
		velocity.x = lerp(velocity.x, 0.0, friction * delta)
		velocity.z = lerp(velocity.z, 0.0, friction * delta)

	move_and_slide()

	# Flip sprite based on X direction
	if input_dir.x < 0:
		sprite.flip_h = true
	elif input_dir.x > 0:
		sprite.flip_h = false

	# Animation
	var horizontal_speed := Vector2(velocity.x, velocity.z).length()
	if horizontal_speed > 0.5:
		if sprite.animation != "walk":
			sprite.play("walk")
	else:
		sprite.stop()
