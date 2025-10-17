extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const FALL_SPEED := 200.0

@onready var fall_check_ray: RayCast2D = $FallCheckRay

var is_falling_through = false


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		if not Input.is_action_pressed("ui_down"):
			velocity.y = JUMP_VELOCITY
		elif fall_check_ray.is_colliding():
			var platform = fall_check_ray.get_collider()
			if platform.is_in_group("fall_through_platforms"):
				# player fall
				is_falling_through = true
				# 即使你禁用了碰撞层，物理引擎仍需 ​​1-2帧​​ 完全解除交互关系，此时高速下坠的角色仍会短暂影响吊桥。
				# 而我们需要立刻固定这座桥
				if platform is RigidBody2D:
					platform.freeze = true
				
				set_collision_mask_value(platform.collision_layer, false)
				velocity.y = FALL_SPEED  # 强制下坠
				await get_tree().create_timer(0.1).timeout
				set_collision_mask_value(platform.collision_layer, true)
				
				if platform is RigidBody2D:
					platform.freeze = false
				is_falling_through = false
			else:
				print("当前平台不允许穿透")
				

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
